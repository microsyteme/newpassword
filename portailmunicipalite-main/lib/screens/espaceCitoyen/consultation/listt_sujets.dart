

import 'package:portail_municipalite/screens/espaceCitoyen/consultation/detailspage.dart';
import 'package:portail_municipalite/screens/espaceCitoyen/consultation/HistoriquePage.dart';
import 'package:flutter/material.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';


class DesignerListScreen extends StatefulWidget {
  @override
  _DesignerListScreenState createState() => _DesignerListScreenState();
}

class _DesignerListScreenState extends State<DesignerListScreen> {
  late Future<List<Sujet>> _sujetslist;

  @override
  void initState() {
    super.initState();
    _sujetslist = fetchSujets();
    print(_sujetslist);
  }


Future<List<Sujet>> fetchSujets() async {
  
  try {
    final sujet= await THttpHelper.get<Sujet>(
      'LstSujet',
      parseSujet,
       
    );
    if (sujet.isNotEmpty) {
        return sujet;  // Retourner la liste d'articles
      } else {
        throw Exception("Aucun article trouvé pour l'ID ");
      }
  } catch (e) {
    print('Erreur lors de la récupération de l\'article avec ID : $e');
    rethrow;
  }
}





  @override
  Widget build(BuildContext context) {
    bool francais = Provider.of<LanguageProvider>(context).isFrench;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          francais?
          "Consultation":"استشارة",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () async{
              List<Sujet>? resolvedSujets = await _sujetslist;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoriquePage(listesujets: resolvedSujets),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder <List<Sujet>>(
        future: fetchSujets(),
        builder: (context, snapshot) {
      
                  if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty ) {
return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/suggestion.png', // Replace with your image path
                      width: 700,
                      height: 700,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      francais?
                      "Aucun Sujet!":" لا يوجد موضوع",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );   
              }
      
      var sujets=snapshot.data!;
      
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Ajouter un texte avant les sujets
             Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text(francais?
                'Veuillez donner votre avis sur l\'un des sujets suivants:' : "الرجاء ابداء رأيكم في المواضيع التالية",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 11, 167, 219),
                ),
              ),
            ),

            // Liste des sujets
            Expanded(
              child: ListView.builder(
                itemCount: sujets.length,
                itemBuilder: (context, index) {
                  final sujet = sujets[index];
                  return GestureDetector(
                    onTap: () {
                      // Mettre à jour le compteur du sujet lorsque celui-ci est tapé
                     // _updateSubjectCount(sujet);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectDetailPage(
                            sujet: sujet,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 6,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          leading: const CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Color.fromARGB(255, 176, 5, 8),
                            child: Icon(
                              Icons.design_services,
                              color: Colors.white,
                              size: 26.0,
                            ),
                          ),
                          title: Text(
                            francais? sujet.libelle: sujet.libelle_Ar,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ); }
      ),
    );
  }
}