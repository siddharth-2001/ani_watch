import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_recent_episode_panel.dart';

//provider imports
import '../provider/anime.dart';

class RecentEpisodeUi extends StatefulWidget {
  const RecentEpisodeUi({super.key});

  @override
  State<RecentEpisodeUi> createState() => _RecentEpisodeUiState();
}

class _RecentEpisodeUiState extends State<RecentEpisodeUi> {
  bool _isLoading = true;
  List<Anime> list = [];

  @override
  void initState() {

    super.initState();
    Provider.of<RecentEpisodes>(context, listen: false)
        .getRecentEpisodes()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    list = Provider.of<RecentEpisodes>(context, listen: true).recentList;
   
    
    return _isLoading
        ? const CupertinoActivityIndicator()
        : 
           ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              padding: EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast),
              itemBuilder: (BuildContext context, int index) {
                return GlassRecentPanel(
                  id: list[index].details["id"]!,
                  name: list[index].details["name"]!,
                  episodes: list[index].details["episodes"]!,
                  image: list[index].details["image"]!,
                );
              },
            
        );
  }
}
