import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import './home_screen.dart';
import './search_screen.dart';
import './favourite_screen.dart';
import './settings_screen.dart';

//provider imports
import '../provider/settings.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const routeName = '/main';

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    const double iconSize = 24;
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        inactiveColor: Colors.white60,
        backgroundColor:Colors.grey.shade900.withOpacity(appSettings.blurOverlayOpacity),
        activeColor: appSettings.appThemeColor, items: const [
        BottomNavigationBarItem(
            label: "Watch Now",
            icon: Icon(
              CupertinoIcons.play_circle_fill,
              size: iconSize,
            )),
        BottomNavigationBarItem(
            label: "Favourites",
            icon: Icon(
              CupertinoIcons.heart,
              size: iconSize,
            )),
        BottomNavigationBarItem(
            label: "Search",
            icon: Icon(
              CupertinoIcons.search,
              size: iconSize,
            )),
        BottomNavigationBarItem(
            label: "Settings",
            icon: Icon(
              CupertinoIcons.settings,
              size: iconSize,
            )),
      ]),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return const HomeScreen();

          case 1:
            return const FavouriteScreen();

          case 2:
            return const SearchScreen();

          case 3:
            return const SettingsScreen();

          default:
            return const HomeScreen();
        }
      },
    );
  }
}
