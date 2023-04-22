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
    final size = MediaQuery.of(context).size;

    return _isLoading == true
        ? const Center(
            child: CupertinoActivityIndicator(
            color: Colors.white,
          ))
        :  SizedBox(
          height: size.height * 0.22,
          child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Center(
                    child: GlassShowPanel(
                      tag: "popular",
                      id: list[index].details["id"],
                      name: list[index].details["name"],
                      image: list[index].details["image"],
                      episodes: list[index].details["episodes"],
                    ),
                  );
                },
             
            ),
        );
  }
}
