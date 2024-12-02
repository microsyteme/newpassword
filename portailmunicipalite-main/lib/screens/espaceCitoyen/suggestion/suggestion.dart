import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';



class SuggestionPage extends StatefulWidget {
  final Suggestion? initialsuggestion;

  SuggestionPage({Key? key, this.initialsuggestion}) : super(key: key);

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  String? _filePath;
  String _localisation = '';
  List<String> _fileNames = [];
  String? _selectedTheme;
  bool francais = true; // Valeur par défaut, modifiable dans didChangeDependencies
late int IdCitoyen;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Accéder au Provider ici
    francais = Provider.of<LanguageProvider>(context, listen: false).isFrench;
  }
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  
 
  Future<List<Themes>> fetchThemes() async {
  try {
    final response = await THttpHelper.get<Themes>('LstTheme', parseTheme);
    if (response.isNotEmpty) {
      return response;
    } else {
      throw Exception("Aucun thème disponible.");
    }
  } catch (e) {
    throw Exception("Erreur lors du chargement des thèmes : $e");
  }
}



Future<void> _ajoutersuggestion(String endpoint, Map<String, String> contenu) async {
  try {
    print('endpoint=$endpoint');
    print('contenu=$contenu');
    final success = await THttpHelper.postBooleen(
      endpoint,
      contenu,
      (responseBody) {
        return parseSuggestion(responseBody);
      },
    );

    if (success && mounted) {
      setState(() {
        // On ne modifie pas directement `suggestions` ici
        // Le FutureBuilder se chargera de recharger les données.
      
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Demande ajoutée avec succès")),
      );
      
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Échec de l'ajout de la demande")),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }
}


  @override
  void initState() {
    super.initState();
    if (widget.initialsuggestion != null) {
      // Préremplissage des champs pour la modification
      _selectedTheme = widget.initialsuggestion!.id_Theme.toString();
      _descriptionController.text = widget.initialsuggestion!.suggestion ?? '';
      _localisationController.text = widget.initialsuggestion!.localisation ?? '';
      //_filePath = widget.initialsuggestion!['pieceJointe'];
    }
    fetchCitoyen();
    fetchThemes();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _localisationController.dispose();
    super.dispose();
  }




Widget _buildDropdownField() {
  if (widget.initialsuggestion != null) {
    // Recherche du libellé du thème à partir de son ID
    String? themeLibelle = _selectedTheme != null
        ? francais
            ? widget.initialsuggestion!.libelle
            : widget.initialsuggestion!.libelle_Ar
        : 'Aucun thème sélectionné';

    // Non modifiable si c'est une modification
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Thème',
          labelStyle: TextStyle(color: Color.fromARGB(208, 123, 123, 123)),
          border: OutlineInputBorder(),
        ),
        child: Text(
          themeLibelle ?? 'Aucun thème sélectionné',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  } else {
    // Modifiable si c'est une création
    return FutureBuilder<List<Themes>>(
      future: fetchThemes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun thème disponible.'));
        }

        // Données chargées
        List<Themes> themes = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: DropdownButtonFormField<String>(
            value: _selectedTheme,
            items: themes.map((theme) {
              return DropdownMenuItem(
                value: theme.id_theme.toString(), // Utiliser l'ID comme valeur
                child: Text(francais ? theme.libelle : theme.libelle_Ar),
              );
            }).toList(),
            decoration: InputDecoration(
              labelText: 'Thème',
              labelStyle: TextStyle(color: Color.fromARGB(208, 123, 123, 123)),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _selectedTheme = value; // Maintenant _selectedTheme contient l'ID
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez sélectionner un thème';
              }
              return null;
            },
          ),
        );
      },
    );
  }
}


Future<void> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     setState(() {
    IdCitoyen= citoyens.first.id_citoyen;
   
    });

  }
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
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("La permission de localisation est refusée")),
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

  @override
  Widget build(BuildContext context) {
        bool francais = Provider.of<LanguageProvider>(context).isFrench;

    return Scaffold(
      appBar: AppBar(
        title: Text(francais?"Formulaire Suggestion":"استمارة الاقتراحات",
         style: TextStyle(fontSize: 20, color: Colors.white)),
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
                _buildDropdownField(),
                _buildTextField(_descriptionController, francais?'Description':'الوصف', maxLines: 4),
                _buildTextField(_localisationController,francais? 'Localisation':'الموقع الجغرافي', enabled: false),
                SizedBox(height: 16.0),
                ElevatedButton.icon(
                  onPressed: _getUserLocation,
                  icon: Icon(Icons.location_on, size: 18),
                  label: Text(francais?
                    "Obtenir la géolocalisation":"الحصول على الموقع الجغرافي"),
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
                  onPressed: () {
                    Map<String, String> contenu;
                    String endpoint;
                    if(widget.initialsuggestion != null){
                      contenu={
                        'Id':widget.initialsuggestion!.id_sugg.toString(),
                        'suggestion':_descriptionController.text,
                      };
                      endpoint='UpdateSuggestion';
                    }else{
                      contenu={
                          'Citoyen': IdCitoyen.toString(),
                          'suggestion':_descriptionController.text,
                          'Localisation':  _localisationController.text,
                          'id_theme':_selectedTheme!,
                      };
                      endpoint='SetSuggestion';
                    }
                    _ajoutersuggestion(endpoint,contenu);
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
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

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1, bool enabled = true}) {
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
          label: Text(francais?"Ajouter des fichiers":"اضافة ملفات"),
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

