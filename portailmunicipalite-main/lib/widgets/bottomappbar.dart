import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_municipalite/authentification/login.dart';
import '../screens/AccueilPage.dart';  
import 'package:portail_municipalite/screens/espaceCitoyen/espace_citoyen.dart';
import 'package:portail_municipalite/LanguageProvider.dart';
import 'package:provider/provider.dart';
import 'package:portail_municipalite/sharedPreferences_helper.dart';

class BottomAppBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool francais = Provider.of<LanguageProvider>(context).isFrench;

    final controller = Get.put(navigationbarcontroller());
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: const Color.fromARGB(255, 236, 4, 4),
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 13,
                color: Color(0xFFFFFFFF),
              ),
            ),
            iconTheme: MaterialStateProperty.all(
              const IconThemeData(
                size: 30,
                color: Color(0xFFFFFFFF),
              ),
            ),
            indicatorColor: Colors.transparent,
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.handleNavigation(index, context),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: francais ? 'Accueil' : 'الرئيسية'),
              NavigationDestination(icon: Icon(Icons.person), label: francais ? "Espace citoyen" : 'فضاء المواطن'),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}
class navigationbarcontroller extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late final List<Widget> screens;

  navigationbarcontroller() {
    screens = [
      AccueilPage(),
      EspaceCitoyen(),
    ];
  }

  Future<void> handleNavigation(int index, BuildContext context) async {
    if (index == 1) { // Vérifie si l'utilisateur sélectionne "Espace Citoyen"
      bool isConnected = await SharedPreferencesHelper.getLoginStatus();
      if (isConnected) {
        selectedIndex.value = index;
      } else {
        // Redirige vers la page de connexion si l'utilisateur n'est pas connecté
        Get.to(LoginScreen());
      }
    } else {
      selectedIndex.value = index;
    }
  }
}












/*
class BottomAppBarDemo extends StatelessWidget {

  BottomAppBarDemo();

  @override
  Widget build(BuildContext context) {
      bool francais = Provider.of<LanguageProvider>(context).isFrench;
  
    final controller = Get.put(navigationbarcontroller( ));
    return Scaffold(
      
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: const Color.fromARGB(255, 236, 4, 4),
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 13,
                color: Color(0xFFFFFFFF),
              ),
            ),
            iconTheme: MaterialStateProperty.all(
              const IconThemeData(
                size: 30, // Adjust icon size
                color: Color(0xFFFFFFFF), // Adjust icon color
              ),
            ),
             indicatorColor: Colors.transparent,
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            destinations:  [
              NavigationDestination(icon: Icon(Icons.home), label: francais ? 'Accueil': 'الرئيسية',),
            NavigationDestination(icon: Icon(Icons.person), label: francais ?  "Espace citoyen": 'فضاء المواطن'),
           
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class navigationbarcontroller extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  late final List<Widget> screens;

  navigationbarcontroller() {
    screens = [
      AccueilPage(),
      EspaceCitoyen(),
    ];
  }
}

*/