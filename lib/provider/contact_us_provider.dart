import 'package:argil_tiles/model/contact_us_query_done_model.dart';
import 'package:argil_tiles/sevices/contact_service.dart';
import 'package:flutter/widgets.dart';
import '../model/contact_model.dart';

class ContactUsProvider extends ChangeNotifier {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Service and getter and setter
  ContactService contactUsService = ContactService();
  ContactUsQueryDone? _contactUsQueryDone;
  ContactUsQueryDone? get contactUsQueryDone => _contactUsQueryDone;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  Future<bool> contactUs() async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();

    /// get response after contact request
    _contactUsQueryDone = await contactUsService.submitContact(
      contact: ContactModel(
        contactno: contactController.text,
        email: emailController.text,
        message: messageController.text,
        name: nameController.text,
      ),
    );

    if (_contactUsQueryDone?.status == true) {
      /// reset controllers and form
      resetContactUsForm();
      return true;
    }

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void resetContactUsForm() {
    formKey.currentState?.reset();
    nameController.clear();
    emailController.clear();
    contactController.clear();
    messageController.clear();
  }
}
