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
      bottomNavigationBar: const GlassBottomBar(currIndex: 3),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screen.height,
        width: screen.width,
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        child: Center(
          child: Text("Settings",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.deepPurpleAccent.shade100, fontWeight: FontWeight.w800)),
        ),
      ),
    );
  }
}
