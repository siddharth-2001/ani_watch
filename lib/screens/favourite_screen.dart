import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//local imports
import '../ui/favourite_anime_list.dart';

//provider imports

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  static const routeName = '/favourites';

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      // bottomNavigationBar: const GlassBottomBar(
      //   currIndex: 2,
      // ),
      resizeToAvoidBottomInset: false,
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            brightness: Brightness.dark,
            stretch: true,
            largeTitle: Text("Favourites", style: TextStyle(color: Colors.white),),
          ),
             SliverPadding
             (
             
              padding: EdgeInsets.only(bottom: padding.bottom + 16),
              sliver: FavouriteAnimeList()),
            

      

        ],
      ),
    );
  }
}
