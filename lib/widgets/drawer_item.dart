import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_const/app_color.dart';
import '../provider/homescreen_provider.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.title,
    required this.icon,
    required this.index,
    required this.screen,
  });
  final String title;
  final IconData? icon;
  final int index;
  final Widget screen;
  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    return ListTile(
      tileColor: AppColors.errorColor,
      leading: icon != null ? Icon(icon, color: AppColors.whiteColor) : null,
      title: Text(title, style: const TextStyle(color: AppColors.whiteColor)),
      onTap: () {
        homeScreenProvider.setSelectedIndex = index;
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }
}
