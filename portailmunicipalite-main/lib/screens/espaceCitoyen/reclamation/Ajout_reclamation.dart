import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';


class Reclamation_Page extends StatefulWidget {
  final Reclamation? initialReclamation;

  Reclamation_Page({Key? key,  this.initialReclamation}) : super(key: key);

  @override
  _Reclamation_PageState createState() => _Reclamation_PageState();
}

class _Reclamation_PageState extends State<Reclamation_Page> {
late int IdCitoyen;
late String nomCitoyen, prenomCitoyen,telCitoyen;

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




  final _formKey = GlobalKey<FormState>();
  String? _filePath;
  String _localisation = '';
  List<String> _fileNames = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _objetController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialReclamation != null) {

      _objetController.text = widget.initialReclamation!.Objet?? '';
      _dateController.text = widget.initialReclamation!.date ?? '';
      _descriptionController.text = widget.initialReclamation!.des?? '';
      _localisationController.text = widget.initialReclamation!.Localisation ?? '';
      _filePath = widget.initialReclamation!.chemin;
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
    _localisationController.dispose();
    super.dispose();
  }


  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Les services de localisation sont désactivés")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La permission de localisation est refusée")),
      );
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La permission de localisation est définitivement refusée")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _localisation = "${position.latitude}, ${position.longitude}";
      _localisationController.text = _localisation;
    });
  }
  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        _fileNames = result.files.map((file) => file.name).toList();
      });
    }
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
Future <void> add_reclamation(String endpoint, Map<String, String> contenu)  async{
  try {
    print('endpoint=$endpoint');
    print('contenu=$contenu');
        final success = await THttpHelper.postBooleen(
          endpoint,
         contenu,
          (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseReclamation(responseBody);
          },
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Réclamation ajoutée avec succès")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Échec de l'ajout de la réclamation")),
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
          francais?"Formulaire de Réclamation":"استمارة الشكوى", style: TextStyle(fontSize: 20,color: Colors.white)),
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
              _buildTextField(_nameController,francais? 'Nom':"اللقب", enabled: false),  // Nom non modifiable
              _buildTextField(_prenomController,francais? 'Prénom':"الاسم", enabled: false),  // Prénom non modifiable
              _buildTextField(_telephoneController,francais? 'Numéro de téléphone':"رقم الهاتف", enabled: false),  // Numéro de téléphone non modifiable
              
                _buildTextField(_objetController, francais?'Objet':"الموضوع"),
              
                _buildTextField(_descriptionController,francais? 'Description':"الوصف", maxLines: 4),
                _buildTextField(_localisationController,francais? 'Localisation':"الموقع الجغرافي", enabled: false),
                SizedBox(height: 16.0),

                ElevatedButton.icon(
                  onPressed: _getUserLocation,
                  icon: Icon(Icons.location_on, size: 18),
                  label: Text(francais?"Obtenir la géolocalisation":"الحصول على الموقع الجغرافي"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 176, 5, 8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                SizedBox(height: 16.0),
                
                _buildFilePickerSection(francais),
                SizedBox(height: 16.0),

ElevatedButton(
  onPressed: () async {
   
    if (IdCitoyen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(francais?"ID du citoyen introuvable":"معرّف المواطن غير موجود")),
      );
      return;
    }
Map<String, String> contenu;
String endpoint;
if (widget.initialReclamation != null) {
  contenu={
          'Id':widget.initialReclamation!.id_rec.toString(),
          'description':_descriptionController.text,
          'Local':_localisationController.text,
          'Objet':_objetController.text,
  };
endpoint='UpdateRcl';
} else {
  contenu={
            'Citoyen': IdCitoyen.toString(),
            
            'description': _descriptionController.text,
            'Local':_localisationController.text,
            'Objet': _objetController.text,
          };
 endpoint='SetReclamation';
 
}
    // Vérifiez si le formulaire est valide avant d'envoyer la requête
    if (_formKey.currentState!.validate()) {
      add_reclamation(endpoint,contenu);
      Navigator.pop(context,true)  ;  }
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

  Widget _buildFilePickerSection(bool francais) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: _pickFiles,
          icon: Icon(Icons.attach_file),
          label: Text(francais?"Ajouter des fichiers":"اضف ملفات"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 176, 5, 8),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        SizedBox(width: 8.0),
        Expanded(
          child: Text(
            _fileNames.isNotEmpty ? _fileNames.join(', ') : (francais?"Aucun fichier sélectionné":"لم يتم اختيار أي ملف"),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  
}
