
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Ajout_reclamation.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';

class HomePageList extends StatefulWidget {
  @override
  _HomePageListState createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {
  late Future<List<Reclamation>> _ReclamationFuture;  // Modifier le type pour une liste
  @override
  void initState() {
    super.initState();
    _ReclamationFuture = fetchReclamations();
    
    _loadReclamations();
  }

  List<Reclamation> reclamations = [];
void _refreshReclamations() {
  setState(() {
    _ReclamationFuture = fetchReclamations(); // Recharge les données
  });
}

  // Function to add a reclamation
  void _addReclamation(List<Reclamation> reclamation) {
    setState(() {
     // reclamations.add(reclamation);
    });
  }

  // Function to edit a reclamation
  void _editReclamation(Map<String, dynamic> updatedReclamation, int index) {
    setState(() {
      //reclamations[index] = updatedReclamation;
    });
  }

  // Function to delete a reclamation
  void _deleteReclamation(int index, String idrec) async {
    bool? confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete == true) {
      final deleted= await THttpHelper.postBooleen(
         'AnulerRcl',
         {
            'Id':idrec,
          },
          (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseReclamation(responseBody);
          },
      
    );
    
      if (deleted){
      if (index >= 0 && index < reclamations.length) {
      reclamations.removeAt(index);
 }
 _refreshReclamations();
}
    }
  }

  // Show delete confirmation dialog
  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmer la suppression',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(
              'Êtes-vous sûr de vouloir supprimer cette réclamation ?',
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

  // Function to get the state icon and color
  Icon _getStateIcon(int? state) {
    switch (state) {
      case '0':
        return Icon(Icons.hourglass_empty, size: 22, color: Colors.orange);
      case '-1':
        return Icon(Icons.autorenew, size: 22, color: const Color.fromARGB(255, 233, 29, 46));
      case '1':
        return Icon(Icons.check_circle, size: 22, color: Colors.green);
      default:
        return Icon(Icons.error, size: 22, color: Colors.grey);
    }
  }




Future<void> _navigateToReclamationForm(BuildContext context, [Reclamation? reclamation]) async {
  final bool? dataUpdated = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Reclamation_Page(initialReclamation: reclamation),
    ),
  );

  // Rechargez la liste si une mise à jour a été effectuée
  if (dataUpdated == true) {
    await _loadReclamations();
  }
}

Future<void> _loadReclamations() async {
final fetchedReclamations = await fetchReclamations();
 if (mounted) {
  setState(() {
       reclamations = fetchedReclamations;
  });}
}














Future<int?> fetchCitoyen() async {
  final citoyens = await SharedPreferencesHelper.getCitoyens();
  if (citoyens.isNotEmpty) {
    print('${citoyens.first.id_citoyen}');
     
    return citoyens.first.id_citoyen;
  }

}





Future<List<Reclamation>> fetchReclamations() async {
  final int? id = await fetchCitoyen();
  String idcit=id.toString();
print('id=$id');
  try {
    final reclamations= await THttpHelper.get<Reclamation>(
      'GetListeRcl',
      parseReclamation,  
      queryParameters: {'Citoyen': idcit},  
    );
    if (reclamations.isNotEmpty) {
        return reclamations;  // Retourner la liste d'articles
      } else {
        throw Exception("Aucun article trouvé pour l'ID $id");
      }
  } catch (e) {
    print('Erreur lors de la récupération de l\'article avec ID $id : $e');
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
          francais?"Liste des Réclamations":"قائمة الشكاوى",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color.fromARGB(255, 176, 5, 8),
        elevation: 3,
      ),
      body:  FutureBuilder <List<Reclamation>>(
                future: _ReclamationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
return Center(child: CircularProgressIndicator());
} else if (snapshot.hasError) {
return Center(child: Text('Error: ${snapshot.error}'));
} else if (!snapshot.hasData || snapshot.data!.isEmpty || snapshot.data!.where((r) => r.Annule == 0).isEmpty) {
return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Image.asset(
                      'assets/exclamation2.png', // Remplacez par le chemin de votre image
                      width: 700,
                      height: 700,
                      fit: BoxFit.contain,
                    ),
                  ),
                   Expanded(
                    flex: 1,
                    child: Text(francais?
                      "Aucune réclamation!":"لا يوجد شكاوي حاليا",
                      style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
}
              var reclamations=snapshot.data!; 
              var filteredReclamations = reclamations.where((r) => r.Annule == 0).toList();
              return SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredReclamations.length,
                itemBuilder: (context, index) {
                  final reclamation = filteredReclamations[index];
                  return Dismissible(
                    key: Key(reclamation.id_rec.toString()),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      color: Colors.redAccent,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: const Color.fromARGB(255, 0, 217, 255).withOpacity(0.2),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        final updatedReclamation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Reclamation_Page(
                                initialReclamation: reclamation),
                          ),
                        );
                        if (updatedReclamation != null) {
                          _editReclamation(updatedReclamation, index);
                          _refreshReclamations();
                        }
                        return false;
                      } else if (direction == DismissDirection.startToEnd) {
                        _deleteReclamation(index, reclamation.id_rec.toString());
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
                              // Gradient icon added here for "Objet"
                              Row(
                                children: [
                                  Icon(Icons.subject_rounded,
                                      size: 22,
                                      color: Color.fromARGB(255, 12, 98, 184)),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      francais?'Objet: ${reclamation.Objet}':"${reclamation.Objet}:الموضوع",
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black87),
                                            overflow: TextOverflow.ellipsis, ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.date_range,
                                      size: 22,
                                      color: Color.fromARGB(147, 3, 215, 49)),
                                  SizedBox(width: 10),
                                  Text(
                                    francais?'Date:${reclamation.date}':" ${reclamation.date} التاريخ",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black87)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  _getStateIcon(reclamation.Etat), // Providing default value if 'etat' is null
                                  SizedBox(width: 10),
                                  Text(francais?
                                    'État: ${reclamation.Etat?? 'Non défini'}':"الحالة: ${reclamation.Etat?? 'Non défini'}", // Providing default value for 'etat'
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
    ),);},),
            
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToReclamationForm(context),
        /* () async {
          final newReclamation = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Reclamation_Page(),
            ),
          );
          if (newReclamation != null) {
            _addReclamation(newReclamation);
            _refreshReclamations();
          }
        },*/
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromARGB(255, 176, 5, 8),
      ),
    );
  }
}
