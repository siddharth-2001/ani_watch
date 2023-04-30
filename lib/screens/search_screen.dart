import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//local imports
import '../ui/search_anime_list.dart';

//provider imports

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _searchWidget = const Center(
    child: Text(
      "Search Anime",
      style: TextStyle(color: Colors.white),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        navigationBar: CupertinoNavigationBar(
          middle: CupertinoSearchTextField(
            itemColor: Colors.white60,
            onSubmitted: (value) {
              setState(() {
                if (value == "") {
                  _searchWidget = const Center(
                    child: Text(
                      "Search Anime",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  _searchWidget = SearchAnimeList(
                    key: Key(value),
                    query: value,
                  );
                }
              });
            },
          ),
        ),
        child: SingleChildScrollView(
            child: SizedBox(
          height: screen.height,
          width: screen.width,
          child: _searchWidget,
        )));
  }
}
