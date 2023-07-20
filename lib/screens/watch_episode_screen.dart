import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//local imports
import '../ui/watch_episode_ui.dart';

//provider imports

class WatchEpisodeScreen extends StatelessWidget {
  final String id, tag;
  final int index;
  const WatchEpisodeScreen({super.key, required this.id, required this.tag, required this.index});

  static const routeName = '/watch';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      disabled: false,
      minRadius: 10,
      maxRadius: 10,
      dragSensitivity: 1.0,
      maxTransformValue: .8,
      direction: DismissiblePageDismissDirection.startToEnd,
      dismissThresholds: const {
        DismissiblePageDismissDirection.multi: .2
       
      },
      reverseDuration: const Duration(milliseconds: 500),
      child: Scaffold(
         
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          body: 
           SingleChildScrollView(
                child: SizedBox(
                    height: size.height,
                    width: size.width,
                    child: WatchEpisodeUi(
                      animeId: id,
                      index: index,
                      tag: tag,
                    ))),
          ),
    );
  }
}
