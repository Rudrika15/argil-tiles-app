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
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return PopAndRedirectToHome(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFD3C8BA),
          surfaceTintColor: const Color(0xFFD3C8BA),
          title: Text(
            'Contact Us',
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: BackButton(
            style: ButtonStyle(
              iconSize: WidgetStatePropertyAll(isTablet ? 26 : 22),
            ),
          ),
          foregroundColor: Colors.black,
          elevation: 0,
          actions: [
            Builder(
              builder:
                  (context) => IconButton(
                    icon: Icon(
                      Icons.menu,
                      size: isTablet ? 28 : 24,
                    ),
                    onPressed: () => WidgetHelper.openEndDrawerSafely(context),
                  ),
            ),
            SizedBox(width: isTablet ? 12 : 8),
          ],
        ),
        endDrawerEnableOpenDragGesture: false,
        endDrawer: const DrawerWidget(),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 650 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              child: Container(
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    Text(
                      "for more information you can\nreach out to us",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 12,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
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
                        hintText: "Contact No (with country code)",
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter your contact number';
                          } else if (value.trim().length < 7) {
                            return 'Enter a valid contact number with country code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: AppColors.brown,
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                "Add mobile number with country code (e.g. +91 9876543210)",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                  : Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 17 : 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isTablet ? 36 : 30),
                _buildContactDetailsCard(isTablet),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
}

  Widget _buildContactDetailsCard([bool isTablet = false]) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7E3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title for the contact details card
          Text(
            "Contact Details",
            style: TextStyle(
              fontSize: isTablet ? 19 : 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF663333),
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),

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
                Icon(Icons.phone, size: isTablet ? 22 : 18),
                SizedBox(width: isTablet ? 12 : 8),
                Text(
                  phoneNumber,
                  style: TextStyle(fontSize: isTablet ? 15 : 12),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),

          InkWell(
            onTap: () => launchCustomUrl(email),
            child: Row(
              children: [
                Icon(Icons.email, size: isTablet ? 22 : 18),
                SizedBox(width: isTablet ? 12 : 8),
                Text(
                  email,
                  style: TextStyle(fontSize: isTablet ? 15 : 12),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 12 : 8),

          // Location row
          InkWell(
            onTap: () => launchCustomUrl(address),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, size: isTablet ? 22 : 18),
                SizedBox(width: isTablet ? 12 : 8),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(fontSize: isTablet ? 15 : 12),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),

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
