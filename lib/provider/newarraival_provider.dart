import 'package:argil_tiles/model/newarrival_model.dart';
import 'package:argil_tiles/sevices/newarraival_service.dart';
import 'package:flutter/material.dart';

class NewarrivalProvider with ChangeNotifier {
  final NewArrivalService _service = NewArrivalService();

  NewarrivalModel? _newArrivals;
  NewarrivalModel? get newArrivals => _newArrivals;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchNewArrivals() async {
    _isLoading = true;
    notifyListeners();

    _newArrivals  = await _service.getNewArrivals();

    _isLoading = false;
    notifyListeners();
  }
}
