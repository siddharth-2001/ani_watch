import 'package:ani_watch/ui/auth_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//local imports
import '../widgets/blur_image.dart';

//provider imports

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
     
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      child: 
      
      Stack(

        children: [
         const BlurImageBackground(image: "assets/auth_bg.jpg", isAsset: true,),
          SingleChildScrollView(
            child: SizedBox(
              height: size.height,
              width: size.width,
              child: Column(
                children: const [
                  
                  Flexible(child: Center(child: AuthUi())),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
