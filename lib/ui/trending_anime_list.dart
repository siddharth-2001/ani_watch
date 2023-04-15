import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class TrendingAnimeList extends StatefulWidget {
  const TrendingAnimeList({super.key});

  @override
  State<TrendingAnimeList> createState() => _TrendingAnimeListState();
}

class _TrendingAnimeListState extends State<TrendingAnimeList> {
  bool _isLoading = true;
  List<Anime> list = [];
  @override
  void initState() {
    super.initState();
    Provider.of<TrendingAnime>(context, listen: false)
        .getTrendingAnime()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<TrendingAnime>(context, listen: true).trendingList;
    final size = MediaQuery.of(context).size;

    return _isLoading == true
        ? const Center(child: CupertinoActivityIndicator(color: Colors.white,))
        : SizedBox(
            height: 220,
            width: size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              physics: const BouncingScrollPhysics(),
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
