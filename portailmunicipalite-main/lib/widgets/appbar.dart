import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';
import '../screens/profilUtilisateur.dart';
import '../LanguageProvider.dart'; // Importer le modèle
import 'package:portail_municipalite/authentification/login.dart';
/*
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueChanged<bool> onLanguageChanged;
  final bool connecte;
  const CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    required this.onLanguageChanged,
    required this.connecte,
  }) : super(key: key);






  @override
  Size get preferredSize => Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context); 
    bool francais = languageProvider.isFrench; 

    void _toggleLanguage() {
      languageProvider.toggleLanguage(); 
      onLanguageChanged(francais);
    }

    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 3.0),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    if (!connecte) 
                      TextButton(
                        onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );},
                        child: Text(
                          francais ? "Connexion" : "تسجيل الدخول",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                      else
                       IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilUtilisateur(
                                francais: francais,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.person),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo.png', 
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        francais
                            ? "République Tunisienne\nMunicipalité de Tunis"
                            : "الجمهورية التونسية\nبلدية تونس",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        width: 60,
                        height: 60,
                        child: FittedBox(
                          child: CountryFlag.fromCountryCode(
                            'TN',
                            shape: const RoundedRectangle(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:country_flags/country_flags.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/profilUtilisateur.dart';
import '../LanguageProvider.dart'; // Importer le modèle
import 'package:portail_municipalite/authentification/login.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ValueChanged<bool> onLanguageChanged;

  const CustomAppBar({
    Key? key,
    required this.scaffoldKey,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(120.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool connecte = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final status = await SharedPreferencesHelper.getLoginStatus();
    setState(() {
      connecte = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    bool francais = languageProvider.isFrench;

    void _toggleLanguage() {
      languageProvider.toggleLanguage();
      widget.onLanguageChanged(francais);
    }

    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 3.0),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!connecte)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: Text(
                            francais ? "Connexion" : "تسجيل الدخول",
                            style: TextStyle(color: Colors.black),
                          ),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilUtilisateur(
                                  francais: francais,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.person),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: Offset(0, 4),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        width: 50,
                        height: 50,
                      ),
                      Text(
                        francais
                            ? "République Tunisienne\nMunicipalité de Tunis"
                            : "الجمهورية التونسية\nبلدية تونس",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
                        width: 60,
                        height: 60,
                        child: FittedBox(
                          child: CountryFlag.fromCountryCode(
                            'TN',
                            shape: const RoundedRectangle(6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
