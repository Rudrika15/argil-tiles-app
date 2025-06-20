import 'package:argil_tiles/provider/auth_provider.dart';
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
    this.shouldPushRemove = false,
  });
  final String title;
  final IconData? icon;
  final int index;
  final Widget screen;
  final bool shouldPushRemove;
  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    AuthProvider authProvider = context.watch<AuthProvider>();
    bool selected = index == homeScreenProvider.selectedIndex;
    return ListTile(
      selected: selected,
      selectedTileColor: Color.fromARGB(238, 81, 58, 29),
      leading: icon != null ? Icon(icon, color: AppColors.whiteColor) : null,
      title: Text(title, style: const TextStyle(color: AppColors.whiteColor)),
      onTap: () {
        if (selected) {
          Navigator.pop(context);
          return;
        }

        homeScreenProvider.setSelectedIndex = index;

        if (shouldPushRemove) {
          authProvider.setAdminLoginStatus(status: false);
          homeScreenProvider.setSelectedIndex = 0;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => screen),
            (route) => false,
          );
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        }
      },
    );
  }
}
