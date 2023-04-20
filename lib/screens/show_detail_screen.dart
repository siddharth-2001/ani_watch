import 'package:dismissible_page/dismissible_page.dart';
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

    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.vertical,
      backgroundColor: Colors.black,
      dismissThresholds: const {
        DismissiblePageDismissDirection.vertical: .2,
      },
      minScale: .8,
      reverseDuration: const Duration(milliseconds: 250),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          // bottomNavigationBar: GlassBottomBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
                height: screen.height,
                width: screen.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  colors: [Color(0xff1e2757), Color(0xff0a0d1d)],
                  stops: [0, 1],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                )),
                child: ShowDetailUi(
                  id: args["id"],
                  image: args["image"],
                  tag: args["tag"],
                )),
          )),
    );
  }
}
