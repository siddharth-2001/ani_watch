
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


    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: 
           WatchEpisodeUi(animeId: args["id"]!, index: args["index"]!,)
    );
  }
}
