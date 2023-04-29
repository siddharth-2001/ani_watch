import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/wide_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class FavouriteAnimeList extends StatefulWidget {
  const FavouriteAnimeList({super.key});

  @override
  State<FavouriteAnimeList> createState() => _FavouriteAnimeListState();
}

class _FavouriteAnimeListState extends State<FavouriteAnimeList> {
  bool _isLoading = true;
  List<Anime> favouriteList = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AnimeService>(context, listen: false)
        .fetchFavData()
        .then((value) {
      Provider.of<AnimeService>(context, listen: false)
          .getFavourites()
          .then((value) {
        favouriteList = value;
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return _isLoading
        ? const SliverFillRemaining(
          child: Center(
              child: CupertinoActivityIndicator(
              color: Colors.white,
            )),
        )
        : favouriteList.isEmpty
                ? const Center(
                  child: Text(
                      "Nothing to show",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                )
                : SliverList(
                  
                  delegate: SliverChildBuilderDelegate(
                    childCount: favouriteList.length,
                    (context, index) {
                      final anime = favouriteList[index].details;

                      return WideShowPanel(
                          id: anime["id"],
                          name: anime["name"],
                          image: anime["image"],
                          episodes: anime["episodes"],
                          rating: anime["rating"],
                          genres: anime["genres"],
                          year: anime["releaseDate"]);
                    },
                  ),
                    
        );
  }
}
