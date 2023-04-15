import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class RecommendedAnimeList extends StatefulWidget {
  late List<Anime> _recommendationList;
  RecommendedAnimeList({required List<Anime> recommendationList}) {
    _recommendationList = recommendationList;
  }

  @override
  State<RecommendedAnimeList> createState() => _RecommendedAnimeListState();
}

class _RecommendedAnimeListState extends State<RecommendedAnimeList> {
  bool _isLoading = true;
  late List<Anime> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget._recommendationList;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _isLoading == true
        ? Center(child: CupertinoActivityIndicator(color: Colors.white,))
        : Container(
          height: 220,
          width: size.width,
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
