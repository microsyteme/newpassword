import 'package:xml/xml.dart';
import 'dart:convert';

  // Méthodes utilitaires pour extraire des valeurs sûres à partir de XML
 String findText(XmlElement node, String tagName, {String defaultValue = ''}) {
    final elements = node.findElements(tagName);
    return elements.isNotEmpty ? elements.single.text : defaultValue;
  }

  int findInt(XmlElement node, String tagName, {int defaultValue = 0}) {
    final elements = node.findElements(tagName);
    return elements.isNotEmpty ? int.tryParse(elements.single.text) ?? defaultValue : defaultValue;
  }

//Article
class Article {
  final int id_actualite;
  final String titre;
  final String contenu;
  final String date_publication;
  final int id_section;
  final String image;
  final String titre_Ar;
  final String contenu_Ar;
  final String date_publication_Ar;
  final String Description_Acc_Ar;
  final String ImagePath_Acc_Ar;
  final String description_Acc_Fr;
  final String titre_acc_Ar;
  final String titre_acc_Fr;
  final String ImagePath_Acc_Fr;
  final String date_publication_Fr;
 final List<String>? photo;

  Article({
    required this.id_actualite,
    required this.titre,
    required this.contenu,
    required this.ImagePath_Acc_Fr,
    required this.date_publication,
    required this.description_Acc_Fr,
    required this.titre_acc_Fr,
    required this.titre_acc_Ar,
    required this.Description_Acc_Ar,
    required this.ImagePath_Acc_Ar,
    required this.contenu_Ar,
    required this.date_publication_Ar,
    required this.date_publication_Fr,
    required this.id_section,
    required this.image,
    required this.titre_Ar,
    this.photo,
  });



  // Fonction de création d'un article à partir d'un élément XML
factory Article.fromXml(XmlElement node) {
  final baseImagePath_Acc_Fr = 'http://mserp.tn:83/Images/';
  
  // Utilisation correcte de findElements et e.text pour récupérer le texte de chaque photo
  final photos = node.findElements('photo')
      .map((e) => '$baseImagePath_Acc_Fr${e.text}')  // Récupère le texte de chaque élément <photo>
      .toList();

  return Article(
    id_actualite: findInt(node, 'id_actualite'),
    titre: findText(node, 'titre'),
    contenu: findText(node, 'contenu'),
    date_publication: findText(node, 'date_publication'),
    description_Acc_Fr: findText(node, 'description_Acc_Fr'),
    titre_acc_Fr: findText(node, 'titre_acc_Fr'),
    titre_acc_Ar: findText(node, 'titre_acc_Ar'),
    Description_Acc_Ar: findText(node, 'Description_Acc_Ar'),
    ImagePath_Acc_Fr: '$baseImagePath_Acc_Fr${findText(node, 'ImagePath_Acc_Fr')}',
    contenu_Ar: findText(node, 'contenu_Ar'),
    date_publication_Ar: findText(node, 'date_publication_Ar'),
    date_publication_Fr: findText(node, 'date_publication_Fr'),
    id_section: findInt(node, 'id_section'),
    image: '$baseImagePath_Acc_Fr${findText(node, 'image')}',
    titre_Ar: findText(node, 'titre_Ar'),
    ImagePath_Acc_Ar: findText(node, 'ImagePath_Acc_Ar'),
    photo: photos.isEmpty ? null : photos,
  );
}

}




// Détails articles 
class ArticleDtl {
  final int id_actualite;
  final String titre;
  final String contenu;
  final String date_publication;
  final int id_section;
  final String image;
  final String titre_Ar;
  final String contenu_Ar;
  final String date_publication_Ar;
  final String Description_Acc_Ar;
  final String ImagePath_Acc_Ar;
  final String description_Acc_Fr;
  final String titre_acc_Ar;
  final String titre_acc_Fr;
  final String ImagePath_Acc_Fr;
  final String date_publication_Fr;
  final List<String>? photo;

