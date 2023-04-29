import 'package:ani_watch/provider/anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports
import '../ui/search_anime_list.dart';

//provider imports

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static const routeName = '/search';

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).viewPadding;
    final screen = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          // leading: SizedBox(),
          middle: CupertinoSearchTextField(
            

    
            itemColor: Colors.white60,
            onSubmitted: (value) {
              Provider.of<AnimeService>(context, listen: false)
                  .searchAnime(value);
            },
          ),
        ),
        child: const SearchAnimeList());
  }
}
