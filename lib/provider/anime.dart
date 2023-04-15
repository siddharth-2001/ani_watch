import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:duration/duration.dart';

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
  List<String> _genres = [];
  List<Episode> _episodeList = [];
  List<Anime> _recommendations = [];

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
  String _id = "";
  String _title = "";
  String _image = "";
  String _description = "";
  String _episodeNumber = "";
  String _download = "";
  Duration _lastSeekPosition = Duration.zero;
  bool _watched = false;

  // ignore: prefer_final_fields
  Map<String, String> _link = {};

  Episode(
      {required String id,
      required String episodeNumber,
      required String description,
      required String title,
      required String image}) {
    _id = id;
    _episodeNumber = episodeNumber;
    _title = title;
    _description = description;
    _image = image;
  }

  Map<String, dynamic> get details {
    return {
      "id": _id,
      "number": _episodeNumber,
      "link": _link,
      "title": _title,
      "image": _image,
      "description": _description,
      "watched": _watched,
      "lastSeekPosition": _lastSeekPosition,
    };
  }

  Future<void> setLastSeekPosition(Duration position) async {
    _lastSeekPosition = position;
    final LocalStorage storage = LocalStorage("episode_data");
    await storage.ready;
    Map temp;

    try {
      temp = storage.getItem("episodeMap");
    } on Exception {
      temp = {};
    } catch (error) {
      temp = {};
    }
    temp[_id] = _lastSeekPosition.toString();
    storage.setItem("episode_data", temp);
  }

  Future<void> getLink() async {
    final url = Uri.https('api.consumet.org', '/meta/anilist/watch/$_id');

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

class AllAnime with ChangeNotifier {
  Map<String, Anime> animeData = {};
  List<Anime> _searchList = [];
  Map<String, dynamic> _favMap =
      {}; //This set saves anime id string since anime objects cant be used with local storage
  Future<void> fetchLocalFavData() async {
    final LocalStorage storage = LocalStorage('favourite_anime');
    await storage.ready;

    try {
      _favMap = storage.getItem("favMap");
    } on Exception {
      _favMap = {};
    } catch (error) {
      _favMap = {};
    }
  }

  bool isFavourite(String id) {
    return _favMap.containsKey(id) ? true : false;
  }

  Future<void> addToFavourite(String id) async {
    //Also deletes an item if it is already added
    final LocalStorage storage = LocalStorage('favourite_anime');
    await storage.ready;

    if (_favMap.containsKey(id)) {
      _favMap.remove(id);
    } else {
      _favMap[id] = id;
    }
    storage.setItem("favMap", _favMap);
    notifyListeners();
  }

  Future<List<Anime>> getFavourites() async {
    List<Anime> result = [];

    if (_favMap.isEmpty) return result;

    for (var id in _favMap.keys) {
      await getAnimeById(id);

      result.add(getAnimeFromMemory(id));
    }

    return result;
  }

  List<Anime> get getSearchList {
    return _searchList;
  }

  Anime getAnimeFromMemory(String id) {
    return animeData[id]!;
  }

  Future<void> searchAnime(String query) async {
    final url = Uri.https('api.consumet.org', '/meta/anilist/$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      _searchList.clear();
      final body = jsonDecode(response.body)! as Map<String, dynamic>;
      List<dynamic> list = body["results"] as List<dynamic>;
      for (var element in list) {
        Anime temp = Anime(
            id: element["id"],
            name: element["title"]["userPreferred"],
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
        animeData[temp._id] = temp;
      }

      notifyListeners();
    }
  }

  Future<void> getAnimeById(String id) async {
    final url = Uri.https("api.consumet.org", "/meta/anilist/info/$id");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;

      Anime temp = Anime(
          id: body["id"],
          name: body["title"]["romaji"],
          image: body["image"],
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
      temp._cover = body["cover"];

      //adding status of anime
      temp._status = body["status"];

      //adding the summary of anime
      final details = Bidi.stripHtmlIfNeeded(body["description"].toString());
      temp._description = details;

      //recieve episode list, create episode object and add it to anime
      final episodeList = body["episodes"] as List<dynamic>;

      final storage = LocalStorage("episode_data");

      await storage.ready;

      Map<String, dynamic> episodeMap = {};

      // if the episode data does not exist we continue with an empty map
      try {
        episodeMap = storage.getItem("episodeMap");
      } catch (error) {
        episodeMap = {};
      }

      for (var element in episodeList) {
        Episode tempEpisode = Episode(
            id: element["id"],
            episodeNumber: element["number"].toString(),
            image: element["image"],
            description: element["description"].toString(),
            title: element["title"].toString());

        //if the episode is already watched before set the last seek position
        if (episodeMap.containsKey(tempEpisode._id)) {
          tempEpisode._lastSeekPosition =
              parseTime(episodeMap[tempEpisode._id]);
        }

        if (tempEpisode._title == "null") {
          tempEpisode._title = "Title Not Available";
        }

        if (tempEpisode._description == "null") {
          tempEpisode._description = "Description Not Available";
        }

        temp._episodeList.add(tempEpisode);
      }

      await storage.setItem("episodeMap", episodeMap);

      storage.dispose();

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
            name: element["title"]["romaji"],
            image: element["image"],
            episodes: element["episodes"].toString(),
            rating: element["rating"].toString());

        temp._recommendations.add(recAnime);
        animeData[recAnime._id] = recAnime;
      }

      //saving the created anime in a local map for future reference
      animeData[id] = temp;
      notifyListeners();
    } else {
      print(response.body);
    }
  }
}

