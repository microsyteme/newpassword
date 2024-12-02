import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/appbar.dart';
import 'articleDetailPage.dart';
import '../LanguageProvider.dart';
import '../API/httpreq.Dart';
import '../API/ParseXMlFile.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../API/classes.dart';

Future<List<Article>> fetchArticles() async {
try {

return await THttpHelper.get('GetActualite', parseArticles);
} catch (e) { 
print('Erreur lors de la récupération des articles : $e');
rethrow;
}
}

class AccueilPage extends StatefulWidget {
  
const AccueilPage({super.key,});

@override
_AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
final ScrollController _scrollController = ScrollController();


void _goToArticleDetail(int id_actualite) {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => Articledetailpage(
 
  id_actualite:id_actualite,

),
),
);
}
@override
Widget build(BuildContext context) {
  bool francais = Provider.of<LanguageProvider>(context).isFrench;

  return Scaffold(
    appBar: CustomAppBar(
      scaffoldKey: scaffoldKey,
      onLanguageChanged: (isFr) {
        setState(() {
          francais = isFr;
        });
      },
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Article>>(
          future: fetchArticles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Aucun article disponible.'));
            }

            var articles = snapshot.data!;

            return CarouselSlider.builder(
              itemCount: articles.length,
              options: CarouselOptions(
                height: 300.0, // Hauteur totale du carousel
                autoPlay: true,
                enlargeCenterPage: true, // Agrandit l'élément central
                aspectRatio: 16 / 9,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 3),
                viewportFraction: 0.8, // Fraction de l'écran occupée
              ),
              itemBuilder: (context, index, realIndex) {
                var article = articles[index];
                int id_actualite = article.id_actualite;
                String title =
                    francais ? article.titre_acc_Fr : article.titre_acc_Ar;
                String content =
                    francais ? article.description_Acc_Fr : article.Description_Acc_Ar;
                String imageUrl = article.ImagePath_Acc_Fr;
                String datepub = article.date_publication;

                if (imageUrl.isEmpty) {
                  imageUrl = 'https://via.placeholder.com/250x150';
                }

                return GestureDetector(
  onTap: () {
    _goToArticleDetail(id_actualite);
  },
  child: Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.network(
              imageUrl,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  datepub,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
);

              },
            );
          },
        ),
      ),
    ),
  );
}
}