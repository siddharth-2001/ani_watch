import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/current_watch_panel.dart';

//provider imports
import '../provider/anime.dart';

class CurrentWatchList extends StatefulWidget {
  const CurrentWatchList({super.key});

  @override
  State<CurrentWatchList> createState() => _CurrentWatchListState();
}

class _CurrentWatchListState extends State<CurrentWatchList> {
  bool _isLoading = true;
  List<Map<Anime, int>> list = [];

  @override
  void initState() {
    super.initState();
    Provider.of<AnimeService>(context, listen: false)
        .fetchCurrentlyWatching()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<AnimeService>(context, listen: true).currWatchList;
    final size = MediaQuery.of(context).size;

    return _isLoading
        ? const CupertinoActivityIndicator()
        : SizedBox(
          height: size.height * 0.22,
          child: ListView.builder(
            
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                final Anime anime = list[index].keys.first;
                return CurrentWatchPanel(
                  id: anime.details["id"]!,
                  name: anime.details["name"]!,
                  episodeIndex: list[index].values.first.toString(),
                  image: anime.details["image"]!,
                );
              },
            ),
        );
  }
}
