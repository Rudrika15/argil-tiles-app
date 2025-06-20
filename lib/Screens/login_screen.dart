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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: AppSize.size80,
                  color: Colors.grey,
                ),
                SizeHelper.height(),
                const Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        decoration: InputDecoration(
                          labelText: 'Email',
                          enabledBorder: brownBorder(),
                          focusedBorder: brownBorder(),
                          labelStyle: TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.brown,
                          ),
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizeHelper.height(),

                      // Password Field
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          enabledBorder: brownBorder(),
                          focusedBorder: brownBorder(),
                          labelText: 'Password',
                          labelStyle: TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.brown,
                          ),

                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                          border: const OutlineInputBorder(),
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
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.brown,
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
                                        .copyWith(color: AppColors.whiteColor),
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
                        child: Text(
                          "Skip",
                          style: TextStyleHelper.smallText.copyWith(
                            color: AppColors.brown,
                            decoration: TextDecoration.underline,
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
    );
  }

  OutlineInputBorder brownBorder() {
    return OutlineInputBorder(borderSide: BorderSide(color: AppColors.brown));
  }
}
