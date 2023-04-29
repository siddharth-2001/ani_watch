import 'package:ani_watch/provider/anime.dart';
import 'package:ani_watch/widgets/blur_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports
import '../ui/search_anime_list.dart';
import '../widgets/glass_bottom_bar.dart';

//provider imports

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  static const routeName = '/search';
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).viewPadding;
    final screen = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // leading: SizedBox(),
          trailing: CupertinoButton(child: Text("Clear", style: TextStyle(color: Colors.greenAccent.shade400),), onPressed: ()=> Provider.of<AnimeService>(context, listen: false)
                  .clearSearchList(),),
          middle: CupertinoSearchTextField(
            controller: _controller,

    
            itemColor: Colors.white60,
            onSubmitted: (value) {
              Provider.of<AnimeService>(context, listen: false)
                  .searchAnime(value);
            },
          ),
        ),
        child: SearchAnimeList());
  }
}
