import 'package:flutter/material.dart';

//local imports
import '../widgets/glass_bottom_bar.dart';

//provider imports

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: GlassBottomBar(currIndex: 3),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screen.height,
        width: screen.width,
        decoration: const BoxDecoration(
          gradient:  LinearGradient(
              colors: [Color(0xff1e2757), Color(0xff0a0d1d)],
              stops: [0, 1],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            )
        ),
        child: Center(
          child: Text("Settings",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}
