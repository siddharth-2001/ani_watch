import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../ui/show_detail_ui.dart';

//provider imports
import '../provider/settings.dart';

class ShowDetailScreen extends StatelessWidget {
  final String id, image, tag;
  const ShowDetailScreen(
      {super.key, required this.id, required this.image, required this.tag});

  static const routeName = '/show-detail';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final appSettings = Provider.of<AppSettings>(context);

    return DismissiblePage(
      onDismissed: () => Navigator.of(context).pop(),
      direction: DismissiblePageDismissDirection.multi,
      backgroundColor: Colors.transparent,
      dismissThresholds: const {
        DismissiblePageDismissDirection.multi: .2,
      
      },
      reverseDuration: appSettings.reverseDuration,
      child: CupertinoPageScaffold(
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ShowDetailUi(
              id: id,
              image: image,
              tag: tag,
            ),
          )),
    );
  }
}
