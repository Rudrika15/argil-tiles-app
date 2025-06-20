import 'package:argil_tiles/model/auth_model.dart';
import 'package:argil_tiles/sevices/auth_service.dart';
import 'package:argil_tiles/utils/shared_preference/shared_prefrence.dart';
import 'package:argil_tiles/utils/widget_helper/widhet_helper.dart';
import 'package:flutter/widgets.dart';

class AuthProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// is admin logged in
  bool _isAdminLoggedIn = false;
  bool get isAdminLoggedIn => _isAdminLoggedIn;
  void setAdminLoginStatus({required bool status}) async {
    _isAdminLoggedIn = status;
    notifyListeners();
  }

  /// Service and getter and setter
  AuthService authService = AuthService();
  LoginModel? _auth;
  LoginModel? get auth => _auth;

  /// login user
  Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _auth = await authService.login(
      email: email,
      password: password,
      context: context,
    );
    if (_auth?.success == true) {
      await SharedPrefs.saveToken(token: _auth?.data?.token ?? "");
      WidgetHelper.customSnackBar(context: context, title: "Logged In");
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return _auth?.success == true;
  }
}
