import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:stream_app/widgets/glass_button.dart';
import 'package:video_player/video_player.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:provider/provider.dart';
import 'package:dismissible_page/dismissible_page.dart';

//local imports
import '../widgets/glass_widget.dart';
import '../ui/watch_episode_ui.dart';

//provider imports
import '../provider/anime.dart';

class WatchEpisodeScreen extends StatefulWidget {
  const WatchEpisodeScreen({super.key});

  static const routeName = '/watch';

  @override
  State<WatchEpisodeScreen> createState() => _WatchEpisodeScreenState();
}

class _WatchEpisodeScreenState extends State<WatchEpisodeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final devicePadding = MediaQuery.of(context).viewPadding;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: 
           WatchEpisodeUi(animeId: args["id"]!)
    );
  }
}
