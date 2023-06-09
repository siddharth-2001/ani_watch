import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:duration/duration.dart';
import './auth.dart';

String backendUrl = "aniwatch-backend.vercel.app";

class Anime with ChangeNotifier {
  String _id = "";
  String _name = "";
  String _cover = "";
  String _releaseDate = "";
  String _episodes = "";
  String _description = "";
  String _rating = "";
  String _status = "";
  String _image = "";
  final List<String> _genres = [];
  final List<Episode> _episodeList = [];
  final List<Anime> _recommendations = [];

  Anime(
      {required String id,
      required String name,
      required String image,
      required String episodes,
      required String rating}) {
    _id = id;
    _name = name;
    _image = image;
    _episodes = episodes;
    _rating = rating;
  }

  Map<String, dynamic> get details {
    return {
      "id": _id,
      "name": _name,
      "cover": _cover,
      "image": _image,
      "episodes": _episodes,
      "description": _description,
      "releaseDate": _releaseDate,
      "episodeList": _episodeList,
      "rating": _rating,
      "genres": _genres,
      "status": _status,
      "recommendations": _recommendations,
    };
  }
}

class Episode {
  late UserService _user;
  String _id = "";
  String _title = "";
  String _image = "";
  String _description = "";
  String _episodeNumber = "";
  String _download = "";
  Duration _lastSeekPosition = Duration.zero;
  Duration _length = Duration.zero;

  // ignore: prefer_final_fields
  Map<String, String> _link = {};

  Episode({
    required String id,
    required String episodeNumber,
    required String description,
    required String title,
    required String image,
    required UserService user,
  }) {
    _id = id;
    _episodeNumber = episodeNumber;
    _title = title;
    _description = description;
    _image = image;
    _user = user;
  }

  Map<String, dynamic> get details {
    return {
      "id": _id,
      "number": _episodeNumber,
      "link": _link,
      "title": _title,
      "image": _image,
      "description": _description,
      "lastSeekPosition": _lastSeekPosition,
      "length": _length
    };
  }

  Future<void> setEpisodeLength(Duration length) async {
    _length = length;

    Map tempMap;

    try {
      tempMap = _user.userWatchData["episodeData"];
    } catch (error) {
      log('${error}line 105');
      tempMap = {};
    }

    if (!tempMap.containsKey(_id)) tempMap[_id] = {};

    tempMap[_id]["length"] = _length.toString();

    _user.userWatchData["episodeData"] = tempMap;

    _user.updateUserWatchData();
  }

  //recieve the last known seek position to save progress
  Future<void> setLastSeekPosition(Duration position) async {
    _lastSeekPosition = position;

    Map tempMap;

    try {
      tempMap = _user.userWatchData["episodeData"];
    } catch (error) {
      log('${error}127');
      tempMap = {};
    }

    if (!tempMap.containsKey(_id)) tempMap[_id] = {};

    tempMap[_id]["lastSeekPosition"] = _lastSeekPosition.toString();

    _user.userWatchData["episodeData"] = tempMap;

    _user.updateUserWatchData();
  }

  Future<void> getLink() async {
    final url = Uri.https(backendUrl, '/meta/anilist/watch/$_id');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      //Go through the sources and add links for all available quality of episode
      final sources = body["sources"] as List<dynamic>;
      for (var element in sources) {
        _link[element["quality"]] = element["url"];
      }

      //set the download link for the episode
      _download = body["download"];
    }
  }
}

class AnimeService with ChangeNotifier {
  final Map<String, Anime> _animeData = {};

  final List<Anime> _recommendedList = [],
      _searchList = [],
      _favouriteList = [];

  final List<Map<Anime, int>> _currWatchList = [];

  UserService _user = UserService();

  void setUser(UserService user) {
    _user = user;
    notifyListeners();
  }

  int checkIndex = 0;

  List<Map<Anime, int>> get currWatchList {
    return _currWatchList;
  }

  Future<void> fetchRecommendations() async {
    Map tempMap;
    //try to fetch data if not available create it
    try {
      tempMap = _user.userWatchData["recommendedData"];
    } catch (error) {
      tempMap = {};
    }

    _recommendedList.clear();

    for (var element in tempMap.keys) {
      try {
        //if any recommendation fails to be fetched skip it and go to the next one.
        await getAnimeById(element);

        final tempAnime = _animeData[element]!;

        _recommendedList.add(tempAnime);
      } catch (error) {
        return Future.error(error);
      }

      notifyListeners();
    }
  }

  List<Anime> get recommendedList {
    return _recommendedList.reversed.toList();
  }

  //add anime to recommendations
  Future<void> addToRecommendations(String id) async {
    Map tempMap;

    try {
      tempMap = _user.userWatchData["recommendedData"];
    } catch (error) {
      log('${error}line 213');
      tempMap = {};
    }

    final Anime tempAnime = _animeData[id]!;

    if (tempMap.length > 7) {
      for (int i = 0; i < 3; i++) {
        tempMap.remove(tempMap.keys.first);
      }
    }

    for (var element in tempAnime._recommendations.sublist(0, 3)) {
      tempMap[element._id] = element._id;
    }

    _user.userWatchData["recommendedData"] = tempMap;

    _user.updateUserWatchData();

    fetchRecommendations();
  }