class TrendingAnime with ChangeNotifier {
  late List<Anime> _trendingList = [];

  Future<void> getTrendingAnime() async {
    var url = Uri.https('api.consumet.org', '/meta/anilist/trending');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      _trendingList.clear();
      final body = jsonDecode(response.body)! as Map<String, dynamic>;
      List<dynamic> list = body["results"] as List<dynamic>;
      for (var element in list) {
        Anime temp = Anime(
            id: element["id"],
            rating: element["rating"].toString(),
            name: element["title"]["english"],
            image: element["image"],
            episodes: element["totalEpisodes"].toString());
        _trendingList.add(temp);
      }

      notifyListeners();
    } else {
      print("error occured");
    }
  }

  List<Anime> get trendingList {
    return _trendingList;
  }
}

class PopularAnime with ChangeNotifier {
  final List<Anime> _popularList = [];

  Future<void> getPopularAnime() async {
    var url = Uri.https('api.consumet.org', '/meta/anilist/popular');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      _popularList.clear();
      final body = jsonDecode(response.body)! as Map<String, dynamic>;
      List<dynamic> list = body["results"] as List<dynamic>;
      for (var element in list) {
        Anime temp = Anime(
            id: element["id"],
            rating: element["rating"].toString(),
            name: element["title"]["english"],
            image: element["image"],
            episodes: element["totalEpisodes"].toString());
        _popularList.add(temp);
      }

      notifyListeners();
    } else {
      print("error occured");
    }

    // print(_popularList);
  }

  List<Anime> get popularList {
    return _popularList;
  }
}

class RecentEpisodes with ChangeNotifier {
  final List<Anime> _recentList = [];

  Future<void> getRecentEpisodes() async {
    var url = Uri.https('api.consumet.org', '/meta/anilist/recent-episodes');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      _recentList.clear();
      final body = jsonDecode(response.body)! as Map<String, dynamic>;
      List<dynamic> list = body["results"] as List<dynamic>;
      for (var element in list) {
        Anime temp = Anime(
            id: element["id"],
            rating: element["rating"].toString(),
            name: element["title"]["userPreferred"],
            image: element["image"],
            episodes: element["episodeNumber"].toString());

        _recentList.add(temp);
      }

      notifyListeners();
    } else {
      print("error occured");
    }

    // print(_popularList);
  }

  List<Anime> get recentList {
    return _recentList;
  }
}