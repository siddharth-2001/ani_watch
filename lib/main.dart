import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';

//local imoorts
import 'screens/home_screen.dart';
import './screens/search_screen.dart';
import './screens/favourite_screen.dart';
import './screens/settings_screen.dart';
import './screens/auth_screen.dart';
import './screens/main_screen.dart';

//provider imports
import './provider/anime.dart';
import './provider/settings.dart';
import './provider/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => TrendingAnime(),
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
      ChangeNotifierProvider(
        create: (context) => UserService(),
      ),
      ChangeNotifierProxyProvider<UserService, AnimeService>(
        create: (context) => AnimeService(),
        update: (context, user, animeService) {
          return animeService!..setUser(user);
        },
      ),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    const transitionType = PageTransitionType.fade;
    final appSettings = Provider.of<AppSettings>(context);

    return CupertinoApp(
      localizationsDelegates: const [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
            
              actionTextStyle: GoogleFonts.montserrat(),
              textStyle: GoogleFonts.montserrat(),
              navLargeTitleTextStyle: const CupertinoTextThemeData()
                  .navLargeTitleTextStyle
                  .copyWith(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontSize: 24),
              navTitleTextStyle: const CupertinoTextThemeData()
                  .navTitleTextStyle
                  .copyWith(
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                      fontSize: 16)
                      ),
          barBackgroundColor:
              Colors.grey.shade900.withOpacity(appSettings.blurOverlayOpacity)),
      home: const AuthScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomeScreen.routeName:
            return PageTransition(
                child: const HomeScreen(),
                type: transitionType,
                settings: settings);

          case SearchScreen.routeName:
            return PageTransition(
                child: SearchScreen(),
                type: transitionType,
                settings: settings,
                ctx: context);

          case FavouriteScreen.routeName:
            return PageTransition(
                child: const FavouriteScreen(),
                type: transitionType,
                settings: settings,
                ctx: context);

          case SettingsScreen.routeName:
            return PageTransition(
                child: const SettingsScreen(),
                type: transitionType,
                settings: settings,
                ctx: context);

          case AuthScreen.routeName:
            return PageTransition(
                child: const AuthScreen(),
                type: transitionType,
                settings: settings,
                ctx: context);

          case MainScreen.routeName:
            return PageTransition(
                child: const MainScreen(),
                type: transitionType,
                settings: settings);

          default:
            return PageTransition(
                child: const HomeScreen(),
                type: transitionType,
                settings: settings);
        }
      },
    );
  }
}