  //get anime that the user is currently watchng
  Future<void> fetchCurrentlyWatching() async {
    _currWatchList.clear();

    Map temp;

    try {
      temp = _user.userWatchData["currWatchData"];
    } catch (error) {
      log(error.toString() + '245');
      temp = {};
    }

    for (var element in temp.keys) {
      try {
        await getAnimeById(element);

        final tempAnime = _animeData[element]!;
        _currWatchList.add({tempAnime: temp[element]});
      } catch (error) {
        return Future.error(error);
      }
    }

    notifyListeners();
  }

  //add to currently watching
  Future<void> addToCurrWatchList(String id, int epIndex) async {
    Map temp;

    try {
      temp = _user.userWatchData["currWatchData"];
    } catch (error) {
      log('${error}line 265');
      temp = {};
    }

    if (temp.length > 4) temp.remove(temp.keys.elementAt(0));

    //to make sure that the newly added anime stays at the front
    if (temp.containsKey(id)) temp.remove(id);

    temp[id] = epIndex;

    _user.userWatchData["currWatchData"] = temp;
    _user.updateUserWatchData();

    await fetchCurrentlyWatching();
  }

  bool isFavourite(String id) {
    Map temp = {};
    try {
      temp = _user.userWatchData["favouritesData"];
    } catch (error) {
      temp = {};
    }

    return temp.containsKey(id) ? true : false;
  }

  Future<void> addToFavourite(String id) async {
    //Also deletes an item if it is already added
    Map temp = {};
    try {
      temp = _user.userWatchData["favouritesData"];
    } catch (error) {
      temp = {};
    }

    if (temp.containsKey(id)) {
      temp.remove(id);
    } else {
      temp[id] = id;
    }
    _favouriteList.clear();
    _user.userWatchData["favouritesData"] = temp;
    try {
      await fetchFavourites();
    } catch (error) {
      return Future.error(error);
    }
    _user.updateUserWatchData();
    notifyListeners();
  }

  Future<void> fetchFavourites() async {
    Map temp = {};

    try {
      temp = _user.userWatchData["favouritesData"];
    } catch (error) {
      temp = {};
    }

    for (var id in temp.keys) {
      try {
        await getAnimeById(id);

        _favouriteList.add(getAnimeFromMemory(id));
      } catch (error) {
        return Future.error(error);
      }
    }
  }

  List<Anime> get favouriteList {
    return _favouriteList;
  }

  List<Anime> get getSearchList {
    return _searchList;
  }

  void clearSearchList() {
    _searchList.clear();
    notifyListeners();
  }

  Anime getAnimeFromMemory(String id) {
    return _animeData[id]!;
  }

  Future<void> searchAnime(String query) async {
    try {
      final url = Uri.https(backendUrl, '/meta/anilist/$query');

      final response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          _searchList.clear();
          final body = jsonDecode(response.body)! as Map<String, dynamic>;
          List<dynamic> list = body["results"] as List<dynamic>;
          for (var element in list) {
            Anime temp = Anime(
                id: element["id"],
                name: selectAppropriateName(element["title"]),
                image: element["image"],
                rating: element["rating"].toString(),
                episodes: element["totalEpisodes"].toString());

            temp._description =
                Bidi.stripHtmlIfNeeded(element["description"].toString());
            temp._releaseDate = element["releaseDate"].toString();
            List genreList = element["genres"] as List<dynamic>;

            for (var genre in genreList) {
              temp._genres.add(genre);
            }

            _searchList.add(temp);
          }

          notifyListeners();
          return;

        default:
          return Future.error(response.statusCode);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<void> getAnimeById(String id) async {
    if (_animeData.containsKey(id)) return;

    final url = Uri.https(backendUrl, "/meta/anilist/info/$id");

    try {
      var response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          final body = jsonDecode(response.body) as Map<String, dynamic>;

          Anime temp = Anime(
              id: body["id"],
              name: selectAppropriateName(body["title"]),
              image: body["image"].toString(),
              rating: body["rating"].toString(),
              episodes: body["totalEpisodes"].toString());

          if (body["rating"] == null) {
            temp._rating = "null";
          }

          if (body["releaseDate"] == null) {
            temp._releaseDate = "TBA";
          } else {
            temp._releaseDate = body["releaseDate"].toString();
          }

          if (body["totalEpisodes"] == null) {
            temp._episodes = "TBA";
          } else {
            temp._episodes = body["totalEpisodes"].toString();
          }

          //add cover anime
          if (body["cover"] == "") {
            temp._cover = temp._image;
          } else {
            temp._cover = body["cover"];
          }

          //adding status of anime
          temp._status = body["status"];

          //adding the summary of anime
          final details =
              Bidi.stripHtmlIfNeeded(body["description"].toString());
          temp._description = details;

          //recieve episode list, create episode object and add it to anime
          List episodeList = body["episodes"] as List<dynamic>;

          episodeList = episodeList.reversed.toList();

          Map tempMap;

          // if the episode data does not exist we continue with an empty map
          try {
            tempMap = _user.userWatchData["episodeData"];
          } catch (error) {
            tempMap = {};
          }

          for (var element in episodeList) {
            Episode tempEpisode = Episode(
                user: _user,
                id: element["id"],
                episodeNumber: element["number"].toString(),
                image: element["image"].toString(),
                description: element["description"].toString(),
                title: element["title"].toString());

            //if the episode is already watched before set the last seek position
            if (tempMap.containsKey(tempEpisode._id)) {
              if (tempMap[tempEpisode._id].containsKey("lastSeekPosition")) {
                tempEpisode._lastSeekPosition =
                    parseTime(tempMap[tempEpisode._id]["lastSeekPosition"]);
              }

              if (tempMap[tempEpisode._id].containsKey("length")) {
                tempEpisode._length =
                    parseTime(tempMap[tempEpisode._id]["length"]);
              }
            }

            if (tempEpisode._title == "null") {
              tempEpisode._title = "Title Not Available";
            }

            if (tempEpisode._description == "null") {
              tempEpisode._description = "Description Not Available";
            }

            temp._episodeList.add(tempEpisode);
          }

          //recieve the genres as a list and assign to the anime created
          List genreList = body["genres"] as List<dynamic>;

          for (var element in genreList) {
            temp._genres.add(element);
          }

          //adding all the recommended anime recieved from the server
          List recommendedList = body["recommendations"] as List<dynamic>;

          for (var element in recommendedList) {
            Anime recAnime = Anime(
                id: element["id"].toString(),
                name: selectAppropriateName(element["title"]),
                image: element["image"].toString(),
                episodes: element["episodes"].toString(),
                rating: element["rating"].toString());

            temp._recommendations.add(recAnime);
          }

          //saving the created anime in a local map for future reference
          _animeData[id] = temp;
          notifyListeners();
          break;

        default:
          return Future.error(response.body);
      }
    } catch (error) {
      return Future.error(error);
    }
  }
}

class TrendingAnime with ChangeNotifier {
  final List<Anime> _trendingList = [];

