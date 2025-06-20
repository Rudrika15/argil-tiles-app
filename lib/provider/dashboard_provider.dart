import 'package:argil_tiles/model/dashboard_model.dart';
import 'package:flutter/material.dart';

import '../sevices/dashboard_service.dart';

class DashboardProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  DashboardService dashboardService = DashboardService();
  DashboardModel? _dashboardModel;
  DashboardModel? get dashboardModel => _dashboardModel;

  Future<void> getDashboard({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _dashboardModel = await dashboardService.getDashBoard(context: context);

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }
}
