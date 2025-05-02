import 'package:flutter/material.dart';
import 'package:argil_tiles/model/homescreen_model.dart';
import 'package:argil_tiles/sevices/homescreen_service.dart';

class HomeScreenProvider with ChangeNotifier {
  List<HomescreenModel>? _homeItems = [];
  bool _isLoading = false;

  List<HomescreenModel>? get homeItems => _homeItems;
  bool get isLoading => _isLoading;

  final HomeScreenService _service = HomeScreenService();

  Future<void> loadHomeScreenData() async {
    _isLoading = true;
    notifyListeners();

    _homeItems = await _service.fetchHomeScreenData();
    _isLoading = false;
    notifyListeners();
  }

  ////////////////////////////////////////////////////////////
  ///
  int selectedIndex = 0;
  set setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
