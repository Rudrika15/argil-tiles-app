import 'package:argil_tiles/provider/contact_us_provider.dart';
import 'package:argil_tiles/widgets/custom_text_form_field.dart';
import 'package:argil_tiles/widgets/drawer.dart';
import 'package:argil_tiles/widgets/pop_to_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_const/app_color.dart';
import '../utils/widget_helper/widhet_helper.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  /// contact details
  final String phoneNumber = "+ 91 9925511465";
  final String email = 'info@argiltiles.com';
  final String address =
      "Argil Group\n8-A, National Highway,\nMorbi(Gujarat)-363642\nIndia";

  ///
  Future<void> launchCustomUrl(String input) async {
    Uri? uri;

    // Detect Email
    if (RegExp(r'^[\w\.\-]+@[\w\.\-]+\.\w+$').hasMatch(input)) {
      uri = Uri(scheme: 'mailto', path: input);
    }
    // Detect Pure Text Address → Google Maps Search
    else if (!input.startsWith('http') && !input.startsWith('geo:')) {
      final encoded = Uri.encodeComponent(input);
      uri = Uri.parse(
        "https://www.google.com/maps/search/?api=1&query=$encoded",
      );
    }
    // Otherwise treat as general URL
    else {
      uri = Uri.parse(input);
    }

    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed To Open"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ContactUsProvider contactUsProvider = context.watch<ContactUsProvider>();
    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          surfaceTintColor: const Color(0xFFD3C8BA),
          title: const Text('Contact Us'),
          leading: const BackButton(),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        endDrawer: DrawerWidget(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                const Text(
                  "for more information you can\nreach out to us",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Form(
                  key: contactUsProvider.formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: contactUsProvider.nameController,
                        onChanged:
                            (value) =>
                                contactUsProvider.formKey.currentState
                                    ?.validate(),
                        hintText: "Name",
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter your name'
                                    : null,
                      ),
                      SizedBox(height: 2.h),
                      CustomTextFormField(
                        controller: contactUsProvider.emailController,
                        onChanged:
                            (value) =>
                                contactUsProvider.formKey.currentState
                                    ?.validate(),
                        hintText: "Email",
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
                      SizedBox(height: 2.h),
                      CustomTextFormField(
                        controller: contactUsProvider.contactController,
                        onChanged:
                            (value) =>
                                contactUsProvider.formKey.currentState
                                    ?.validate(),
                        hintText: "Contact No",
                        maxLength: 10,
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
                      SizedBox(height: 2.h),
                      CustomTextFormField(
                        controller: contactUsProvider.messageController,
                        onChanged:
                            (value) =>
                                contactUsProvider.formKey.currentState
                                    ?.validate(),
                        hintText: "Message",
                        maxLines: 4,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Enter a message'
                                    : null,
                      ),
                      SizedBox(height: 3.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed:
                              contactUsProvider.isLoading
                                  ? () {}
                                  : () async {
                                    if (contactUsProvider.formKey.currentState
                                            ?.validate() ??
                                        false) {
                                      bool success = await contactUsProvider
                                          .contactUs(context: context);
                                      if (success) {
                                        WidgetHelper.customSnackBar(
                                          context: context,
                                          title:
                                              contactUsProvider
                                                  .contactUsQueryDone
                                                  ?.message ??
                                              "",
                                          color: AppColors.brown,
                                        );
                                      }
                                    }
                                  },
                          child:
                              contactUsProvider.isLoading
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

          InkWell(
            onTap: () async {
              final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
              if (!await launchUrl(launchUri)) {
                // Handle error, e.g., show a SnackBar or AlertDialog
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Failed To Open"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Row(
              children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(width: 8),
                Text(phoneNumber, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          InkWell(
            onTap: () => launchCustomUrl(email),
            child: Row(
              children: [
                const Icon(Icons.email, size: 18),
                const SizedBox(width: 8),
                Text(email, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Location row
          InkWell(
            onTap: () => launchCustomUrl(address),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(address, style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  color: Color(0xFF1877F2),
                ),
                onPressed: () {
                  launchCustomUrl("https://www.facebook.com/argilgroup");
                },
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Color(0xFFC13584),
                ),
                onPressed: () {
                  launchCustomUrl('https://www.instagram.com/argilgroup/');
                },
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: Color(0xFF0A66C2),
                ),
                onPressed: () {
                  launchCustomUrl(
                    'https://www.linkedin.com/company/argilgroup/?viewAsMember=true',
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
