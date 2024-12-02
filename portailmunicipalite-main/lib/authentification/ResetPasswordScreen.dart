
import 'package:flutter/material.dart';
import 'package:portail_municipalite/authentification/code_passeword.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Update AppBar color
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 4, 4), // Updated to the new red color
        title: const Text('Réinitialiser le Mot de Passe',style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Entrer votre email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'L\'email doit contenir : @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Reset button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _errorMessage = ''; // Reset previous error messages
                    });
                    // Reset password logic (e.g., sending email)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Un email a été envoyé pour réinitialiser votre mot de passe.')),
                    );
      
                  } else {
                    setState(() {
                      _errorMessage = 'Veuillez entrer un email valide';
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 4, 4), // Updated to the new red color
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Réinitialiser le Mot de Passe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Button text in white
                  ),
                ),
              ),

              // Error message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red), // Error text in red
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
