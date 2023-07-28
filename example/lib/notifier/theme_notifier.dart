import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  Brightness get theme => isDarkMode ? Brightness.dark : Brightness.light;

  toggleTheme(bool v) {
    isDarkMode = v;
    notifyListeners();
  }
}
