import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//local imports
import '../ui/favourite_anime_list.dart';

//provider imports

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  static const routeName = '/favourites';

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      resizeToAvoidBottomInset: false,
      child: CustomScrollView(
        slivers: [
          const CupertinoSliverNavigationBar(
            brightness: Brightness.dark,
            largeTitle: Text(
              "Favourites",
              style: TextStyle(color: Colors.white),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              setState(() {});
            },
          ),
          SliverPadding(
              padding: EdgeInsets.only(bottom: padding.bottom + 16),
              sliver: const FavouriteAnimeList()),
        ],
      ),
    );
  }
}
