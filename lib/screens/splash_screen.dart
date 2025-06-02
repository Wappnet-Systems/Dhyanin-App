import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/mobile_number_input_screen.dart';
import '../services/providers/colors_theme_provider.dart';
import '../services/providers/theme_provider.dart';
import '../utils/constants.dart';
import '../utils/images.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  int themeIndex = 1;

  @override
  void initState() {
    Provider.of<ThemeManagerProvider>(context, listen: false)
        .checkThemeStatus();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ColorsThemeNotifier colorsModel =
        Provider.of<ColorsThemeNotifier>(context, listen: false);
    getThemeIndex();
    colorsModel.selectTheme(themeIndex);
  }

  Future<void> getThemeIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      themeIndex = prefs.getInt('theme') ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return AnimatedSplashScreen(
        backgroundColor: Theme.of(context).colorScheme.background,
        duration: 1500,
        splashTransition: SplashTransition.scaleTransition,
        splashIconSize: 250,
        animationDuration: Duration(milliseconds: 1500),
        splash: Center(
          child: Column(
            children: [
              Container(
                height: 225,
                child: Image.asset(
                  splashImage,
                  height: 250,
                  width: 250,
                ),
              ),
              Text(
                projectTitle,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: model.primaryColor),
              )
            ],
          ),
        ),
        nextScreen: user != null ? HomeScreen() : MobileNumberInput());
  }
}
