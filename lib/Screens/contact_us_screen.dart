import 'package:argil_tiles/Screens/achievements_screen.dart';
import 'package:argil_tiles/model/contact_model.dart';
import 'package:argil_tiles/provider/homescreen_provider.dart';
import 'package:argil_tiles/sevices/contact_service.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactNoController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;

  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);

      final contact = ContactModel(
        name: _nameController.text,
        email: _emailController.text,
        contactno: _contactNoController.text,
        message: _messageController.text,
      );

      final success = await ContactService().submitContact(contact);

      setState(() => _isLoading = false);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Message sent successfully!'
                : 'Failed to send message. Try again.',
          ),
        ),
      );

      if (success) {
        _formKey.currentState?.reset();
        _nameController.clear();
        _emailController.clear();
        _contactNoController.clear();
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          title: const Text('Contact Us', style: TextStyle(fontSize: 18)),
          leading: const BackButton(),
          centerTitle: true,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        endDrawer: DrawerWidget(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              // image: DecorationImage(
              //   image: AssetImage('assets/images/product1.png'), // path to your background image
              //   fit: BoxFit.cover,
              //   opacity: 0.5, // You can adjust the opacity if needed
              // ),
            ),
            child: Column(
              children: [
                const Text(
                  "for more information you can\nreach out to us",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInputField(
                        controller: _nameController,
                        hint: "Name",
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter your name'
                                    : null,
                      ),
                      _buildInputField(
                        controller: _emailController,
                        hint: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your email';
                          } else if (!_emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        controller: _contactNoController,
                        hint: "Contact No",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your contact number';
                          } else if (value.length < 10) {
                            return 'Enter a valid 10-digit number';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        controller: _messageController,
                        hint: "Message",
                        maxLines: 4,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter a message'
                                    : null,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF663333),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _isLoading ? null : _submitForm,
                          child:
                              _isLoading
                                  ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                  : const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                _buildContactDetailsCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildContactDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7E3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title for the contact details card
          const Text(
            "Contact Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF663333),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.phone, size: 18),
              const SizedBox(width: 8),
              const Text('+91 2822 240628/29', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.email, size: 18),
              const SizedBox(width: 8),
              const Text('info@argiltiles.com', style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),

          // Location row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: const Text(
                  'Mod Ceramic Industries Ltd.\n8-A, National Highway,\nMorbi (Gujarat), India 363 642',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Social media or links icons (e.g., Facebook, Twitter, LinkedIn)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Facebook icon link (replace with actual URL)
              IconButton(
                icon: const Icon(Icons.facebook),
                onPressed: () {
                  // Add your URL opening logic here
                  print("https://www.facebook.com/argilgroup");
                },
              ),
              // Twitter icon link (replace with actual URL)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.instagram),
                    onPressed: () {
                      _launchURL(
                        'https://www.instagram.com/argilgroup?igsh=MnZkeWpvNmZqYXh0',
                      );
                    },
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    icon: const FaIcon(FontAwesomeIcons.linkedin),
                    onPressed: () {
                      _launchURL(
                        'https://www.linkedin.com/company/argilgroup/',
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}


