import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class PopularAnimeList extends StatefulWidget {
  const PopularAnimeList({super.key});

  @override
  State<PopularAnimeList> createState() => _PopularAnimeListState();
}

class _PopularAnimeListState extends State<PopularAnimeList> {
  bool _isLoading = true;
  List<Anime> list = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PopularAnime>(context, listen: false)
        .getPopularAnime()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<PopularAnime>(context, listen: true).popularList;

    return _isLoading == true
        ? Center(child: CupertinoActivityIndicator(color: Colors.white,))
        : Container(
          height: 220,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return GlassShowPanel(
            id: list[index].details["id"],
            name: list[index].details["name"],
            image: list[index].details["image"],
            episodes: list[index].details["episodes"],
              );
              },
            ),
        );
  }
}