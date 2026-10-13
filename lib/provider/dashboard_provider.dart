import 'package:argil_tiles/model/dashboard_model.dart';
import 'package:flutter/material.dart';

import '../sevices/dashboard_service.dart';
import '../sevices/export_service.dart';

class DashboardProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// if exporting inquiries or contacts
  bool _isExportingInquiry = false;
  bool get isExportingInquiry => _isExportingInquiry;

  bool _isExportingContact = false;
  bool get isExportingContact => _isExportingContact;

  /// Service and getter and setter
  DashboardService dashboardService = DashboardService();
  ExportService exportService = ExportService();
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

  Future<void> exportInquiries({required BuildContext context}) async {
    _isExportingInquiry = true;
    notifyListeners();
    await exportService.exportInquiries(context: context);
    _isExportingInquiry = false;
    notifyListeners();
  }

  Future<void> exportContacts({required BuildContext context}) async {
    _isExportingContact = true;
    notifyListeners();
    await exportService.exportContacts(context: context);
    _isExportingContact = false;
    notifyListeners();
  }
}