  Future<void> fetchTrendingAnime() async {
    //to catch any errors unrelated to the api request(basically errors happening with a status code of 200)
    try {
      var url = Uri.https(backendUrl, '/meta/anilist/trending');
      var response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          _trendingList.clear();
          final body = jsonDecode(response.body)! as Map<String, dynamic>;
          List<dynamic> list = body["results"] as List<dynamic>;
          for (var element in list) {
            Anime temp = Anime(
                id: element["id"],
                rating: element["rating"].toString(),
                name: selectAppropriateName(element["title"]),
                image: element["image"],
                episodes: element["totalEpisodes"].toString());
            _trendingList.add(temp);
          }

          notifyListeners();

          return;

        default:
          return Future.error(response.statusCode);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  List<Anime> get trendingList {
    return _trendingList;
  }
}

class PopularAnime with ChangeNotifier {
  final List<Anime> _popularList = [];

  Future<void> getPopularAnime() async {
    try {
      var url = Uri.https(backendUrl, '/meta/anilist/popular');
      var response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          _popularList.clear();
          final body = jsonDecode(response.body)! as Map<String, dynamic>;
          List<dynamic> list = body["results"] as List<dynamic>;
          for (var element in list) {
            Anime temp = Anime(
                id: element["id"],
                rating: element["rating"].toString(),
                name: selectAppropriateName(element["title"]),
                image: element["image"],
                episodes: element["totalEpisodes"].toString());
            _popularList.add(temp);
          }

          notifyListeners();

          return;

        default:
          return Future.error(response.statusCode);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  List<Anime> get popularList {
    return _popularList;
  }
}

class RecentEpisodes with ChangeNotifier {
  final List<Anime> _recentList = [];

  Future<void> getRecentEpisodes() async {
    try {
      var url = Uri.https(backendUrl, '/meta/anilist/recent-episodes');
      var response = await http.get(url);

      switch (response.statusCode) {
        case 200:
          _recentList.clear();
          final body = jsonDecode(response.body)! as Map<String, dynamic>;
          List<dynamic> list = body["results"] as List<dynamic>;
          for (var element in list) {
            Anime temp = Anime(
                id: element["id"],
                rating: element["rating"].toString(),
                name: selectAppropriateName(element["title"]),
                image: element["image"],
                episodes: element["episodeNumber"].toString());

            _recentList.add(temp);
          }

          notifyListeners();
          return;

        default:
          return Future.error(response.statusCode);
      }
    } catch (error) {
      return Future.error(error);
    }
  }

  List<Anime> get recentList {
    return _recentList;
  }
}

String selectAppropriateName(Map names) {
  String result = "";

  try {
    if (names.containsKey("english") && names["english"] != null) {
      result = names["english"];
    } else if (names.containsKey("userPreferred") &&
        names["userreferred"] != null) {
      result = names["userreferred"];
    } else {
      result = names["romaji"];
    }
  } catch (error) {
    log("Error while selecting appropriate name.");
  }

  return result;
}
