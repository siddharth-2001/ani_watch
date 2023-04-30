import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports

//provider imports
import '../provider/settings.dart';

class HomeUpperUi extends StatelessWidget {
  const HomeUpperUi({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
            text: TextSpan(children: [
          TextSpan(
            text: "Ani",
            style: TextStyle(color: appSettings.appThemeColor, fontSize: 16),
          ),
          const TextSpan(
              text: "Watch+",
              style: TextStyle(color: Colors.white, fontSize: 16))
        ])),
       CircleAvatar(radius: 20, child: Image.asset("assets/icon.png"),)
      ],
    );
  }
}
