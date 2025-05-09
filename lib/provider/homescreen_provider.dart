import 'package:argil_tiles/model/homescreen_model.dart';
import 'package:flutter/material.dart';
import 'package:argil_tiles/sevices/homescreen_service.dart';

class HomeScreenProvider with ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final HomeScreenService _service = HomeScreenService();
  HomeSliderModel? _homeSliderModel;
  HomeSliderModel? get homeSliderModel => _homeSliderModel;
  Future<void> loadHomeScreenData({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    _homeSliderModel = await _service.fetchHomeScreenData(context: context);
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
