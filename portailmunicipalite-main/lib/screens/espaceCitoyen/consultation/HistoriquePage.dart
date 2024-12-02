import 'package:flutter/material.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'listt_sujets.dart'; // Ce fichier doit contenir historiqueSujets
import 'package:portail_municipalite/screens/espaceCitoyen/consultation/form_consultation.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
class HistoriquePage extends StatefulWidget {
  final List<Sujet>? listesujets;

  const HistoriquePage({
    Key? key, // Correction de la clé
    this.listesujets, // Liste des sujets
  }) : super(key: key);

  @override
  _HistoriquePageState createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  // Méthode pour supprimer un avis ou un sujet
  
  void _deleteAvis(int index, String id_consultation, List<Consultation> consultations) async{
    bool? confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete == true) {
        final deleted = await THttpHelper.postBooleen(
          'AnulerConsultation',
          {
            'Id':id_consultation,
          },
          (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseConsultation(responseBody);
          },
          );
          if (deleted){
            if (index >=0 && index < consultations.length){
                consultations.removeAt(index);
            }
          }

    }
  }
  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer?',
              style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Annuler', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }




Future<int?> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     
    return citoyens.first.id_citoyen;
  }

}



Future <List<Consultation>>  fetchconsultationParSujet(Sujet sujet) async{
  final int? id = await fetchCitoyen();
  String idcit=id.toString();
  print('id=$id');
  print(sujet.code.toString());
  try {
    final consultations= await THttpHelper.get<Consultation>(
      'GetLstCltCitoyen',
      parseConsultation,  
      queryParameters: {
        'Citoyen': idcit,
        'Sujet': sujet.code.toString(),
        },  
    );
    
        return consultations;  // Retourner la liste d'articles
      
  } catch (e) {
    print('Erreur lors de la récupération de l\'consultation avec ID $id : $e');
    rethrow;
  }
}




Future <List<Consultation>>  fetchconsultation() async{
  final int? id = await fetchCitoyen();
  String idcit=id.toString();
  print('id=$id');
  try {
    final listeconsultations= await THttpHelper.get<Consultation>(
      'GetListeConsultation',
      parseConsultation,  
      queryParameters: {
        'Citoyen': idcit,
        },  
    );
    if (listeconsultations.isNotEmpty) {
        return listeconsultations;  // Retourner la liste d'articles
      } else {
        throw Exception("Aucun consultation trouvé pour l'ID $id");
      }
  } catch (e) {
    print('Erreur lors de la récupération de l\'consultation avec ID $id : $e');
    rethrow;
  }
}






  @override
  Widget build(BuildContext context) {
     bool francais = Provider.of<LanguageProvider>(context).isFrench;
      
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  Text(francais?
          "Historique des Sujets":"تاريخ الاستشارات",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Consultation>>(
      future: fetchconsultation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return  Center(
              child: Text(francais?
                "Aucune consultation pour le moment.":"لا يوجد استشارات حاليا",
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
            );
        }
        var liste_conslt= snapshot.data!;
        
  
        return ListView.builder(
              itemCount: widget.listesujets!.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) {
                final sujet = widget.listesujets![index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        // Afficher le sujet et l'icône de suppression
                        ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Color.fromARGB(255, 176, 5, 8),
                          ),
                          title: Text( francais?
                            sujet.libelle : sujet.libelle_Ar,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          
                        ),
                        // ExpansionTile pour afficher les détails des avis

ExpansionTile(
  title: Text(francais?
    'Consulter les avis':"استعراض الآراء",
    style: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.bold,
      color: Colors.black54,
    ),
  ),
  children: [
    FutureBuilder<List<Consultation>>(
      future: fetchconsultationParSujet(sujet),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return  Center(
            child: Text( francais?
              'Aucune consultation trouvée pour ce sujet.':"لا يوجد اراء لهذا الموضوع حاليا",
              style: TextStyle(fontSize: 14.0, color: Colors.black54),
            ),
          );
        }

        final consultations = snapshot.data!;
      var filteredconsultations = consultations.where((r) => r.Annule == 0).toList();

        print('idsujet==${sujet.code.toString()}');
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredconsultations.length,
          itemBuilder: (context, i) {
            final consultation = filteredconsultations[i];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( francais?
                    "Date : ${consultation.date ?? 'Non spécifiée'}":"التاريخ:${consultation.date ?? "غير محدد"}",
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    consultation.commentaire ??
                       (francais? 'Aucune description disponible': "لا يوجد وصف "),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConsultationPage(
                            initialData: consultation,
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Implémentez la suppression ici si nécessaire
                      _deleteAvis(index,consultation.id_consultation.toString(), consultations);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    ),
  ],
),
                      ],
                    ),
                  ),
                );
              },
            );},),
    );
  }
}

