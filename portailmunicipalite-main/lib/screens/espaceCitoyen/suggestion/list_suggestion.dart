import 'package:portail_municipalite/screens/espaceCitoyen/suggestion/suggestion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
import 'package:portail_municipalite/API/ParseXMlFile.dart';
import 'package:portail_municipalite/API/httpreq.dart';
import 'package:portail_municipalite/API/classes.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';




class SuggestionHomePageList extends StatefulWidget {
  @override
  _SuggestionHomePageListState createState() => _SuggestionHomePageListState();
}

class _SuggestionHomePageListState extends State<SuggestionHomePageList> {
  List<Suggestion> suggestions = [];

  // Function to add a suggestion
  void _addsuggestion(Suggestion suggestion) {
    setState(() {
     suggestions.add(suggestion);
    });
  }

  // Function to edit a suggestion
  void _editsuggestion(Suggestion updatedsuggestion, int index) {
    setState(() {
     suggestions[index] = updatedsuggestion;
    });
  }

  // Function to delete a suggestion
  /*void _deletesuggestion(int index, String idsuggestion) async {
    bool? confirmDelete = await _showDeleteConfirmation();
    if (confirmDelete == true) {
      
  final deleted = await THttpHelper.postBooleen(
          'AnulerSuggestion',
          {
            'Id':idsuggestion,
          },
          (responseBody) {
            // Analyser la réponse XML et retourner une liste de Citoyen
            return parseReclamation(responseBody);
          },
          );
          if (deleted){
            if (index >=0 && index < suggestions.length){
                 suggestions.removeAt(index);
            }
          }



       
      
    }
  }
*/
void _deletesuggestion(int index, String idsuggestion) async {
  bool? confirmDelete = await _showDeleteConfirmation();
  if (confirmDelete == true) {
    try {
      final deleted = await THttpHelper.postBooleen(
        'AnulerSuggestion',
        {'Id': idsuggestion},
        (responseBody) {
          return parseReclamation(responseBody);
        },
      );

      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Suggestion supprimée avec succès')),
        );

        // Recharger les suggestions depuis l'API
        final updatedSuggestions = await fetchSuggestion();
        setState(() {
          suggestions = updatedSuggestions;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de la suppression de la suggestion')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
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
          title: const Text('Confirmer la suppression',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: const Text('Êtes-vous sûr de vouloir supprimer cette suggestion ?',
              style: TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
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


Future<List<Suggestion>> fetchSuggestion() async {
  final int? id = await fetchCitoyen();
  String idcit=id.toString();
print('id=$id');
  try {
    final suggestion= await THttpHelper.get<Suggestion>(
      'GetListeSuggestion',
      parseSuggestion,  
      queryParameters: {'Citoyen': idcit},  
    );
    if (suggestion.isNotEmpty) {
        return suggestion;  // Retourner la liste d'articles
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
        title: Text(francais?
          "Liste des Suggestions":"قائمة الاقتراحات",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
        elevation: 3,
      ),
      body:
       FutureBuilder<List<Suggestion>>(
  future: fetchSuggestion(),
  builder: (context, snapshot) {
    print("Connection State: ${snapshot.connectionState}");

    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      print("Error: ${snapshot.error}");
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (snapshot.data == null || snapshot.data!.isEmpty || snapshot.data!.where((r) => r.Annule == 0).isEmpty) {
      print("No Data Found, Showing Image");
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/suggestion.png',
              width: 700,
              height: 700,
              fit: BoxFit.contain,
            ),
            Text(
              'Aucune Suggestion!',
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      var suggestions = snapshot.data!;
      var filteredsuggestions = suggestions.where((r) => r.Annule == 0).toList();

      return SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredsuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = filteredsuggestions[index];
            return Dismissible(
              key: Key(suggestion.id_sugg.toString()),
              direction: DismissDirection.horizontal,
              background: Container(
                color: Colors.redAccent,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: const Color.fromARGB(255, 0, 217, 255).withOpacity(0.2),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final updatedsuggestion = await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SuggestionPage(initialsuggestion: suggestion),
                    ),
                  );
                  if (updatedsuggestion != null && mounted) {
                    _editsuggestion(updatedsuggestion, index);
                  }
                  return false;
                } else if (direction == DismissDirection.startToEnd) {
                  _deletesuggestion(index, suggestion.id_sugg.toString());
                  return false;
                }
                return false;
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: const Icon(
                    CupertinoIcons.info_circle,
                    size: 60,
                    color: Color.fromARGB(255, 223, 4, 4),
                  ),
                  title: Text(
                    '${suggestion.libelle}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.subject_rounded, size: 22, color: Color.fromARGB(255, 12, 98, 184)),
                            const SizedBox(width: 10),
                            Text(
                              francais?
                              'Description: ${suggestion.suggestion!.length > 50 ? suggestion.suggestion!.substring(0, 50) + '...' : suggestion.suggestion}':
                              ' ${suggestion.suggestion!.length > 50 ? suggestion.suggestion!.substring(0, 50) + '...' : suggestion.suggestion}الوصف: ',
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.date_range, size: 22, color: Color.fromARGB(147, 3, 215, 49)),
                            const SizedBox(width: 10),
                            Text(francais?
                              'Date: ${suggestion.date}':'التاريخ: ${suggestion.date}',
                             style: const TextStyle(fontSize: 16, color: Colors.black87)),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  },
),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newsuggestion = await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuggestionPage(),
            ),
          );
         if (newsuggestion != null) {
            _addsuggestion(newsuggestion);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 176, 5, 8),
      ),
    );
  }
}




