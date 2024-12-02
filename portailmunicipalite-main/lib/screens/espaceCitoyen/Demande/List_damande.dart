import 'package:flutter/material.dart';
import 'package:portail_municipalite/screens/espaceCitoyen/Demande/AjoutDemande.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:flutter/cupertino.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';
class ListDamande extends StatefulWidget {
  @override
  _ListDamandeState createState() => _ListDamandeState();
}

class _ListDamandeState extends State<ListDamande> {
   late Future<List<Demande>> _DemandeFuture;
    List<Demande> demandes=[];

  @override
  void initState() {
    super.initState();
    _DemandeFuture = fetchDemades();
  }

 
 
  // Fonction pour supprimer une réclamation
  void _deleteAcces(int index, String idaccess) async {
    bool? confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete == true) {
        final deleted = await THttpHelper.postBooleen(
          'AnulerAcces',
          {
            'Id':idaccess,
          },
          (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseReclamation(responseBody);
          },
          );
          if (deleted){
            if (index >=0 && index < demandes.length){
                demandes.removeAt(index);
            }
          }

    }
  }

  // Boîte de confirmation pour suppression
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

  // Obtenir une icône pour l'état
  Icon _getStateIcon(String state) {
    switch (state) {
      case 'En attente':
        return Icon(Icons.hourglass_empty, size: 24, color: Colors.orange);
      case 'En cours':
        return Icon(Icons.autorenew, size: 24, color: Colors.blue);
      case 'Résolu':
        return Icon(Icons.check_circle, size: 24, color: Colors.green);
      default:
        return Icon(Icons.error, size: 24, color: Colors.grey);
    }
  }

Future<int?> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     
    return citoyens.first.id_citoyen;
  }

}




Future<List<Demande>> fetchDemades() async {
  final int? id = await fetchCitoyen();
  String idcit=id.toString();
print('id=$id');
  try {
    final demandes= await THttpHelper.get<Demande>(
      'GetListeAcces',
      parseDeamnde,  
      queryParameters: {'Citoyen': idcit},  
    );
    if (demandes.isNotEmpty) {
        return demandes;  // Retourner la liste d'articles
      } else {
        throw Exception("Aucune demande trouvé pour l'ID $id");
      }
  } catch (e) {
    print('Erreur lors de la récupération de l\'demande avec ID $id : $e');
    rethrow;
  }
}






  @override
  Widget build(BuildContext context) {
        bool francais = Provider.of<LanguageProvider>(context).isFrench;

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text( francais?
          "Liste des Accès":"قائمة طلبات النفاذ للمعلومة",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Color(0xFFB00508),
        elevation: 3,
       
      ),
      body: FutureBuilder <List<Demande>>(
                future: _DemandeFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty ) {
              return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/acc_inf.png', // Image pour liste vide
                      width: 400,
                      height: 400,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(francais?
                      "Aucune demande !":"",
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
}
              var demandes=snapshot.data!; 
              var filtereddemandes = demandes.where((r) => r.Annule == 0).toList();
              return SingleChildScrollView(
          child: ListView.builder(
             shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filtereddemandes.length,
              itemBuilder: (context, index) {
                final demande = filtereddemandes[index];
                return Dismissible(
                  key: Key(demande.id_acces.toString()),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red.withOpacity(0.9),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.blue.withOpacity(0.7),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      final updatedAcces = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AjoutDemande(initialAcces: demande),
                        ),
                      );
                
                      return false;
                    } else if (direction == DismissDirection.startToEnd) {
                      _deleteAcces(index,demande.id_acces.toString());
                      return false;
                    }
                    return false;
                  },
                 child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFf8f8f8), Color(0xFFf3f3f3)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                      leading: Icon(CupertinoIcons.exclamationmark_triangle,
                            size: 60, color: Color.fromARGB(255, 223, 4, 4),),
  
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.subject_rounded,
                                  size: 18, color: Colors.blueGrey),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(francais?
                                  'Objet: ${demande.Objet}':"الموضوع",
                                    style: TextStyle(fontSize: 14),
                                      
                                    overflow: TextOverflow.ellipsis, 
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.date_range,
                                  size: 18, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                francais? 'Date: ${demande.Date}':"التاريخ",
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.date_range,
                                  size: 18, color: Colors.green),
                              SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  francais?'Description: ${demande.Message}':"الوصف",
                                    style: TextStyle(fontSize: 14),
                                    
                                    
                                    overflow: TextOverflow.ellipsis, ),
                              ),
                            ],
                          ),
                          /*Row(
                            children: [
                              
                              _getStateIcon(Acces['etat'] ?? 'En attente'),
                              SizedBox(width: 8),
                              Text(
                                'État: ${Acces['etat'] ?? 'Non défini'}',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),*/
                        ],
                      ),
                    ),
                  ),),
                );
              },
            ),
            );
            },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAcces = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AjoutDemande(),
            ),
          );
          
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xFFB00508),
        elevation: 10,
      ),
    );
  }
}



