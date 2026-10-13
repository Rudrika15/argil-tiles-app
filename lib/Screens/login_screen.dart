import 'package:argil_tiles/Screens/HomeScreen.dart';
import 'package:argil_tiles/Screens/dashboard_screen.dart';
import 'package:argil_tiles/provider/auth_provider.dart';
import 'package:argil_tiles/provider/homescreen_provider.dart';
import 'package:argil_tiles/utils/size_helper/size_helper.dart';
import 'package:argil_tiles/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_color.dart';
import '../app_const/app_size.dart';
import '../utils/method_helper/gradient_helper.dart';
import '../utils/text_style_helper/text_style_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: CustomContainer(
          alignment: Alignment.center,
          height: 100.h,
          gradient: LinearGradient(
            colors: BoxShadowHelper.homeGradient,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 460 : double.infinity,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 5.w,
                  vertical: isTablet ? 24 : 16,
                ),
                child: Container(
                  padding: isTablet
                      ? const EdgeInsets.symmetric(horizontal: 36, vertical: 40)
                      : EdgeInsets.zero,
                  decoration: isTablet
                      ? BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.brown.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brown.withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        )
                      : null,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: isTablet ? 90 : AppSize.size80,
                        color: isTablet ? AppColors.brown : Colors.grey,
                      ),
                      SizeHelper.height(),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizeHelper.height(),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                              onTapOutside:
                                  (event) =>
                                      Navigator.of(context).focusNode.unfocus(),
                              decoration: InputDecoration(
                                contentPadding: isTablet
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 18,
                                      )
                                    : null,
                                labelText: 'Email',
                                enabledBorder: brownBorder(isTablet),
                                focusedBorder: brownBorder(isTablet),
                                labelStyle: TextStyleHelper.smallHeading.copyWith(
                                  color: AppColors.brown,
                                  fontSize: isTablet ? 16 : null,
                                ),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  size: isTablet ? 22 : null,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 10 : 4,
                                  ),
                                ),
                              ),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter email";
                                }
                                final emailRegex = RegExp(
                                  r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                                );
                                return emailRegex.hasMatch(value)
                                    ? null
                                    : "Enter valid email";
                              },
                            ),
                            SizeHelper.height(),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              style: TextStyle(fontSize: isTablet ? 16 : 14),
                              onTapOutside:
                                  (event) =>
                                      Navigator.of(context).focusNode.unfocus(),
                              decoration: InputDecoration(
                                contentPadding: isTablet
                                    ? const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 18,
                                      )
                                    : null,
                                enabledBorder: brownBorder(isTablet),
                                focusedBorder: brownBorder(isTablet),
                                labelText: 'Password',
                                labelStyle: TextStyleHelper.smallHeading.copyWith(
                                  color: AppColors.brown,
                                  fontSize: isTablet ? 16 : null,
                                ),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  size: isTablet ? 22 : null,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: isTablet ? 22 : null,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () => _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    isTablet ? 10 : 4,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            SizeHelper.height(),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: isTablet ? 54 : null,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState?.validate() == true) {
                                    final bool success = await authProvider.login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      context: context,
                                    );
                                    if (success) {
                                      homeScreenProvider.setSelectedIndex = 0;
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => DashboardPage(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isTablet ? 16 : 14,
                                  ),
                                  backgroundColor: AppColors.brown,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      isTablet ? 10 : 8,
                                    ),
                                  ),
                                ),
                                child:
                                    authProvider.isLoading
                                        ? Center(
                                          child: CustomContainer(
                                            width: AppSize.size20,
                                            height: AppSize.size20,
                                            child: CircularProgressIndicator(
                                              color: AppColors.whiteColor,
                                              backgroundColor: AppColors.brown,
                                            ),
                                          ),
                                        )
                                        : Text(
                                          'Login',
                                          style: TextStyleHelper.mediumHeading
                                              .copyWith(
                                                color: AppColors.whiteColor,
                                                fontSize: isTablet ? 18 : null,
                                              ),
                                        ),
                              ),
                            ),
                            SizeHelper.height(),
                            InkWell(
                              onTap:
                                  () => Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                    (route) => false,
                                  ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 8 : 4,
                                  horizontal: 16,
                                ),
                                child: Text(
                                  "Skip",
                                  style: TextStyleHelper.smallText.copyWith(
                                    color: AppColors.brown,
                                    fontSize: isTablet ? 16 : null,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder brownBorder([bool isTablet = false]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(isTablet ? 10 : 4),
      borderSide: BorderSide(
        color: AppColors.brown,
        width: isTablet ? 1.2 : 1.0,
      ),
    );
  }
}
