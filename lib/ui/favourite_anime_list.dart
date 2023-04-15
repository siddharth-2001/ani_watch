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
    // TODO: implement initState
    super.initState();
    Provider.of<AllAnime>(context, listen: false)
        .fetchLocalFavData()
        .then((value) {
      Provider.of<AllAnime>(context, listen: false)
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

    return _isLoading
        ? Center(child: CupertinoActivityIndicator(color: Colors.white,))
        : Container(
            child: favouriteList.length == 0
                ? Text("Nothing to show", style: TextStyle(color: Colors.white,),)
                : ListView.builder(
                    padding: EdgeInsets.only(top: 0, bottom: padding.bottom),
                    physics: BouncingScrollPhysics(),
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
