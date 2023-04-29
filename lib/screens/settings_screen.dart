import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
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
    return CupertinoPageScaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Settings", style: TextStyle(color: Colors.white),),
      ),
      child: Container(
        height: screen.height,
        width: screen.width,
        padding: EdgeInsets.only(top: padding.top),
        child:
            Center(
              child: CupertinoButton(
                color: Colors.greenAccent.shade400,
                child: const Text(
                  "Logout",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                onPressed: () =>
                    Provider.of<UserService>(context, listen: false)
                        .logout()
                        .then((value) => Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName)),
              ),
            )
        
      ),
    );
  }
}
