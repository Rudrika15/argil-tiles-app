import 'package:flutter/material.dart';

class NewDrawerProvider with ChangeNotifier {
  int _selectedIndex = 0; // Default selected index

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
