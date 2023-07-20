// ignore_for_file: sized_box_for_whitespace
import 'dart:async';
import 'dart:math';
import 'package:ani_watch/widgets/blur_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

//local imports
import '../widgets/glass_widget.dart';

//provider imports
import '../provider/anime.dart';

class WatchEpisodeUi extends StatefulWidget {
  final String animeId;
  final int index;
  final String tag;
  const WatchEpisodeUi(
      {super.key,
      required this.animeId,
      required this.index,
      required this.tag});

  @override
  State<WatchEpisodeUi> createState() => _WatchEpisodeUiState();
}

class _WatchEpisodeUiState extends State<WatchEpisodeUi> {
  late List<Episode> _episodeList;
  late Anime anime;
  late Timer timer;
  late Future<void> _future;

  int currIndex = 0; //current episode index
  int currPage = 1;
  int totalPages = 1;
  int totalEpisodes = 0;

  Map<String, String> _allQualities = {};
  String currQuality = "default";

  //new video player args
  late final player = Player();

  late final newController = VideoController(player);

  //initialize video player controller

  Future<void> initialize() async {
    final animeId = widget.animeId;

    anime = Provider.of<AnimeService>(context, listen: false)
        .getAnimeFromMemory(animeId);

    _episodeList = anime.details["episodeList"];

    totalEpisodes = _episodeList.length;

    totalPages = pagination(totalEpisodes);

    currIndex = widget.index;

    if (totalEpisodes != 0) {
      await _episodeList[currIndex].getLink();

      _allQualities = _episodeList[currIndex].details["link"];

      await player.open(Media(_allQualities[currQuality]!), play: false);
      await newController.waitUntilFirstFrameRendered;
      await player.seek(_episodeList[currIndex].details["lastSeekPosition"]);

      _episodeList[currIndex].setEpisodeLength(player.state.duration);

      saveSeekPosition();
    }

    return;
  }

  @override
  void initState() {
    super.initState();

    _future = initialize();
  }

  Future<void> selectEpisode(int index) async {
    try {
      timer.cancel();
      await player.pause();

      _episodeList[currIndex].setLastSeekPosition(player.state.position);

      await player.stop();

      setState(() {
        currIndex = index;
      });

      await _episodeList[currIndex].getLink();
      _allQualities = _episodeList[currIndex].details["link"];

      await player.open(
        Media(_allQualities[currQuality]!),
        play: false,
      );
      await player.stream.buffer.first;
      await player.seek(_episodeList[currIndex].details["lastSeekPosition"]);

      _episodeList[currIndex].setEpisodeLength(player.state.duration);

      saveSeekPosition();
    } catch (error) {
      return Future.error(error);
    }
  }

  //determine the number of pages for pagination of episodes
  int pagination(int number) {
    int pages = 1;
    if (number > 50) {
      pages = (number / 50).ceil();
    }

    return pages;
  }

