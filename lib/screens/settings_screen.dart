import 'package:ani_watch/widgets/blur_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_bottom_bar.dart';
import './auth_screen.dart';

//provider imports
import '../provider/auth.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    final padding = MediaQuery.of(context).padding;
    return Scaffold(
      bottomNavigationBar: const GlassBottomBar(currIndex: 3),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const BlurImageBackground(image: "assets/settings_bg.jpg", isAsset: true),

          Container(
            height: screen.height,
            width: screen.width,
            padding: EdgeInsets.only(top: padding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screen.width * 0.05,
                      vertical: screen.height * 0.025),
                  child: Text("Settings",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.greenAccent.shade400,
                          fontWeight: FontWeight.w800)),
                ),
                Center(
                  child: CupertinoButton(
                    color: Colors.greenAccent.shade400,
                    child: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w800),),
                    onPressed: () => Provider.of<UserService>(context, listen: false)
                        .logout()
                        .then((value) => Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
