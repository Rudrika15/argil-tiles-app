// import 'package:argil_tiles/provider/drawer_provider/new_drawer_provider.dart';
// import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/provider/contact_us_provider.dart';
import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:argil_tiles/provider/drawer_provider/new_drawer_provider.dart';
import 'package:argil_tiles/provider/favroite_provider.dart';
import 'package:argil_tiles/provider/newarraival_provider.dart';
import 'package:argil_tiles/provider/product_inquiry_provider.dart';
import 'package:argil_tiles/provider/quartzproducts_provider.dart';
import 'package:argil_tiles/provider/spcproducts_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:argil_tiles/provider/homescreen_provider.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [  
        ChangeNotifierProvider(create: (context) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (context) => QuartzproductsProvider()),
        ChangeNotifierProvider(create: (context) => SpcProductProvider()),
        ChangeNotifierProvider(create: (context) => NewarrivalProvider()),
        ChangeNotifierProvider(create: (context) => ProductInquiryProvider()),
        ChangeNotifierProvider(create: (context) => DrawerProvider()),
        ChangeNotifierProvider(create: (context) => NewDrawerProvider()),
        ChangeNotifierProvider(create: (context) => ContactUsProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder:
          (context, orientation, screenType) => MaterialApp(
            title: 'Argil',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(scaffoldBackgroundColor: AppColors.whiteColor),
            home: const SplashScreen(),
          ),
    );
  }
}
