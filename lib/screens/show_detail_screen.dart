import 'package:flutter/material.dart';

//local imports
import '../ui/show_detail_ui.dart';

class ShowDetailScreen extends StatelessWidget {
  const ShowDetailScreen({super.key});

  static const routeName = '/show-detail';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      // bottomNavigationBar: GlassBottomBar(),
      body:  Container(
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
        child: ShowDetailUi(id: args["id"], image: args["image"],))
    );
  }
}
