import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

//local imoorts
import 'screens/home_screen.dart';
import './screens/search_screen.dart';
import './screens/favourite_screen.dart';
import './screens/settings_screen.dart';

//provider imports
import './provider/anime.dart';
import './provider/settings.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => TrendingAnime(),
      ),
      ChangeNotifierProvider(
        create: (context) => AllAnime(),
      ),
      ChangeNotifierProvider(
        create: (context) => PopularAnime(),
      ),
      ChangeNotifierProvider(
        create: (context) => RecentEpisodes(),
      ),
      ChangeNotifierProvider(
        create: (context) => AppSettings(),
      ),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  final transitionType = PageTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return MaterialApp(
      theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
          primaryColor: Colors.greenAccent.shade400),
      home: const HomeScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            return PageTransition(
                child: const HomeScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings);

          case SearchScreen.routeName:
            return PageTransition(
                child: const SearchScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings,
                ctx: context);

          case FavouriteScreen.routeName:
            return PageTransition(
                child: const FavouriteScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings,
                ctx: context);

          case SettingsScreen.routeName:
            return PageTransition(
                child: const SettingsScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings,
                ctx: context);

          default:
            return PageTransition(
                child: const HomeScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings);
        }
      },
    );
  }
}
