import 'package:portail_municipalite/newpassword.dart';
import 'package:portail_municipalite/widgets/bottomappbar.dart'; 
import 'package:portail_municipalite/authentification/resetPasswordScreen.dart';
import 'package:portail_municipalite/authentification/signup.dart';
import 'package:flutter/material.dart';
import '../API/httpreq.Dart';
import '../API/ParseXMlFile.dart';
import '../API/classes.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/authentification/code_passeword.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              height: 350,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Image.asset(
                      "assets/Path.png", // Use the same image as the sign-up page
                    ),
                  ),
                  Positioned(
                    top: 30, // Adjust the top position as needed
                    left: 20, // Adjust left position for logo
                    child: Container(
                      height: 100, // Increased size of the logo
                      width: 100, // Increased width of the logo
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5), // Shadow color (adjust opacity)
                            blurRadius: 10, // The blur radius of the shadow
                            spreadRadius: 2, // Spread radius to make the shadow bigger
                            offset: Offset(5, 5), // Position of the shadow (X, Y offset)
                          ),
                        ],
                      ),
                      child: Image.asset(
                        "assets/muni.png", // Replace with the actual logo path
                        fit: BoxFit.contain, // Ensures the image scales without distortion
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 120),
                        Text(
                          "Connexion",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email TextField
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Adresse Email',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Entrer votre email',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'L\'email doit contenir : @';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Mot De Passe',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Entrer votre mot de passe',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre mot de passe';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Login Button
            SizedBox(
              height: 45,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 4, 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              onPressed: () async {
                SharedPreferencesHelper.saveLoginStatus(true);
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _errorMessage = '';
                  });

                  try {
                    // Appeler la méthode post pour vérifier les informations de connexion
                    final citoyens = await THttpHelper.post<Citoyen>(
                      'GetCitoyen', // Endpoint de l'API
                      {
                        'Code': _emailController.text,
                        'Pass': _passwordController.text,
                      },
                      (responseBody) {
                        // Analyser la réponse XML et retourner une liste de Citoyen
                        return parseCitoyen(responseBody);
                      },
                    );

                    // Vérifiez si des données ont été retournées
                    if (citoyens.isNotEmpty) {
                      if(citoyens.first.Actif==1){
                    await SharedPreferencesHelper.saveCitoyens(citoyens);
                 
                      // Si connexion réussie, naviguez vers AccueilPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomAppBarDemo()),
                      );} else{
                         Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>VerificationPage(email: _emailController.text, mdp: _passwordController.text)),);
                      }
                    } else {
                      // Si la liste est vide, afficher un message d'erreur
                      setState(() {
                        _errorMessage = 'Email ou mot de passe incorrcet.';
                      });
                    }
                  } catch (e) {
                    // En cas d'erreur (par ex., problème réseau ou serveur)
                    setState(() {
                      _errorMessage = '$e';
                    });
                  }
                } else {
                  setState(() {
                    _errorMessage = ' Corriger les erreurs s\'il vous plaît!';
                  });
                }
},

                child: const Text(
                  "Connexion",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Error message display
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
            // Forgot password link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Newpassword()),
                );
              },
              child: const Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  color: Color.fromARGB(255, 236, 4, 4),
                  fontSize: 16,
                ),
              ),
            ),
            // Sign-up link
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Pas encore inscrit ?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: const Text(
                    'S\'inscrire',
                    style: TextStyle(color: Color.fromARGB(255, 236, 4, 4)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
