import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  bool _isFrench = true;

  bool get isFrench => _isFrench;

  // Permuter la langue
  void toggleLanguage() {
    _isFrench = !_isFrench;
    notifyListeners();
  }

  // Changer la langue
  void setLanguage(bool isFrench) {
    _isFrench = isFrench;
    notifyListeners();
  }
}
