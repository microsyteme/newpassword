import 'package:xml/xml.dart' as xml;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'classes.dart';

 

class THttpHelper {
  static const String _baseUrl = 'http://mserp.tn:83/muni.asmx';  

  static Future<List<T>> get<T>(String endpoint, Function(String) parse, {Map<String, String>? queryParameters}) async {
  // Construire l'URI avec les paramètres de requête
  final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParameters);

  final response = await http.get(
    uri,
    headers: _createHeaders(),
  );

  return _handleResponse(response, parse);
 }

//méthode POST
static Future<List<T>> post<T>(String endpoint,Map<String, String> body,  Function(String) parse, {Map<String, String>? queryParameters}) async {
  // Construire l'URI avec les paramètres de requête
  final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParameters);

  // Effectuer la requête POST
  final response = await http.post(
    uri,
    headers: _createHeaders(),
    body: body,
  );
print('body=$body');
  // Traiter la réponse avec une méthode générique
  return _handleResponse(response, parse);
  }





static Future<bool> postBooleen(String endpoint,Map<String, String> body,  Function(String) parse, {Map<String, String>? queryParameters}) async {
  // Construire l'URI avec les paramètres de requête
  final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParameters);

  // Effectuer la requête POST
  final response = await http.post(
    uri,
    headers: _createHeaders(),
    body: body,
  );
  print('body=$body');
  // Traiter la réponse
  if (response.statusCode == 200) {
    try {
      // Analyser la réponse XML
      final responseBody = xml.XmlDocument.parse(response.body);
      final successNode = responseBody.findAllElements('boolean').first;
      return successNode.text.trim().toLowerCase()  == 'true'; // Vérifie si la réponse indique un succès
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse de la réponse : $e');
    }
  } else {
    throw Exception('Échec de l\'envoi de la réclamation : ${response.statusCode}');
  }
}





//méthode POST
static Future<String> postint(String endpoint,Map<String, String> body,  Function(String) parse, {Map<String, String>? queryParameters}) async {
  // Construire l'URI avec les paramètres de requête
  final uri = Uri.parse('$_baseUrl/$endpoint').replace(queryParameters: queryParameters);

  // Effectuer la requête POST
  final response = await http.post(
    uri,
    headers: _createHeaders(),
    body: body,
  );

if (response.statusCode == 200) {
    try {
      // Analyser la réponse XML
      final responseBody = xml.XmlDocument.parse(response.body);
      final successNode = responseBody.findAllElements('string').first;
      print("resultat=${successNode.text.trim()}");
      return successNode.text.trim();
    } catch (e) {
      throw Exception('Erreur lors de l\'analyse de la réponse : $e');
    }
  } else {
    throw Exception('Échec de l\'envoi de la réclamation : ${response.statusCode}');
  }
}










  // Méthode générique pour traiter la réponse HTTP
static List<T> _handleResponse<T>(http.Response response,  Function(String) parse) {
  if (response.statusCode == 200) {
    if (response.body.startsWith('<?xml')) {
      return parse(response.body);  // Appel du parseur qui retourne une liste de T
    } else {
      throw Exception('Format de réponse inconnu');
    }
  } else {
    throw Exception('Échec du chargement des données: ${response.statusCode}');
  }
}


  // Fonction d'en-têtes pour la requête HTTP
  static Map<String, String> _createHeaders() {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/xml',

    };
  }
}











