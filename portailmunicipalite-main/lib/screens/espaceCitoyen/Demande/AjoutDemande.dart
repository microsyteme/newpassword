import 'package:flutter/material.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';
class AjoutDemande extends StatefulWidget {
  final Demande? initialAcces;

  AjoutDemande({Key? key, this.initialAcces}) : super(key: key);

  @override
  _AjoutDemandeState createState() => _AjoutDemandeState();
}

class _AjoutDemandeState extends State<AjoutDemande> {
  final _formKey = GlobalKey<FormState>();

  // Déclarer les contrôleurs pour chaque champ
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _objetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

late String nomCitoyen, prenomCitoyen,telCitoyen;
late int IdCitoyen;


Future<void> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     setState(() {
    IdCitoyen= citoyens.first.id_citoyen;
    nomCitoyen=citoyens.first.Nom;
    prenomCitoyen=citoyens.first.Prenom;
    telCitoyen=citoyens.first.Tel;
    _nameController.text = nomCitoyen;
    _prenomController.text = prenomCitoyen;
    _telephoneController.text = telCitoyen;
    });

  }
}






  @override
  void initState() {
    super.initState();
    if (widget.initialAcces != null) {
      _objetController.text = widget.initialAcces!.Objet ?? '';
      _dateController.text = widget.initialAcces!.Date ;
      _descriptionController.text = widget.initialAcces!.Message ;
    }
    fetchCitoyen();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _objetController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

     if (pickedDate != null) {
    // Formater la date au format "jour/mois/année"
    String formattedDate = 
        '${pickedDate.day.toString().padLeft(2, '0')}/'
        '${pickedDate.month.toString().padLeft(2, '0')}/'
        '${pickedDate.year}';

    setState(() {
      _dateController.text = formattedDate;
    });
  }
  }


Future <void> add_demande(String endpoint, Map<String, String> contenu)  async{
  try {

        final success = await THttpHelper.postBooleen(
          endpoint,
         contenu,
          (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseDeamnde(responseBody);
          },
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Demande ajoutée avec succès")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Échec de l'ajout de la demande")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      }
}
  @override
  Widget build(BuildContext context) {
        bool francais = Provider.of<LanguageProvider>(context).isFrench;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          francais?"Formulaire d'accès à l'information":"استمارة طلب النفاذ الى المعلومات", style: TextStyle(fontSize: 20, color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              _buildTextField(_nameController, francais? 'Nom':"اللقب", enabled: false),  // Nom non modifiable
              _buildTextField(_prenomController, francais?'Prénom':"الاسم", enabled: false),  // Prénom non modifiable
              _buildTextField(_telephoneController,francais? 'Numéro de téléphone':"رقم الهاتف", enabled: false),  // Numéro de téléphone non modifiable
              _buildTextField(_objetController, francais?'Objet':"الموضوع"),
              _buildTextField(_descriptionController, francais?'Description':"الوصف", maxLines: 4),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                          if (IdCitoyen == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(francais?"ID du citoyen introuvable":"")),
                                );
                                return;
                              }   
Map<String, String> contenu;
String endpoint;
if (widget.initialAcces != null) {
  contenu={
          'Id':widget.initialAcces!.id_acces.toString(),
          'Message':_descriptionController.text,
          'Objet':_objetController.text,
  };
endpoint='UpdateAcces';
} else {
  contenu={
            'Citoyen': IdCitoyen.toString(),
            'Message': _descriptionController.text,
            'Objet': _objetController.text,
          };
 endpoint='SetAcces';
 
}
  // Vérifiez si le formulaire est valide avant d'envoyer la requête
    if (_formKey.currentState!.validate()) {
      add_demande(endpoint,contenu);
      Navigator.pop(context)  ;  }
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 176, 5, 8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 5,
                  ),
                  child: Text(francais?"Soumettre":"ارسال", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, {int maxLines = 1, bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color.fromARGB(208, 123, 123, 123)),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 176, 5, 8), width: 2.0),
          ),
        ),
        maxLines: maxLines,
        enabled: enabled,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $labelText';
          }
          return null;
        },
      ),
    );
  }

  
}
