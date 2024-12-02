import 'package:flutter/material.dart';
import 'widgets/bottomappbar.dart'; 
import 'package:provider/provider.dart';
import 'LanguageProvider.dart';
import 'sharedPreferences_helper.dart';
import 'package:get/get.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: FutureBuilder<bool>(
        future: SharedPreferencesHelper.getLoginStatus(),
        builder: (context, snapshot) {
          // Vérifiez l'état du Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affichez un indicateur de chargement pendant l'attente
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Gérer les erreurs éventuelles
            return const Center(child: Text('Erreur de connexion'));
          } else {
            // Une fois les données récupérées
            final bool isConnected = snapshot.data ?? false;
            return BottomAppBarDemo();
          }
        },
      ),
    );
  }
}
