import 'package:flutter/material.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'form_consultation.dart'; // Assuming this is your consultation page
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';

class SubjectDetailPage extends StatelessWidget {
  final Sujet sujet;

  const SubjectDetailPage({Key? key, required this.sujet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     bool francais = Provider.of<LanguageProvider>(context).isFrench;
   
    return Scaffold(
      appBar: AppBar(
        title: Text(francais?
          sujet.libelle: sujet.libelle_Ar,
          style:const TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
          children: <Widget>[
            // Sujet Title at the top
            Text(
              francais?
              sujet.libelle : sujet.libelle_Ar,
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 176, 5, 8),
              ),
            ),
            const SizedBox(height: 20),
            
            // Description or Article text related to the subject
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    francais?
                    'Description du sujet :':"وصف الموضوع",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 176, 5, 8),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    francais? sujet.Description: sujet.Description_Ar,
                    style: TextStyle(fontSize: 16.0, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Button to give feedback
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to consultation page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConsultationPage(sujet: sujet),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 176, 5, 8),
                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text( francais?
                  "Donner mon avis":"أبدي رأيي",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}