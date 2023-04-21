// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'dart:math';
import 'package:ani_watch/widgets/blur_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:provider/provider.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

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
  late Chewie playerWidget;
  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;
  late List<Episode> _episodeList;
  late Anime anime;
  late Timer timer;

  int currIndex = 0; //current episode index
  int currPage = 1;
  int totalPages = 1;
  int totalEpisodes = 0;
  Map<String, String> _allQualities = {};
  String currQuality = "default";

  bool _isLoading = true;

  //initialize video player controller
  Future<void> video() async {
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      allowFullScreen: true,
      fullScreenByDefault: true,
      showControls: true,
      zoomAndPan: true,
      customControls: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: CupertinoControls(
            backgroundColor: Colors.black.withOpacity(0.15),
            iconColor: Colors.white,
            showPlayButton: true),
      ),
      videoPlayerController: _videoPlayerController,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
      maxScale: 2,
      showControlsOnInitialize: true,
      looping: false,
    );

    playerWidget = Chewie(
      controller: _chewieController,
    );
  }

  @override
  void initState() {
    super.initState();
    final animeId = widget.animeId;

    anime = Provider.of<AllAnime>(context, listen: false)
        .getAnimeFromMemory(animeId);
    _episodeList = anime.details["episodeList"];

    totalEpisodes = _episodeList.length;

    totalPages = pagination(totalEpisodes);
    currIndex = widget.index;

    if (totalEpisodes != 0) {
      _episodeList[currIndex].getLink().then((value) {
        _allQualities = _episodeList[currIndex].details["link"];
        currQuality = _allQualities.keys.elementAt(0);
        _videoPlayerController =
            VideoPlayerController.network(_allQualities[currQuality]!);
        video().then((value) {
          _episodeList[currIndex]
              .setEpisodeLength(_videoPlayerController.value.duration);

          if (context.mounted) {
            setState(() {
              _videoPlayerController
                  .seekTo(_episodeList[currIndex].details["lastSeekPosition"]);
              saveSeekPosition();
              _isLoading = false;
            });
          }
        });
      });
    }
  }

  Future<void> selectEpisode(int index) async {
    await _videoPlayerController.position.then(
      (value) => _episodeList[currIndex].setLastSeekPosition(value!),
    );

    setState(() {
      _isLoading = true;
      currIndex = index;
      timer.cancel();
    });

    _videoPlayerController.dispose();
    _episodeList[currIndex].getLink().then((value) {
      _allQualities = _episodeList[currIndex].details["link"];
      _videoPlayerController =
          VideoPlayerController.network(_allQualities[currQuality]!);
      video().then((value) {
        setState(() {
          _episodeList[currIndex]
              .setEpisodeLength(_videoPlayerController.value.duration);
          _videoPlayerController
              .seekTo(_episodeList[currIndex].details["lastSeekPosition"]);
          saveSeekPosition();
          _isLoading = false;
        });
      });
    });
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
      _videoPlayerController.position
          .then((value) => _episodeList[currIndex].setLastSeekPosition(value!));
    });
  }

  //change
  void changeQuality(String value) {
    if (context.mounted) {
      setState(() {
        _isLoading = true;
        currQuality = value;
        timer.cancel();
      });
    }

    _videoPlayerController.dispose();

    _videoPlayerController =
        VideoPlayerController.network(_allQualities[currQuality]!);
    video().then((value) {
      setState(() {
        _videoPlayerController
            .seekTo(_episodeList[currIndex].details["lastSeekPosition"]);
        saveSeekPosition();
        _isLoading = false;
      });
    });
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
      _videoPlayerController.dispose();
      _chewieController.dispose();
    } catch (error) {
      //means the controllers were not initialized due to no episodes being available
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final devicePadding = MediaQuery.of(context).viewPadding;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Stack(
      children: [
        Hero(
          tag: widget.animeId + widget.tag,
          child: BlurImageBackground(image: anime.details["image"]),
        ),
        totalEpisodes == 0
            ? const Center(
                child: Text(
                "Episodes will be added soon",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: devicePadding.top,
                  ),
                  _isLoading
                      ? Container(
                          height: 250,
                          width: size.width,
                          child: const CupertinoActivityIndicator(
                            color: Colors.white,
                          ))
                      : Container(
                          height: 250, width: size.width, child: playerWidget),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.details["name"],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 11),
                        ),
                        Text(
                          "EP ${currIndex + 1}:  ${_episodeList[currIndex].details["title"]!}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CupertinoButton(
                            padding: EdgeInsets.zero,
                            child: GlassWidget(
                              height: 30,
                              width: 80,
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
                              height: 30,
                              width: 80,
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
                                                initialItem: _allQualities.keys
                                                    .toList()
                                                    .indexOf(currQuality)),
                                        useMagnifier: true,
                                        onSelectedItemChanged: (value) {
                                          changeQuality(_allQualities.keys
                                              .elementAt(value));
                                        },
                                        children: episodeQualities()),
                                  );
                                },
                              );
                            }),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            CupertinoIcons.arrow_down_circle,
                            color: Colors.white,
                          ),
                          padding: EdgeInsets.zero,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Flexible(
                      child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 0, bottom: bottomPadding),
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
                                vertical: 15, horizontal: size.width * 0.05),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: 90,
                                          width: 130,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  offset: Offset(14, 18),
                                                  spreadRadius: -20,
                                                  blurRadius: 38,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 1),
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      1 / 6.4 * 130)),
                                          child: Image.network(
                                            episode["image"]!,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
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
                                                color:
                                                    Colors.greenAccent.shade400,
                                                borderRadius:
                                                    BorderRadius.circular(24)),
                                            width: episode["length"] ==
                                                    Duration.zero
                                                ? 0
                                                : episode["lastSeekPosition"]
                                                        .inSeconds /
                                                    episode["length"]
                                                        .inSeconds *
                                                    130,
                                            height: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                        child: Text(
                                      "${index + 1}.  ${episode["title"]!}",
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10),
                                      overflow: TextOverflow.clip,
                                    )),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  episode["description"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            selectEpisode(index);
                            Provider.of<AllAnime>(context, listen: false)
                                .addToCurrWatchList(anime.details["id"], index);
                          },
                        ),
                      );
                    },
                  )),
                ],
              ),
      ],
    );
  }
}
