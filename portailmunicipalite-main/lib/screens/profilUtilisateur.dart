/*import 'package:flutter/material.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/widgets/bottomappbar.dart'; 
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';

class ProfilUtilisateur extends StatefulWidget {
  final bool francais;

  const ProfilUtilisateur({Key? key, required this.francais}) : super(key: key);

  @override
  State<ProfilUtilisateur> createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {
  
  int? IdCitoyen;
  String nom = '', prenom = '', number = '', email = '';

  @override
  void initState() {
    super.initState();
    fetchCitoyen();
  } 
Future<void> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     setState(() {
    IdCitoyen= citoyens.first.id_citoyen;
    nom= citoyens.first.Nom;
    prenom=citoyens.first.Prenom;
    number= citoyens.first.Tel;
    email= citoyens.first.Email;

     });

  }
}



  @override
  Widget build(BuildContext context) {
        bool francais = Provider.of<LanguageProvider>(context).isFrench;

        void logout() async {
      await SharedPreferencesHelper.clearCitoyensData();
  await SharedPreferencesHelper.saveLoginStatus(false); 
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => BottomAppBarDemo()), 
  );
}
    return Scaffold(
      body:  Stack(
        children: [
         
          ClipPath(
            clipper: CurveClipper(),
            child: Container(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 218, 24, 10), 
                    Color.fromARGB(255, 230, 80, 50), 
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AppBar-like section with back button
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 120), 
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/muni.png', // Path to your image
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$nom $prenom",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Profile Details
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    buildProfileItem(Icons.phone, francais? "Téléphone":"الهاتف", "$number"),
                    buildProfileItem(Icons.email, francais? "Email":"البريد الالكتروني", "$email"),
                    buildProfileItem(Icons.lock,francais? "Mot de passe":"كلمة السر", "********"),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        logout();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromARGB(255, 218, 24, 10),
                      ),
                      child: Text(
                        francais?
                        "Déconnexion": "تسجيل خروج",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for profile items
  Widget buildProfileItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 218, 24, 10), size: 28),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the curve
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2, size.height, 
      size.width, size.height - 100, 
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

*/


import 'package:flutter/material.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/widgets/bottomappbar.dart'; 
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';

class ProfilUtilisateur extends StatefulWidget {
  final bool francais;

  const ProfilUtilisateur({Key? key, required this.francais}) : super(key: key);

  @override
  State<ProfilUtilisateur> createState() => _ProfilUtilisateurState();
}

class _ProfilUtilisateurState extends State<ProfilUtilisateur> {
  int? idCitoyen;
  String nom = '', prenom = '', number = '', email = '';
  bool isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCitoyen();
  }

  Future<void> fetchCitoyen() async {
    final citoyens = await SharedPreferencesHelper.getCitoyens();
    if (citoyens.isNotEmpty) {
      setState(() {
        idCitoyen = citoyens.first.id_citoyen;
        nom = citoyens.first.Nom;
        prenom = citoyens.first.Prenom;
        number = citoyens.first.Tel;
        email = citoyens.first.Email;

        // Set initial values for the controllers
        _nomController.text = nom;
        _prenomController.text = prenom;
        _numberController.text = number;
        _emailController.text = email;
      });
    }
  }

  Future<void> saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Appeler l'API pour mettre à jour les données
      try {
        final updated = await THttpHelper.postBooleen(
          'UpdateCitoyen',
          {
            'Id': idCitoyen.toString(),
            'Nom': _nomController.text,
            'Prenom': _prenomController.text,
            'Tel': _numberController.text,
            'Email': _emailController.text,
          },
          (responseBody) => responseBody == 'true',
        );

        if (updated) {
          setState(() {
            nom = _nomController.text;
            prenom = _prenomController.text;
            number = _numberController.text;
            email = _emailController.text;
            isEditing = false;
          });
        }
      } catch (e) {
        // Gérer les erreurs
        print('Erreur : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool francais = Provider.of<LanguageProvider>(context).isFrench;

    void logout() async {
      await SharedPreferencesHelper.clearCitoyensData();
      await SharedPreferencesHelper.saveLoginStatus(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomAppBarDemo()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 218, 24, 10),
                    Color.fromARGB(255, 230, 80, 50),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 120),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/muni.png',
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$nom $prenom",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          buildEditableProfileItem(
                            Icons.person,
                            francais ? "Nom" : "الاسم",
                            _nomController,
                          ),
                          buildEditableProfileItem(
                            Icons.person_outline,
                            francais ? "Prénom" : "اللقب",
                            _prenomController,
                          ),
                          buildEditableProfileItem(
                            Icons.phone,
                            francais ? "Téléphone" : "الهاتف",
                            _numberController,
                          ),
                          buildEditableProfileItem(
                            Icons.email,
                            francais ? "Email" : "البريد الإلكتروني",
                            _emailController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    if (isEditing)
                      ElevatedButton(
                        onPressed: saveChanges,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Color.fromARGB(255, 218, 24, 10),
                        ),
                        child: Text(
                          francais ? "Enregistrer" : "حفظ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.grey,
                      ),
                      child: Text(
                        isEditing
                            ? (francais ? "Annuler" : "إلغاء")
                            : (francais ? "Modifier" : "تعديل"),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Color.fromARGB(255, 218, 24, 10),
                      ),
                      child: Text(
                        francais ? "Déconnexion" : "تسجيل خروج",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildEditableProfileItem(
      IconData icon, String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Color.fromARGB(255, 218, 24, 10), size: 28),
          SizedBox(width: 20),
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: isEditing,
              decoration: InputDecoration(
                labelText: title,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est requis';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Clipper for the curve
class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
