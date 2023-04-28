// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:ani_watch/provider/anime.dart';
import 'package:ani_watch/screens/home_screen.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

//local imports

//provider imports
import '../provider/auth.dart';

enum AuthMode { login, register }

class AuthUi extends StatefulWidget {
  const AuthUi({super.key});

  @override
  State<AuthUi> createState() => _AuthUiState();
}

class _AuthUiState extends State<AuthUi> {
  final Map _authData = {};
  bool _isLoading = true;
  AuthMode _authMode = AuthMode.login;
  String _errorMessage = "";
  String _currPassword = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //error container
  Widget errorPopup(String message) {
    return CupertinoAlertDialog(
      title: Text(message),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _isLoading = false;
            });
          },
          child: const Text("Close"),
        )
      ],
    );
  }

  //method to save the form
  Future<void> saveForm(ctx) async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_authMode == AuthMode.login) {
        Provider.of<UserService>(ctx, listen: false)
            .login(_authData["email"], _authData["password"])
            .then((value) {
          if (value) {
            loadUserData()
                .then((value) => Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName))
                .timeout(
              Duration(seconds: 3),
              onTimeout: () {
                log("time up");
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              },
            );
          } else {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return errorPopup(
                    "An error occurred while logging in. Please check your details and try again.");
              },
            );
          }
        });
      } else {
        Provider.of<UserService>(ctx, listen: false)
            .register(_authData["email"], _authData["password"])
            .then((value) => loadUserData().then((value) =>
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName)));
      }
    } else {
      showCupertinoDialog(
        context: context,
        builder: (context) => errorPopup(_errorMessage),
      );
    }
  }

  //load user data so that they dont see the loading spinners after
  Future<void> loadUserData() async {
    await Provider.of<AnimeService>(context, listen: false)
        .fetchRecommendations();
    await Provider.of<TrendingAnime>(context, listen: false).getTrendingAnime();
    await Provider.of<PopularAnime>(context, listen: false).getPopularAnime();
    await Provider.of<AnimeService>(context, listen: false)
        .fetchCurrentlyWatching();
  }

  @override
  void initState() {
    super.initState();
    //try to use data on disk to auto login the user
    Provider.of<UserService>(context, listen: false).autoLogin().then((value) {
      if (value) {
        loadUserData().then((value) =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName)).timeout(
              Duration(seconds: 3),
              onTimeout: () {
                log("time up");
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreen.routeName);
              },
            );
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.width * 0.8,
      width: size.width * 0.8,
      child: _isLoading
          ? const CupertinoActivityIndicator(
              color: Colors.white,
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_authMode == AuthMode.login ? "Login" : "Register",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width,
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 10, cornerSmoothing: 1))),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "email"),
                      onSaved: (value) {
                        _authData["email"] = value;
                      },
                      validator: (value) {
                        if (!value!.contains("@") || !value.contains(".com")) {
                          _errorMessage = "- Please enter a valid email.";
                          return "email error";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: size.width,
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: SmoothRectangleBorder(
                            borderRadius: SmoothBorderRadius(
                                cornerRadius: 10, cornerSmoothing: 1))),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "password"),
                      onSaved: (value) {
                        _authData["password"] = value;
                      },
                      onChanged: (value) {
                        _currPassword = value;
                      },
                      validator: (value) {
                        if (value!.length < 8) {
                          _errorMessage +=
                              "\n- Password must be 8 characters long.";
                          return "password error";
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),
                  ),
                  if (_authMode == AuthMode.register)
                    Container(
                      height: 40,
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: size.width,
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: SmoothRectangleBorder(
                              borderRadius: SmoothBorderRadius(
                                  cornerRadius: 10, cornerSmoothing: 1))),
                      child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "confirm password"),
                        onSaved: (value) {
                          _authData["password"] = value;
                        },
                        validator: _authMode == AuthMode.register
                            ? (value) {
                                if (value != _currPassword) {
                                  _errorMessage +=
                                      "\n- Passwords do not match.";
                                  return "password error";
                                }
                                return null;
                              }
                            : (value) {
                                return null;
                              },
                        maxLines: 1,
                      ),
                    ),
                  Row(
                    children: [
                      Text(
                          _authMode == AuthMode.login
                              ? "Dont have an account?"
                              : "Already a user?",
                          style: const TextStyle(color: Colors.white)),
                      CupertinoButton(
                          child: Text(
                            _authMode == AuthMode.login ? "Register " : "Login",
                            style:
                                TextStyle(color: Colors.greenAccent.shade400),
                          ),
                          onPressed: () {
                            setState(() {
                              _authMode == AuthMode.login
                                  ? _authMode = AuthMode.register
                                  : _authMode = AuthMode.login;
                            });
                          }),
                    ],
                  ),
                  CupertinoButton(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(16),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {
                      saveForm(context);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
