import 'package:ani_watch/provider/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final appSettigns = Provider.of<AppSettings>(context);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
           CupertinoSliverNavigationBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.grey.shade900.withOpacity(appSettigns.blurOverlayOpacity),
            largeTitle: Text(
              "Favourites",
              style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white),
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
