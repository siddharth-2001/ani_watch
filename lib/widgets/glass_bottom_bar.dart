import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

//local imports
import '../screens/home_screen.dart';
import '../screens/favourite_screen.dart';
import '../screens/settings_screen.dart';
import '../ui/search_box_ui.dart';

class GlassBottomBar extends StatefulWidget {
  late int currIndex;
  GlassBottomBar({super.key, required this.currIndex});

  @override
  State<GlassBottomBar> createState() => _GlassBottomBarState();
}

class _GlassBottomBarState extends State<GlassBottomBar> {
  final Color active = Colors.greenAccent.shade400, inactive = Colors.white;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GlassContainer(
        height: 70,
        width: screen.width,
        blur: 9,
        color: Colors.blueGrey.withOpacity(0.2),
        border: const Border.fromBorderSide(BorderSide.none),
        shadowStrength: 5,
        borderRadius: BorderRadius.circular(32),
        shadowColor: Colors.white.withOpacity(0.24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  if (widget.currIndex == 0) return;
                  Navigator.of(context).pushNamed(HomeScreen.routeName);
                },
                icon: Icon(
                  CupertinoIcons.home,
                  color: widget.currIndex == 0 ? active : inactive,
                )),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => SearchBoxUi());
                },
                icon: Icon(CupertinoIcons.search,
                    color: widget.currIndex == 1 ? active : inactive)),
            IconButton(
                onPressed: () {
                  if (widget.currIndex == 2) return;
                  Navigator.of(context).pushNamed(FavouriteScreen.routeName);
                },
                icon: Icon(CupertinoIcons.heart,
                    color: widget.currIndex == 2 ? active : inactive)),
            IconButton(
                onPressed: () {
                  if (widget.currIndex == 3) return;

                  Navigator.of(context).pushNamed(
                    SettingsScreen.routeName
                  );
                },
                icon: Icon(CupertinoIcons.settings,
                    color: widget.currIndex == 3 ? active : inactive)),
          ],
        ),
      ),
    );
  }
}