import 'package:flutter/material.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'listt_sujets.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';
class ConsultationPage extends StatefulWidget {
  final Sujet? sujet;
  final Consultation? initialData;
  final Function(Map<String, String>)? onSave;

  const ConsultationPage({
    Key? key,
     this.sujet,
    this.initialData,
    this.onSave,
  }) : super(key: key);

  @override
  _ConsultationPageState createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
late int IdCitoyen;


Future<void> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     setState(() {
    IdCitoyen= citoyens.first.id_citoyen;
    });

  }
}





  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _descriptionController.text = widget.initialData!.commentaire ?? '';
    }
    fetchCitoyen();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

 Future <void> add_consultation(String endpoint, Map<String, String> contenu) async{

        try{
            final consultation = await THttpHelper.postBooleen(
              endpoint,
               contenu, 
               (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseConsultation(responseBody);
          },
               );

            if (consultation) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Demande ajoutée avec succès")),
            
          );
          
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DesignerListScreen(), // Replace with your list screen page
      ),
    );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Échec de l'ajout de la demande")),
          );
        }


        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
        }





  }

  @override
  Widget build(BuildContext context) {
        bool francais = Provider.of<LanguageProvider>(context).isFrench;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(francais?"Votre Avis":"رأيكم", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  francais?
                  "Sujet : ${widget.sujet!.libelle}":"الموضوع : ${widget.sujet!.libelle_Ar}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 176, 5, 8),
                  ),
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                  _descriptionController,
                  francais? 'Description':"الوصف",
                  Icons.description,
                  maxLines: 4,
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
  if (_formKey.currentState!.validate()) {
    String endpoint;
    Map<String, String> contenu;

    // Remplir les valeurs de `contenu` et `endpoint` en fonction de `initialData`
    if (widget.initialData != null) {
      contenu = {
        'Id': widget.initialData!.id_consultation.toString(),
        'commentaire': _descriptionController.text,
      };
      endpoint = 'UpdateConsultation';
    } else {
      contenu = {
        'Citoyen': IdCitoyen.toString(),
        'Sujet': widget.sujet!.code.toString(),
        'Commentaire': _descriptionController.text,
      };
      endpoint = 'SetConsultation';
    }

    // Appeler la fonction `add_consultation`
    await add_consultation(endpoint, contenu);
  }
},

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 176, 5, 8),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      francais?
                      "Envoyer":"ارسال",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 176, 5, 8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label est requis';
          }
          return null;
        },
        maxLines: maxLines,
      ),
    );
  }
}