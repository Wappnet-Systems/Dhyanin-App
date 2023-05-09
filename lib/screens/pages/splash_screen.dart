import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dhyanin_app/provider/theme_provider.dart';
import 'package:dhyanin_app/screens/pages/home_screen.dart';
import 'package:dhyanin_app/screens/auth/mobile_number_input_screen.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    Provider.of<ThemeManagerProvider>(context, listen: false)
        .checkThemeStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  'assets/images/splash_rounded.png',
                  // 'assets/images/splash_screen.jpg',
                  height: 250,
                  width: 250,
                ),
              ),
              Text(
                projectTitle,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color_2),
              )
            ],
          ),
        ),
        nextScreen: user != null ? HomeScreen() : MobileNumberInput());
  }
}
