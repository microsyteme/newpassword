
import 'package:portail_municipalite/widgets/bottomappbar.dart'; 
import 'package:portail_municipalite/screens/AccueilPage.dart';  
import 'package:portail_municipalite/authentification/login.dart';
import 'package:flutter/material.dart';
import '../API/httpreq.Dart';
import '../API/ParseXMlFile.dart';
import '../API/classes.dart';
import 'package:portail_municipalite/authentification/code_passeword.dart';
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureTextConfirm = true; // For confirming password visibility
  String _errorMessage = '';

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController(); // For "Prénom"
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // For password confirmation
  final TextEditingController _phoneController =TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _signUp() async{
  if (_formKey.currentState!.validate()) {
    setState(() {
      _errorMessage = '';
    });

    try {
      // Appeler la méthode post pour vérifier les informations de connexion
      final inscrit = await THttpHelper.postint(
        'SetCitoyen', // Endpoint de l'API
        {
          'Code': _emailController.text,
          'Nom': _usernameController.text,
          'Prenom':_prenomController.text,
          'Tel':_phoneController.text,
          'Pass':_confirmPasswordController.text,
        },
       parseCitoyen
      );

     print("code===$inscrit");
   
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VerificationPage(email: _emailController.text,mdp:_confirmPasswordController.text)),
        );
    
    } catch (e) {
 
      setState(() {
        _errorMessage = '$e';
      });
    }
  } else {
    setState(() {
      _errorMessage = "Corriger les erreurs s/'il vous plaît!";
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack to overlay the logo on top of the background image
            Container(
              width: double.infinity,
              height: 350,
              child: Stack(
                children: [
                  // Background image
                  Padding(
                    padding: const EdgeInsets.only(left: 1),
                    child: Image.asset(
                      "assets/Path.png", // Change this path to your image file
                      fit: BoxFit.cover, // Ensure the image covers the area
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Logo at the top of the background
                  Positioned(
  top: 30, // Adjust the top position as needed
  left: 20, // Adjust left position for logo
  child: Container(
    height: 90, // Increased size of the logo
    width: 90, // Increased width of the logo
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4), // Shadow color (adjust opacity)
          blurRadius: 10, // The blur radius of the shadow
          spreadRadius: 1, // Spread radius to make the shadow bigger
          offset: Offset(2, 2), // Position of the shadow (X, Y offset)
        ),
      ],
    ),
    child: Image.asset(
      "assets/muni.png", // Replace with the actual logo path
      fit: BoxFit.contain, // Ensures the image scales without distortion
    ),
  ),
),

                  // Title inside the Stack (overlapping the background and logo)
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 120),
                        Text(
                          "Inscription",
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
                    // Prénom field
                    TextFormField(
                      controller: _prenomController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Prénom',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Entrer votre prénom',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre prénom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Nom field (Username)
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Nom',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Entrer votre nom',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email field
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

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Mot de Passe',
                        labelStyle: TextStyle(color: Colors.black),
                        hintText: 'Entrer votre mot de passe',
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre mot de passe';
                        }
                        if (value.length < 8) {
                          return 'Le mot de passe doit contenir au moins 8 caractères';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureTextConfirm,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Confirmer Mot de Passe',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Confirmer votre mot de passe',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirm ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextConfirm = !_obscureTextConfirm;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirmer votre mot de passe';
                        }
                        if (value != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    //phone 
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Numéro de Téléphone',
                        labelStyle: const TextStyle(color: Colors.black),
                        hintText: 'Entrer votre Numéro de Téléphone',
                        hintStyle: const TextStyle(color: Colors.grey),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer votre Numéro de Téléphone';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 45,
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  backgroundColor: WidgetStateProperty.all(
                    const Color.fromARGB(255, 236, 4, 4),
                  ),
                ),
                onPressed: _signUp,
                child: const Text(
                  "Créer un Compte",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Vous avez déjà un compte ?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: const Text(
                    'Connexion',
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
