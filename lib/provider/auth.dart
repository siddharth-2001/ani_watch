import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  String _id = "";
  String _idToken = "";
  String _refreshToken = "";
  String _expiresIn = "";
  Map userWatchData = {};

  String get idToken {
    return _idToken;
  }

  final String apiKey = "AIzaSyAXdGqGluuprQiUMc93ZWXPqQna1kNmAnY";

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      _refreshToken = prefs.getString("refreshToken")!;
    } catch (error) {
      return false;
    }

    final url =
        Uri.parse("https://securetoken.googleapis.com/v1/token?key=$apiKey");

    final response = await http.post(url,
        body: jsonEncode(
            {"grant_type": "refresh_token", "refresh_token": _refreshToken}));

    final body = jsonDecode(response.body);

    _id = body["user_id"];
    _idToken = body["id_token"];
    _refreshToken = body["refresh_token"];
    _expiresIn = body["expires_in"].toString();

    await fetchUserWatchData();

    return true;
  }

  Future<void> register(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey");

    final response = await http.post(url,
        body: jsonEncode(
            {"email": email, "password": password, "returnSecureToken": true}));

    final body = jsonDecode(response.body);

    _id = body["localId"];
    _idToken = body["idToken"];
    _refreshToken = body["refreshToken"];
    _expiresIn = body["expiresIn"].toString();

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("refreshToken", _refreshToken);
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey");

    try {
      final response = await http.post(url,
          body: jsonEncode({
            "email": email,
            "password": password,
            "returnSecureToken": true
          }));

      final body = jsonDecode(response.body);

      _id = body["localId"];
      _idToken = body["idToken"];
      _refreshToken = body["refreshToken"];
      _expiresIn = body["expiresIn"].toString();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("refreshToken", _refreshToken);

      await fetchUserWatchData();

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<void> updateUserWatchData() async {
    final prefs = await SharedPreferences.getInstance();

    // try {
    //   final oldData = prefs.getString("userWatchData");
    // } catch (error) {
    //   final oldData = {};
    // }

    await prefs.setString("userWatchData", jsonEncode(userWatchData));

    

    final url = Uri.parse(
        "https://aniwatch-ca64e-default-rtdb.asia-southeast1.firebasedatabase.app/$_id/watch_data.json");
    await http.put(url, body: jsonEncode(userWatchData));
  }

  Future<void> fetchUserWatchData() async {
    try {
      final url = Uri.parse(
          "https://aniwatch-ca64e-default-rtdb.asia-southeast1.firebasedatabase.app/$_id/watch_data.json");

      try {
        final response = await http.get(url);
        final body = jsonDecode(response.body);
        userWatchData = body;
        notifyListeners();
      } catch (error) {
        log("error occured at line 117");
        log(error.toString());
      }
    } catch (error) {
      try {
        final prefs = await SharedPreferences.getInstance();
        userWatchData = jsonDecode(prefs.getString("userWatchData")!);
        notifyListeners();
        return;
      } catch (error) {
        //try to fetch data from disk if none available fetch it from firebase
      }
    }
  }

  Future<void> logout() async {
    _id = "";
    _idToken = "";
    _refreshToken = "";
    _expiresIn = "";
    userWatchData = {};

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
