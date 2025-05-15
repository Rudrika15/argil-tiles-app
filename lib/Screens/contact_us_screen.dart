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

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  ///
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Can't open this link"),
          backgroundColor: Colors.red,
        ),
      );
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
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                AppColors.primaryColor,
                                            content: Text(
                                              contactUsProvider
                                                      .contactUsQueryDone
                                                      ?.message ??
                                                  "",
                                            ),
                                          ),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.facebook,
                  color: Color(0xFF1877F2),
                ),
                onPressed: () {
                  _launchURL("https://www.facebook.com/argilgroup");
                },
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Color(0xFFC13584),
                ),
                onPressed: () {
                  _launchURL('https://www.instagram.com/argilgroup/');
                },
              ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: Color(0xFF0A66C2),
                ),
                onPressed: () {
                  _launchURL(
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
