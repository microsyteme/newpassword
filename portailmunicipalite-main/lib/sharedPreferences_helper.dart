import 'package:shared_preferences/shared_preferences.dart';
import '../API/classes.dart'; 

class SharedPreferencesHelper {
  // Sauvegarder le statut de connexion
  static Future<void> saveLoginStatus(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Récupérer le statut de connexion
  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Sauvegarder le token utilisateur
  static Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', token);
  }

  // Récupérer le token utilisateur
  static Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  // Supprimer toutes les données
  static Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

    // Sauvegarder une liste de citoyens
  static Future<void> saveCitoyens(List<Citoyen> citoyens) async {
    final prefs = await SharedPreferences.getInstance();
    final citoyensJson = Citoyen.toJsonList(citoyens);
    await prefs.setString('citoyensData', citoyensJson);
  }

  // Récupérer une liste de citoyens
  static Future<List<Citoyen>> getCitoyens() async {
    final prefs = await SharedPreferences.getInstance();
    final citoyensJson = prefs.getString('citoyensData');
    if (citoyensJson == null) return [];
    return Citoyen.fromJsonList(citoyensJson);
  }

  // Effacer les données des citoyens
  static Future<void> clearCitoyensData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('citoyensData');
  }

}
