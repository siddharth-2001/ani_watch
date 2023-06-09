import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:figma_squircle/figma_squircle.dart';

//local imports
import '../widgets/glass_widget.dart';
import '../screens/search_screen.dart';

//provider imports
import '../provider/anime.dart';

class SearchBoxUi extends StatelessWidget  {
  const SearchBoxUi({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textController = TextEditingController();

    return GlassWidget(
      color: Colors.blueGrey,
      height: 900,
      width: size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: size.width,
                decoration:ShapeDecoration(
                      color: Colors.white,
                      shape: SmoothRectangleBorder(
                      borderRadius: SmoothBorderRadius(cornerRadius: 10, cornerSmoothing: 1)
                    )),
                child: TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(CupertinoIcons.search),
                    ),
                    expands: true,
                    maxLines: null,
                    minLines: null)),
          ),
          ElevatedButton(
              onPressed: () {
                Provider.of<AnimeService>(context, listen: false)
                    .searchAnime(textController.value.text)
                    .then((value) {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42))),
              child: const Text("Search", style: TextStyle(fontWeight: FontWeight.w800),))
        ],
      ),
    );
  }
}
