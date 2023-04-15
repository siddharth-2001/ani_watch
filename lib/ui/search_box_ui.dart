import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports
import '../widgets/glass_widget.dart';
import '../screens/search_screen.dart';

//provider imports
import '../provider/anime.dart';

class SearchBoxUi extends StatelessWidget {
  SearchBoxUi({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _textController = TextEditingController();
    final theme = Theme.of(context);

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
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(48)),
                child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(CupertinoIcons.search),
                    ),
                    expands: true,
                    maxLines: null,
                    minLines: null)),
          ),
          ElevatedButton(
              onPressed: () {
                Provider.of<AllAnime>(context, listen: false)
                    .searchAnime(_textController.value.text)
                    .then((value) {
                  Navigator.of(context).pushNamed(SearchScreen.routeName);
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(42))),
              child: Text("Search"))
        ],
      ),
    );
  }
}
