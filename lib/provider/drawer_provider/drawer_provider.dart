import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  String _selectedItem = ''; // Default selected item

  String get selectedItem => _selectedItem;

  void selectItem(String item) {
    _selectedItem = item;
    notifyListeners();
  }
}
