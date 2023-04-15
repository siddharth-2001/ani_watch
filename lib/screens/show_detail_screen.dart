import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:hexcolor/hexcolor.dart';

//local imports
import '../ui/show_detail_ui.dart';
import '../widgets/glass_widget.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_bottom_bar.dart';

class ShowDetailScreen extends StatelessWidget {
  const ShowDetailScreen({super.key});

  static const routeName = '/show-detail';

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).viewPadding;
    final theme = Theme.of(context);
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
        child: ShowDetailUi(id: args["id"]))
    );
  }
}
