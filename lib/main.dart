import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/services/providers/fasting_status_provider.dart';
import 'package:dhyanin_app/services/providers/theme_provider.dart';
import 'package:dhyanin_app/screens/splash_screen.dart';
import 'package:dhyanin_app/utils/constants.dart';
import 'package:dhyanin_app/utils/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    //initialize firebase
    final Future<FirebaseApp> initialization = Firebase.initializeApp();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FastingStatusProvider()),
        ChangeNotifierProvider(create: (context) => ThemeManagerProvider()),
        ChangeNotifierProvider(create: (context) => ColorsThemeNotifier()),
      ],
      child: Consumer2<ThemeManagerProvider, ColorsThemeNotifier>(
        builder: (context, themeModel, colorModel, child) => FutureBuilder(
            future: initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print("object");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return MaterialApp(
                    title: projectTitle,
                    debugShowCheckedModeBanner: false,
                    theme: themeModel.isDark
                        ? getDarkThemeFromProvider(colorModel)
                        : getLightThemeFromProvider(colorModel),
                    darkTheme: getDarkThemeFromProvider(colorModel),
                    themeMode:
                        themeModel.isDark ? ThemeMode.dark : ThemeMode.light,
                    home: const SplashScreen());
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
