
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';

//local imports
import '../ui/watch_episode_ui.dart';

//provider imports

class WatchEpisodeScreen extends StatefulWidget {
  const WatchEpisodeScreen({super.key});

  static const routeName = '/watch';

  @override
  State<WatchEpisodeScreen> createState() => _WatchEpisodeScreenState();
}

class _WatchEpisodeScreenState extends State<WatchEpisodeScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final size = MediaQuery.of(context).size;


    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
    
      disabled: false,
      minRadius: 10,
      maxRadius: 10,
      dragSensitivity: 1.0,
      maxTransformValue: .8,
      direction: DismissiblePageDismissDirection.down,

  
      dismissThresholds: const {
        DismissiblePageDismissDirection.vertical: .2,
      },
      minScale: .8,
      reverseDuration: const Duration(milliseconds: 250),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: 
             SingleChildScrollView(child: SizedBox(
              height: size.height,
              width: size.width,
              child: WatchEpisodeUi(animeId: args["id"]!, index: args["index"]!, tag: args["tag"],)))
      ),
    );
  }
}
