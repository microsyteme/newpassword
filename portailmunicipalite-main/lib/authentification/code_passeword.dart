import 'package:flutter/material.dart';
import 'package:portail_municipalite/API/httpreq.Dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/widgets/bottomappbar.dart'; 
import 'package:portail_municipalite/sharedPreferences_helper.dart';

class VerificationPage extends StatefulWidget {
  final String email, mdp;
  const VerificationPage({super.key, required this.email, required this.mdp});
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Fonction qui vérifie le code
  void _verifyCode()async{
    if (_formKey.currentState!.validate()) {

        try {
                    // Appeler la méthode post pour vérifier les informations de connexion
                    final citoyens = await THttpHelper.post<Citoyen>(
                      'GetCitoyen', // Endpoint de l'API
                      {
                        'Code': widget.email,
                        'Pass': widget.mdp,
                      },
                      (responseBody) {
                        // Analyser la réponse XML et retourner une liste de Citoyen
                        return parseCitoyen(responseBody);
                      },
                    );

                    // Vérifiez si des données ont été retournées
                    if (citoyens.isNotEmpty && _codeController.text == citoyens.first.Verif) {
                    await SharedPreferencesHelper.saveCitoyens(citoyens);
                 // mise à jour de la valeur actif de citoyen
                 final active= await THttpHelper.postBooleen(
                      'ActiverCitoyen', 
                      {
                        'Code': widget.email,
                       
                      },
                      (responseBody) {
                        // Analyser la réponse XML et retourner une liste de Citoyen
                        return parseCitoyen(responseBody);
                      },
                    );;
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BottomAppBarDemo()),
                      );
                    } else {
                       setState(() {
          _errorMessage = 'Le code que vous avez entré est incorrect';
        });
                    }
                  } catch (e) {
                    // En cas d'erreur (par ex., problème réseau ou serveur)
                    setState(() {
                      _errorMessage = '$e';
                    });
                  }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vérification du Code',style:TextStyle(color: Colors.white,fontSize: 20),),
        backgroundColor: Color.fromARGB(255, 236, 4, 4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ajout d'une image avant le champ de saisie
              Image.asset(
                'assets/lettre.png',  // Remplacez par le chemin de votre image
                height: 100,  // Ajustez la taille de l'image si nécessaire
                width: 100,
              ),
              SizedBox(height: 20),

              // Titre de la page
              Text(
                "Entrez le code de vérification envoyé par email",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Champ de texte pour le code de vérification
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Code de vérification',
                  border: OutlineInputBorder(),
                  hintText: 'Entrez le code reçu par email',
                ),
                keyboardType: TextInputType.number,
                maxLength: 5,  // Limite le nombre de caractères à 6
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le code';
                  }
                  if (value.length != 5) {
                    return 'Le code doit contenir 6 chiffres';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Message d'erreur si le code est incorrect
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              // Bouton pour soumettre le code
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 236, 4, 4)),
                  ),
                  onPressed: _verifyCode,
                  child: Text(
                    'Vérifier le Code',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Option pour renvoyer le code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Vous n'avez pas reçu de code ? "),
                  TextButton(
                    onPressed: () {
                      // Ajoutez ici la logique pour renvoyer le code si nécessaire
                      // Par exemple, vous pourriez appeler une fonction qui envoie un nouveau code
                    },
                    child: Text(
                      "Renvoi du code",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
