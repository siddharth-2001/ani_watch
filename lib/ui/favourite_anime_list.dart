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
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;

    return _isLoading
        ? const Center(
            child: CupertinoActivityIndicator(
            color: Colors.white,
          ))
        : Container(
            child: favouriteList.isEmpty
                ? const Center(
                  child: Text(
                      "Nothing to show",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                )
                : ListView.builder(
                    padding: EdgeInsets.only(
                        top: 0,
                        bottom: padding.bottom,
                        left: size.width * 0.05,
                        right: size.width * 0.05),
                    physics: const BouncingScrollPhysics(),
                    itemCount: favouriteList.length,
                    itemBuilder: (context, index) {
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
