import 'package:xml/xml.dart' as xml;
import '../API/classes.dart'; 

//Parse Arcticle
List<Article> parseArticles(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);
  final items = document.findAllElements('Table');

  // Retourner une liste d'objets Article
  return items.map((node) => Article.fromXml(node)).toList();
}



//PArse details de l'article
List<ArticleDtl> parseArticlesDtl(String xmlString) {
  final document = xml.XmlDocument.parse(xmlString);
  final items = document.findAllElements('Table');

  // Agréger toutes les valeurs distinctes de <photo>
  final photos = items
      .map((node) => node.findElements('photo').map((e) => 'http://mserp.tn:83/Images/${e.text}').toList())
      .expand((list) => list)
      .toSet()
      .toList();

  // Crée un seul article avec la liste des photos agrégées
  if (items.isNotEmpty) {
    final firstNode = items.first; // Tous les autres attributs sont identiques
    return [
      ArticleDtl.fromXml(firstNode).copyWith(photo: photos),
    ];
  }

  return [];
}

//Parse Citoyen
List<Citoyen> parseCitoyen(String xmlString){
  final document = xml.XmlDocument.parse(xmlString);
  final items = document.findAllElements('Table');
  return items.map((node)=> Citoyen.fromXml(node)).toList();
}
 // Parse une liste d'éléments XML en une liste de Réclamations
  List<Reclamation> parseReclamation(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    return document.findAllElements('Table').map((element) {
      return Reclamation.fromXml(element);
    }).toList();
  }
  List<Demande> parseDeamnde(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    return document.findAllElements('Table').map((element) {
      return Demande.fromXml(element);
    }).toList();
  }


List<Suggestion> parseSuggestion(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    return document.findAllElements('Table').map((element) {
      return Suggestion.fromXml(element);
    }).toList();
  }

List<Consultation> parseConsultation(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    return document.findAllElements('Table').map((element) {
      return Consultation.fromXml(element);
    }).toList();
  }
  List<Themes> parseTheme(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    return document.findAllElements('Table').map((element) {
      return Themes.fromXml(element);
    }).toList();
  }


  List<Sujet> parseSujet(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    return document.findAllElements('Table').map((element) {
      return Sujet.fromXml(element);
    }).toList();
  }