  //A timer that saves the seek position every specified duration
  void saveSeekPosition() {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _episodeList[currIndex].setLastSeekPosition(player.state.position);
    });
  }

  //change Quality
  Future<void> changeQuality(String value) async {
    try {
      timer.cancel();

      setState(() {
        currQuality = value;
      });

      await player.open(Media(_allQualities[currQuality]!));
      await player.stream.buffer.first;
      await player.seek(_episodeList[currIndex].details["lastSeekPosition"]);

      saveSeekPosition();

      return;
    } catch (error) {
      return Future.error(error);
    }
  }

  List<DropdownMenuItem<Object>> dropDownPages() {
    List<DropdownMenuItem<Object>> result = [];
    for (int i = 1; i <= totalPages; i++) {
      result.add(DropdownMenuItem(
        value: i,
        child: Center(
          child: Text(
            "${(i - 1) * 50 + 1} - ${min(i * 50, totalEpisodes)}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ));
    }
    return result;
  }

  List<DropdownMenuItem<Object>> episodeQualities() {
    List<DropdownMenuItem<Object>> result = [];
    for (var item in _allQualities.keys) {
      result.add(DropdownMenuItem(
        value: item,
        child: Center(
          child: Text(
            item,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ));
    }
    return result;
  }

  @override
  void dispose() {
    super.dispose();
    try {
      timer.cancel();
      player.dispose();
    } catch (error) {
      //means the controllers were not initialized due to no episodes being available
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final devicePadding = MediaQuery.of(context).viewPadding;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final theme = Theme.of(context);

    final videoHeight =
        size.height < size.width ? size.height * 0.6 : size.height * 0.4;
    return LayoutBuilder(
      builder: (ctx, constraints) => Stack(
        children: [
          Hero(
            tag: widget.animeId + widget.tag,
            child: BlurImageBackground(
              image: anime.details["image"],
              isAsset: false,
            ),
          ),
          totalEpisodes == 0
              ? const Center(
                  child: Text(
                  "Episodes will be added soon",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: devicePadding.top,
                    ),
                    FutureBuilder(
                      
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Flexible(
                            flex: 4,
                            child: Container(
                              child: const Center(
                                  child: CupertinoActivityIndicator(
                                      color: Colors.white)),
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return Flexible(
                            flex: 4,
                            child: Container(
                                height: videoHeight,
                                width: size.width,
                                child: Text(
                                  snapshot.error.toString(),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          );
                        }

                        return Flexible(
                          flex: 5,
                          child: Container(
                              child: Video(
                            controller: newController,
                            controls: AdaptiveVideoControls,
                            fit: BoxFit.cover,
                          )),
                        );
                      },
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.05, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(anime.details["name"],
                              minFontSize: 10,
                              maxFontSize: 40,
                              maxLines: 1,
                              style: theme.textTheme.headlineSmall!
                                  .copyWith(color: Colors.white)),
                          AutoSizeText(
                            "EP ${currIndex + 1}:  ${_episodeList[currIndex].details["title"]!}",
                            minFontSize: 13,
                            maxFontSize: 26,
                            maxLines: 1,
                            style: theme.textTheme.headlineSmall!
                                .copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: GlassWidget(
                                height: 40,
                                width: 90,
                                color: Colors.blueGrey,
                                child: Center(
                                  child: Text(
                                    "${(currPage - 1) * 50 + 1} - ${min(currPage * 50, totalEpisodes)}",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return GlassContainer(
                                      height: 250,
                                      width: size.width,
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      blur: 10,
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(42)),
                                      child: CupertinoPicker(
                                          itemExtent: 50,
                                          magnification: 1.22,
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: currPage - 1),
                                          squeeze: 1.2,
                                          useMagnifier: true,
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              currPage = int.tryParse(
                                                      value.toString())! +
                                                  1;
                                            });
                                          },
                                          children: dropDownPages()),
                                    );
                                  },
                                );
                              }),
                          CupertinoButton(
                              child: Container(
                                height: 40,
                                width: 90,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(42))),
                                child: Center(
                                  child: Text(
                                    currQuality,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return GlassContainer(
                                      height: 250,
                                      width: size.width,
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      blur: 10,
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(42)),
                                      child: CupertinoPicker(
                                          itemExtent: 50,
                                          magnification: 1.22,
                                          squeeze: 1.2,
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: _allQualities
                                                      .keys
                                                      .toList()
                                                      .indexOf(currQuality)),
                                          useMagnifier: true,
                                          onSelectedItemChanged: (value) {
                                            _future = changeQuality(
                                                _allQualities.keys
                                                    .elementAt(value));
                                          },
                                          children: episodeQualities()),
                                    );
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 6,
                        child: GridView.builder(
                          addAutomaticKeepAlives: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      findAxisExtent(constraints, 500),
                                  mainAxisExtent: 180),
                          physics: const BouncingScrollPhysics(),
                          padding:
                              EdgeInsets.only(top: 0, bottom: bottomPadding),
                          itemCount: min(
                              50,
                              min(totalEpisodes - (currPage - 1) * 50,
                                  totalEpisodes)),
                          itemBuilder: (context, index) {
                            index += (currPage - 1) * 50;
                            final episode = _episodeList[index].details;
                            return ZoomTapAnimation(
                              enableLongTapRepeatEvent: false,
                              longTapRepeatDuration:
                                  const Duration(milliseconds: 100),
                              begin: 1.0,
                              end: 0.93,
                              beginDuration: const Duration(milliseconds: 20),
                              endDuration: const Duration(milliseconds: 120),
                              beginCurve: Curves.decelerate,
                              endCurve: Curves.fastOutSlowIn,
                              child: GestureDetector(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                      horizontal: size.width * 0.05),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            height: 90,
                                            width: 160,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  height: 90,
                                                  width: 160,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: ShapeDecoration(
                                                      shadows: const [
                                                        BoxShadow(
                                                          offset:
                                                              Offset(14, 18),
                                                          spreadRadius: -20,
                                                          blurRadius: 38,
                                                          color: Color.fromRGBO(
                                                              0, 0, 0, 1),
                                                        )
                                                      ],
                                                      shape: SmoothRectangleBorder(
                                                          borderRadius:
                                                              SmoothBorderRadius(
                                                                  cornerRadius:
                                                                      16,
                                                                  cornerSmoothing:
                                                                      1))),
                                                  child: Image.network(
                                                    episode["image"]!,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (context,
                                                        child,
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return const Center(
                                                        child:
                                                            CupertinoActivityIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .greenAccent
                                                            .shade400,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(24)),
                                                    width: episode["length"] ==
                                                            Duration.zero
                                                        ? 0
                                                        : episode["lastSeekPosition"]
                                                                .inSeconds /
                                                            episode["length"]
                                                                .inSeconds *
                                                            170,
                                                    height: 4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                              child: Text(
                                            "${index + 1}.  ${episode["title"]!}",
                                            style: theme.textTheme.bodyLarge!
                                                .copyWith(color: Colors.white),
                                            overflow: TextOverflow.clip,
                                          )),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        episode["description"]!,
                                        maxFontSize: 20,
                                        minFontSize: 11,
                                        style: TextStyle(color: Colors.white),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  _future = selectEpisode(index);
                                  Provider.of<AnimeService>(context,
                                          listen: false)
                                      .addToCurrWatchList(
                                          anime.details["id"], index);
                                },
                              ),
                            );
                          },
                        )),
                  ],
                ),
        ],
      ),
    );
  }

  int findAxisExtent(constraints, double minItemWidth) {
    final screenWidth = constraints.maxWidth;
    final crossAxisCount = (screenWidth / minItemWidth).floor();
    return crossAxisCount > 1 ? crossAxisCount : 1;
  }
}
