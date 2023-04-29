import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

//local imports
import '../widgets/wide_show_panel.dart';

//provider imports
import '../provider/anime.dart';

class SearchAnimeList extends StatefulWidget {
  const SearchAnimeList({super.key});

  @override
  State<SearchAnimeList> createState() => _SearchAnimeListState();
}

class _SearchAnimeListState extends State<SearchAnimeList> {
  bool _isLoading = true;
  List<Anime> list = [];
  @override
  Widget build(BuildContext context) {
    list = Provider.of<AnimeService>(context, listen: true).getSearchList;
    final padding = MediaQuery.of(context).padding;
    setState(() {
      _isLoading = false;
    });
    return _isLoading == true
        ? const Center(child: CupertinoActivityIndicator(color: Colors.white,))
        : list.isEmpty ? const Center(child: Text("Search for your anime", style: TextStyle(color: Colors.white),),) : ListView.builder(
            // scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(top: padding.top + 16, bottom: padding.bottom ,left:8, right: 8),
            itemCount: list.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return WideShowPanel(
                id: list[index].details["id"],
                name: list[index].details["name"],
                image: list[index].details["image"],
                episodes: list[index].details["episodes"],
                rating: list[index].details["rating"],
                genres: list[index].details["genres"],
                year: list[index].details["releaseDate"],
              );
            },
          );
  }
}