  ArticleDtl({
    required this.id_actualite,
    required this.titre,
    required this.contenu,
    required this.ImagePath_Acc_Fr,
    required this.date_publication,
    required this.description_Acc_Fr,
    required this.titre_acc_Fr,
    required this.titre_acc_Ar,
    required this.Description_Acc_Ar,
    required this.ImagePath_Acc_Ar,
    required this.contenu_Ar,
    required this.date_publication_Ar,
    required this.date_publication_Fr,
    required this.id_section,
    required this.image,
    required this.titre_Ar,
    this.photo,
  });

  // Méthodes utilitaires pour extraire des valeurs sûres à partir de XML
  static String findText(XmlElement node, String tagName, {String defaultValue = ''}) {
    final elements = node.findElements(tagName);
    return elements.isNotEmpty ? elements.single.text : defaultValue;
  }

  static int findInt(XmlElement node, String tagName, {int defaultValue = 0}) {
    final elements = node.findElements(tagName);
    return elements.isNotEmpty ? int.tryParse(elements.single.text) ?? defaultValue : defaultValue;
  }

  // Factory pour créer un article à partir d'un élément XML
  factory ArticleDtl.fromXml(XmlElement node) {
    final baseImagePath_Acc_Fr = 'http://mserp.tn:83/Images/';
    final photos = node.findElements('photo').map((e) => '$baseImagePath_Acc_Fr${e.text}').toList();
    return ArticleDtl(
      id_actualite: findInt(node, 'id_actualite'),
      titre: findText(node, 'titre'),
      contenu: findText(node, 'contenu'),
      date_publication: findText(node, 'date_publication'),
      description_Acc_Fr: findText(node, 'description_Acc_Fr'),
      titre_acc_Fr: findText(node, 'titre_acc_Fr'),
      titre_acc_Ar: findText(node, 'titre_acc_Ar'),
      Description_Acc_Ar: findText(node, 'Description_Acc_Ar'),
      ImagePath_Acc_Fr: '$baseImagePath_Acc_Fr${findText(node, 'ImagePath_Acc_Fr')}',
      contenu_Ar: findText(node, 'contenu_Ar'),
      date_publication_Ar: findText(node, 'date_publication_Ar'),
      date_publication_Fr: findText(node, 'date_publication_Fr'),
      id_section: findInt(node, 'id_section'),
      image: '$baseImagePath_Acc_Fr${findText(node, 'image')}',
      titre_Ar: findText(node, 'titre_Ar'),
      ImagePath_Acc_Ar: findText(node, 'ImagePath_Acc_Ar'),
      photo: photos.isEmpty ? null : photos,
    );
  }
}

// Ajout de l'extension pour copyWith
extension ArticleDtlCopyWith on ArticleDtl {
  ArticleDtl copyWith({
    int? id_actualite,
    String? titre,
    String? contenu,
    String? date_publication,
    int? id_section,
    String? image,
    String? titre_Ar,
    String? contenu_Ar,
    String? date_publication_Ar,
    String? Description_Acc_Ar,
    String? ImagePath_Acc_Ar,
    String? description_Acc_Fr,
    String? titre_acc_Ar,
    String? titre_acc_Fr,
    String? ImagePath_Acc_Fr,
    String? date_publication_Fr,
    List<String>? photo,
  }) {
    return ArticleDtl(
      id_actualite: id_actualite ?? this.id_actualite,
      titre: titre ?? this.titre,
      contenu: contenu ?? this.contenu,
      date_publication: date_publication ?? this.date_publication,
      id_section: id_section ?? this.id_section,
      image: image ?? this.image,
      titre_Ar: titre_Ar ?? this.titre_Ar,
      contenu_Ar: contenu_Ar ?? this.contenu_Ar,
      date_publication_Ar: date_publication_Ar ?? this.date_publication_Ar,
      Description_Acc_Ar: Description_Acc_Ar ?? this.Description_Acc_Ar,
      ImagePath_Acc_Ar: ImagePath_Acc_Ar ?? this.ImagePath_Acc_Ar,
      description_Acc_Fr: description_Acc_Fr ?? this.description_Acc_Fr,
      titre_acc_Ar: titre_acc_Ar ?? this.titre_acc_Ar,
      titre_acc_Fr: titre_acc_Fr ?? this.titre_acc_Fr,
      ImagePath_Acc_Fr: ImagePath_Acc_Fr ?? this.ImagePath_Acc_Fr,
      date_publication_Fr: date_publication_Fr ?? this.date_publication_Fr,
      photo: photo ?? this.photo,
    );
  }
}


