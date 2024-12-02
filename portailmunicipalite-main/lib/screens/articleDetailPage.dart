import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../widgets/appbar.dart';
import '../LanguageProvider.dart'; 
import '../API/classes.dart';
import '../API/httpreq.Dart';
import '../API/ParseXMlFile.dart';
import 'package:carousel_slider/carousel_slider.dart';
Future<List<ArticleDtl>> fetchArticles(String id) async {
  try {
    return await THttpHelper.get<ArticleDtl>(
      'GetDtlActualite',
      parseArticlesDtl,  // Assurez-vous que parseArticlesDtl retourne List<ArticleDtl>
      queryParameters: {'id': id},  // Paramètres de requête
    );
  } catch (e) {
    print('Erreur lors de la récupération de l\'article avec ID $id : $e');
    rethrow;
  }
}

class Articledetailpage extends StatefulWidget {
  final int id_actualite;
  

  const Articledetailpage({
    super.key,
    required this.id_actualite,
  
    
  });

  @override
  _ArticledetailpageState createState() => _ArticledetailpageState();
}

class _ArticledetailpageState extends State<Articledetailpage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<ArticleDtl>> _articleFuture;  // Modifier le type pour une liste

  bool get isFrench => Provider.of<LanguageProvider>(context).isFrench;

  @override
  void initState() {
    super.initState();
    _articleFuture = fetchArticleDetail(widget.id_actualite.toString());
  }

  // La fonction doit retourner une liste d'articles
  Future<List<ArticleDtl>> fetchArticleDetail(String id) async {
    try {
      final articles = await THttpHelper.get<ArticleDtl>(
        'GetDtlActualite',
        parseArticlesDtl,
        queryParameters: {'id': id},
      );
      if (articles.isNotEmpty) {
        return articles;  // Retourner la liste d'articles
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
    return Scaffold(
      appBar: CustomAppBar(
        
        scaffoldKey: scaffoldKey,
        onLanguageChanged: (isFr) {},
      ),
      body: FutureBuilder<List<ArticleDtl>>(  // Changer le type pour une liste
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erreur: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final article = snapshot.data!.first;  // Prendre le premier article de la liste
            return _buildArticleContent(article);
          } else {
            return const Center(child: Text("Aucun article trouvé."));
          }
        },
      ),
    );
  }


  Widget _buildArticleContent(ArticleDtl article) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCarousel(article.photo),
            const SizedBox(height: 16),
            Text(
              isFrench ? article.titre_acc_Fr : article.titre_acc_Ar,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isFrench ? article.contenu : article.contenu_Ar,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

 

Widget _buildCarousel(List<String>? photos) {
  if (photos == null || photos.isEmpty) {
    return const Text("Aucune image disponible.");
  }
  print('photos=$photos');

  return CarouselSlider(
    options: CarouselOptions(
      height: 200.0, // Hauteur du carousel
      autoPlay: true, // Activation du défilement automatique
      enlargeCenterPage: true, // Met l’image en avant
      enableInfiniteScroll: true, // Défilement infini
      aspectRatio: 16 / 9, // Ratio d’aspect
      viewportFraction: 0.8, // Fraction de la largeur de la vue
    ),
    items: photos.map((photoUrl) {
      return Builder(
        builder: (BuildContext context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                photoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          );
        },
      );
    }).toList(),
  );
}

}



/*
class Articledetailpage extends StatefulWidget {
  final int id_actualite;
  

  const Articledetailpage({
    super.key,
    required this.id_actualite,
    
  });

  @override
  _ArticledetailpageState createState() => _ArticledetailpageState();
}

class _ArticledetailpageState extends State<Articledetailpage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  
  bool get isFrench => Provider.of<LanguageProvider>(context).isFrench;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        scaffoldKey: scaffoldKey,
        onLanguageChanged: (isFr) {
          
        },
      ),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),

              
              Text(
                isFrench ? widget.title : widget.title, 
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              
              Text(
                isFrench ? widget.content : widget.content, 
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/