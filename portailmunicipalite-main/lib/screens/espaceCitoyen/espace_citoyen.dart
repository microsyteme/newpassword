import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:portail_municipalite/screens/espaceCitoyen/Demande/List_damande.dart';
import 'package:portail_municipalite/screens/espaceCitoyen/reclamation/Reclamation_list_page.dart';
import 'package:portail_municipalite/screens/profilUtilisateur.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:country_flags/country_flags.dart';
import 'package:portail_municipalite/screens/espaceCitoyen/consultation/listt_sujets.dart';
import 'package:portail_municipalite/screens/espaceCitoyen/suggestion/list_suggestion.dart';
class EspaceCitoyen extends StatefulWidget {
  
const EspaceCitoyen({super.key, });

@override
_EspaceCitoyenState createState() => _EspaceCitoyenState();
}
class MenuCard extends StatelessWidget {
  final String imagePath; // Chemin de l'image
  final String title;
  final String subtitle;

  final VoidCallback onTap;

  MenuCard({
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 80, // Largeur de l'image
                      height: 80, // Hauteur de l'image
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EspaceCitoyenState extends State<EspaceCitoyen> {
 
 
  @override
  Widget build(BuildContext context) {
    // bool francais = Provider.of<LanguageProvider>(context).isFrench;
    final languageProvider = Provider.of<LanguageProvider>(context);
     bool francais = languageProvider.isFrench; 
     void _toggleLanguage() {
  languageProvider.toggleLanguage();
  
  
}

    return Scaffold(
 appBar: PreferredSize(
  preferredSize: Size.fromHeight(90.0),
  child: AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 218, 24, 10), // Couleur de fond rouge
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20), // Coins arrondis en bas
        ),
      ),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
             ElevatedButton(
                    onPressed: _toggleLanguage,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(40, 40),
                    ),
                    child: Container(
                      width: 40,
                      height: 40,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: CountryFlag.fromCountryCode(
                          francais ? 'TN' : 'FR',
                          shape: const Circle(),
                        ),
                      ),
                    ),
                  ),
             Center(
              child: Text(
                 francais ? 'Espace Citoyen' : 'فضاءالمواطن',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Positioned(
              right: 10.0,
              child: IconButton(
                icon: Image.asset(
                  'assets/user.png',
                  width: 40,
                  height: 40,
                ),
                onPressed: () {
                  // Navigation vers l'écran de profil
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilUtilisateur(francais: francais,)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  
),

  body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2, // Deux boutons par ligne
            crossAxisSpacing: 20, // Espacement horizontal
            mainAxisSpacing: 50, // Espacement vertical
            children: [
              MenuCard(
                imagePath: 'assets/conversation.png',
                title: francais ? 'Consultation' : 'استشارة',
                subtitle: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DesignerListScreen()),
                  );
                },
              ),
              MenuCard(
                imagePath: 'assets/file.png',
                title: francais? 'Réclamation':'شكوى',
                subtitle: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageList()),
                  );
                },
              ),
              MenuCard(
                imagePath: 'assets/surveyor.png',
                title: francais?'suggestion' :'اقتراح',
                subtitle: '',
                onTap: () {
                 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  SuggestionHomePageList()),
                  );
                },
              ),
              MenuCard(
                imagePath: 'assets/log-in.png',
                title: francais? 'Information':'نفاذ للمعلومة',
                subtitle: '',
                onTap: () {
                 Navigator.push(
                      context,
                    MaterialPageRoute(builder: (context) => ListDamande()),
                  );

                },
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}
