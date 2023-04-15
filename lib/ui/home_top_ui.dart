import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

//local imports
import '../widgets/glass_button.dart';

class HomeUpperUi extends StatelessWidget {
  const HomeUpperUi({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ani", style: theme.textTheme.headlineSmall!.copyWith(color: Colors.greenAccent.shade400 , fontWeight: FontWeight.w900),),
            Text("Watch+", style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white , fontWeight: FontWeight.w900),),
          ],
        ),
      ],
    );
  }
}