//citoyen
class Citoyen{
  final int id_citoyen;
  final String Code;

  final String Nom;
  final String Prenom;
  
  final String Tel;
  final String Email;
  final String Pass;
  final String photo;
  final String Verif;
  final int Actif;
  Citoyen({
    required this.id_citoyen,
    required this.Code,
    required this.Nom,
    required this.Prenom,
    required this.Tel,
    required this.Email,
    required this.Pass,
    required this.photo,
    required this.Verif,
    required this.Actif
  });

  factory Citoyen.fromXml(XmlElement node){
    final basephotoPath='http://mserp.tn:83/Images/';
    

    return Citoyen(
      id_citoyen: findInt(node, 'id_citoyen'),
      Code: findText(node, 'Code'),
      Nom: findText(node, 'Nom'),
      Prenom: findText(node, 'Prenom'), 
      Tel: findText(node, 'Tel'),
      Email: findText(node, 'Email'),
      Pass: findText(node, 'Pass'),
      photo: findText(node, 'photo'), 
      Verif: findText(node, 'Verif'), 
      Actif: findInt(node, 'Actif'),
      );
  }

   // Convertir un objet Citoyen en Map
  Map<String, dynamic> toMap() {
    return {
      'id_citoyen': id_citoyen,
      'Code': Code,
      'Nom': Nom,
      'Prenom': Prenom,
      'Tel': Tel,
      'Email': Email,
      'Pass': Pass,
      'photo': photo,
      'Verif': Verif,
      'Actif': Actif,
    };
  }

  // Convertir une Map en objet Citoyen
  factory Citoyen.fromMap(Map<String, dynamic> map) {
    return Citoyen(
      id_citoyen: map['id_citoyen'],
      Code: map['Code'],
      Nom: map['Nom'],
      Prenom: map['Prenom'],
      Tel: map['Tel'],
      Email: map['Email'],
      Pass: map['Pass'],
      photo: map['photo'],
      Verif: map['Verif'],
      Actif: map['Actif'],
    );
  }

  // Convertir une liste d'objets Citoyen en JSON
  static String toJsonList(List<Citoyen> citoyens) {
    final list = citoyens.map((citoyen) => citoyen.toMap()).toList();
    return jsonEncode(list);
  }

  // Convertir un JSON en liste d'objets Citoyen
  static List<Citoyen> fromJsonList(String jsonList) {
    final List<dynamic> list = jsonDecode(jsonList);
    return list.map((item) => Citoyen.fromMap(item)).toList();
  }

}


class Reclamation {
  final int ? id_rec;
  final String code_citoyen;
  final String date;
  final int? type;
  final String? Objet;
  final String des;
  final String? chemin;
  final String priorite;
  final int? Etat;
  final String Localisation;
  final int ? Annule;
  Reclamation({
 this.id_rec,
    required this.code_citoyen,
   
    this.Etat,
    this.type,
    this.Objet,
    required this.des,
    this.chemin,
    required this.priorite,
    required this.date,
    this.Annule,
    required this.Localisation
  });

  // Méthode pour analyser un Objet XML en une instance de Reclamation
  factory Reclamation.fromXml(XmlElement element) {
    return Reclamation(
      id_rec: int.tryParse(element.getElement('id_rec')?.text ?? ''),
      code_citoyen: element.getElement('code_citoyen')?.text ?? '',
      Etat: int.tryParse(element.getElement('Etat')?.text ?? ''),
      type: int.tryParse(element.getElement('type')?.text ?? ''),
      Objet: element.getElement('Objet')?.text?? '',
      des: element.getElement('des')?.text ?? '',
      chemin: element.getElement('chemin')?.text,
      priorite: element.getElement('priorite')?.text ?? '',
      date: element.getElement('date')?.text ?? '',
      Localisation: element.getElement('Localisation')?.text ?? '',
      Annule: int.tryParse(element.getElement('Annule')?.text ?? '' ),

    );
  }

