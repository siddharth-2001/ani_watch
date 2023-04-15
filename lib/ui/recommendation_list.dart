import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//local imports
import '../widgets/glass_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class RecommendedAnimeList extends StatefulWidget {
  final List<Anime> recommendationList;
  const RecommendedAnimeList(
      {super.key, required this.recommendationList});

  @override
  State<RecommendedAnimeList> createState() => _RecommendedAnimeListState();
}

class _RecommendedAnimeListState extends State<RecommendedAnimeList> {
  bool _isLoading = true;
  late List<Anime> list;

  @override
  void initState() {
    super.initState();
    list = widget.recommendationList;
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _isLoading == true
        ? const Center(
            child: CupertinoActivityIndicator(
            color: Colors.white,
          ))
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
