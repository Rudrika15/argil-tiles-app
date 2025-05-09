// import 'package:argil_tiles/provider/drawer_provider/new_drawer_provider.dart';
// import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:argil_tiles/provider/drawer_provider/drawer_provider.dart';
import 'package:argil_tiles/provider/drawer_provider/new_drawer_provider.dart';
import 'package:argil_tiles/provider/newarraival_provider.dart';
import 'package:argil_tiles/provider/product_inquiry_provider.dart';
import 'package:argil_tiles/provider/quartzproducts_provider.dart';
import 'package:argil_tiles/provider/spcproducts_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:argil_tiles/provider/homescreen_provider.dart';
import 'package:argil_tiles/Screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider
        (
          create: (context) => HomeScreenProvider()
        ),
        ChangeNotifierProvider
        (
          create: (context) => QuartzproductsProvider()
        ),
        ChangeNotifierProvider
        (
          create: (context) => SpcProductProvider()
        ),
        ChangeNotifierProvider
        (
          create: (context) => NewarrivalProvider()
        ),
       ChangeNotifierProvider
        (
          create: (context) => ProductInquiryProvider()
        ),
      ChangeNotifierProvider
      (
        create: (context) => DrawerProvider(),
      ),
      ChangeNotifierProvider
      (
        create: (context) => NewDrawerProvider()
      )
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeScreen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const SplashScreen(),
    );
  }
}