  // Méthode pour générer un Objet XML à partir d'une instance de Reclamation
  String toXml() {
    final builder = XmlBuilder();
    builder.element('Table', nest: () {
      builder.element('id_rec', nest: id_rec?.toString() ?? '');
      builder.element('code_citoyen', nest: code_citoyen);
      builder.element('Etat', nest: Etat?.toString() ?? '');
      builder.element('type', nest: type?.toString() ?? '');
      builder.element('des', nest: des);
      builder.element('chemin', nest: chemin ?? '');
      builder.element('priorite', nest: priorite);
      builder.element('date', nest: date);
      builder.element('Objet', nest: Objet);
      builder.element('Annule', nest: Annule?.toString() ?? '');
      
    });
    return builder.buildDocument().toXmlString();
  }

 
}
class Demande {
  final int ? id_acces;
  final String code_citoyen;
  final String Date;
  final String? Objet;
  final String Message;
  final String? TypeInformation;
    final int ? Annule;

  
  Demande({
    this.id_acces,
    required this.code_citoyen,
    required this.Date,
    this.Objet,
    required this.Message,
    this.TypeInformation,
    this.Annule
  });

  // Méthode pour analyser un Objet XML en une instance de Reclamation
  factory Demande.fromXml(XmlElement element) {
    return Demande(
      id_acces: int.tryParse(element.getElement('id_acces')?.text ?? ''),
      code_citoyen: element.getElement('code_citoyen')?.text ?? '',
      Objet: element.getElement('Objet')?.text?? '',
      Message: element.getElement('Message')?.text ?? '',
      TypeInformation: element.getElement('TypeInformation')?.text,
      Date: element.getElement('Date')?.text ?? '',
      Annule: int.tryParse(element.getElement('Annule')?.text ?? '' ),

    );
  }

  // Méthode pour générer un Objet XML à partir d'une instance de Reclamation
  String toXml() {
    final builder = XmlBuilder();
    builder.element('Table', nest: () {
      builder.element('id_acces', nest: id_acces?.toString() ?? '');
      builder.element('code_citoyen', nest: code_citoyen);
      builder.element('Message', nest: Message);
      builder.element('TypeInformation', nest: TypeInformation ?? '');
      builder.element('Date', nest: Date);
      builder.element('Objet', nest: Objet);
      builder.element('Annule', nest: Annule?.toString() ?? '');
    });
    return builder.buildDocument().toXmlString();
  }

 
}

class Sujet{
  final int code;
  final String libelle;
  final String libelle_Ar;
  final String Description;
  final String Description_Ar;
  Sujet({
    required this.code,
    required this.libelle,
    required this.libelle_Ar,
    required this.Description,
    required this.Description_Ar,
  });
  factory Sujet.fromXml(XmlElement node){
    return Sujet(
      code: findInt(node, 'code'),
      libelle: findText(node, 'libelle'),
      libelle_Ar: findText(node, 'libelle_Ar'),
      Description: findText(node,'Description'),
      Description_Ar: findText(node,'Description_Ar'),
       );
  }
  String toXml(){
    final builder = XmlBuilder();
    builder.element('table',nest: (){
    builder.element('code', nest : code?.toString() ?? '');
    builder.element('libelle', nest : libelle);
    builder.element('libelle_Ar', nest: libelle_Ar);
    builder.element('Description',nest: Description);
    builder.element('Description_Ar',nest: Description_Ar);
    });
    return builder.buildDocument().toXmlString();
  }
}




class Suggestion{
final int id_sugg;
final String code_citoyen;
final int? id_Theme;
final String date;
final String ?suggestion;
final int? Annule;
final int ?id_theme1;
final String? localisation;
final String? libelle;
final String? libelle_Ar;

 Suggestion({
  required this.id_sugg,
  required this.code_citoyen,
  this.id_Theme,
  required this.date,
  this.id_theme1,
  this.localisation,
  this.suggestion,
  this.libelle,
  this.Annule,
  this.libelle_Ar,
 });

