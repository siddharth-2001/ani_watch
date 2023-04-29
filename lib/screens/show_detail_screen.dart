import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//local imports
import '../ui/show_detail_ui.dart';

class ShowDetailScreen extends StatelessWidget {
  final String id, image, tag;
  const ShowDetailScreen({super.key, required this.id, required this.image, required this.tag});

  static const routeName = '/show-detail';
  

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
  
    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.multi,
      backgroundColor: Colors.transparent,
      dismissThresholds: const {

        DismissiblePageDismissDirection.vertical: .2,
      },

      minScale: .8,
      reverseDuration: const Duration(milliseconds: 250),
      child: CupertinoPageScaffold(

          resizeToAvoidBottomInset: false,
          // bottomNavigationBar: GlassBottomBar(),
          child: SingleChildScrollView(
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
                  id: id,
                  image: image,
                  tag: tag,
                )),
          )),
    );
  }
}
