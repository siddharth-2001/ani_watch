import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

//local imoorts
import 'screens/show_detail_screen.dart';
import 'screens/home_screen.dart';
import './screens/watch_episode_screen.dart';
import './screens/search_screen.dart';
import './screens/favourite_screen.dart';
import './screens/settings_screen.dart';

//provider imports
import './provider/anime.dart';

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
      initialRoute: HomeScreen.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            return PageTransition(
                child: const HomeScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings);

          case ShowDetailScreen.routeName:
            return PageTransition(
                child: const ShowDetailScreen(),
                type: transitionType,
                isIos: isIos,
                settings: settings);

          case WatchEpisodeScreen.routeName:
            return PageTransition(
                child: const WatchEpisodeScreen(),
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
