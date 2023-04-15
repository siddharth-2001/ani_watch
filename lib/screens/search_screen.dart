import 'package:flutter/material.dart';
import 'package:stream_app/widgets/glass_bottom_bar.dart';

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

    return Scaffold(
      bottomNavigationBar: const GlassBottomBar(currIndex: 1),
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screen.height,
        width: screen.width,
        padding: EdgeInsets.only(top:screenPadding.top),
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [Color(0xff1e2757), Color(0xff0a0d1d)],
          stops: [0, 1],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text("Search Results",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w800)),
            ),
            const Flexible(child: SearchAnimeList())
          ],
        ),
      ),
    );
  }
}