  factory Suggestion.fromXml(XmlElement node){
    return Suggestion(
      id_sugg: findInt(node, 'id_sugg'),
       code_citoyen: findText(node, 'code_citoyen'),
        id_Theme: findInt(node, 'id_Theme'), 
        date: findText(node, 'date'), 
        id_theme1: findInt(node, 'id_theme1'), 
        localisation: findText(node, 'localisation'), 
        suggestion: findText(node, 'suggestion'),
         libelle: findText(node, 'libelle'), 
         Annule: findInt(node, 'Annule'),
         libelle_Ar: findText(node, 'libelle_Ar'),);
  }
  String toXml(){
    final builder = XmlBuilder();
    builder.element('Table', nest: (){
    builder.element('id_sugg', nest: id_sugg.toString() ?? '');
    builder.element('code_citoyen', nest: code_citoyen);
    builder.element('id_Theme',nest: id_Theme.toString()?? '');
    builder.element('date', nest: date);
    builder.element('id_theme1', nest:  id_theme1?.toString() ?? '');
    builder.element('localisation', nest: localisation);
    builder.element('suggestion', nest: suggestion);
    builder.element('libelle', nest: libelle);
    builder.element('Annule',nest: Annule?.toString() ?? '');
    builder.element('libelle_Ar', nest: libelle_Ar);

    } );
    return builder.buildDocument().toXmlString();
  }

}


class Consultation{
final int ? id_consultation;
final String ?code_citoyen;
final String? date;
final int ?sujet;
final String ?commentaire;
final String? Reponse;
final int? Annule;
final String? Libelle;
final String? libelle_Ar;
Consultation({
  required this.id_consultation,
  required this.code_citoyen,
  required this.date,
  required this.sujet,
  required this.commentaire,
  required this.Reponse,
  required this.Annule,
  required this.Libelle,
  required this.libelle_Ar,
});
factory Consultation.fromXml(XmlElement element){
  return Consultation(
    id_consultation: int.tryParse(element.getElement('id_consultation')?.text ??''),
    code_citoyen: element.getElement('code_citoyen')?.text ?? '' ,
    sujet: int.tryParse(element.getElement('sujet')?.text ?? ''),
    date: element.getElement('date')?.text ?? '',
    commentaire: element.getElement('commentaire')?.text ?? '',
    Reponse: element.getElement('Response')?.text ?? '',
    Annule: int.tryParse(element.getElement('Annule')?.text ?? ''),
    Libelle: element.getElement('Libelle')?.text ?? '',
    libelle_Ar: element.getElement('libelle_Ar')?.text ?? '',
        );
}
String toXml(){
  final builder = XmlBuilder();
  builder.element('Table', nest:(){
  builder.element('id_consultation',nest:id_consultation?.toString() ?? '');
  builder.element('code_citoyen', nest: code_citoyen);
  builder.element('sujet',nest:sujet?.toString() ?? '');
  builder.element('date', nest: date);
  builder.element('commentaire', nest: commentaire);
  builder.element('Reponse', nest: Reponse);
    builder.element('Annule',nest:Annule?.toString() ?? '');
  builder.element('Libelle', nest: Libelle);
  builder.element('libelle_Ar', nest: libelle_Ar);
  });
  return builder.buildDocument().toXmlString();
}
}


class Themes{
  final int id_theme;
  final String libelle;
  final String libelle_Ar;
  Themes({
    required this.id_theme,
    required this.libelle,
    required this.libelle_Ar,
  });
  factory Themes.fromXml(XmlElement node){
    return Themes(
      id_theme: findInt(node, 'id_theme'),
      libelle: findText(node, 'libelle'),
      libelle_Ar: findText(node, 'libelle_Ar'),
       );
  }
  String toXml(){
    final builder = XmlBuilder();
    builder.element('table',nest: (){
    builder.element('id_theme', nest : id_theme?.toString() ?? '');
    builder.element('libelle', nest : libelle);
    builder.element('libelle_Ar', nest: libelle_Ar);
    });
    return builder.buildDocument().toXmlString();
  }
}