import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dhyanin_app/screens/pages/home_screen.dart';
import 'package:dhyanin_app/screens/pages/mobile_number_input.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = FirebaseAuth.instance;
  var isLogin = false; //user login status

  checkIfLogin() async {
    auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 1500,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: background_color,
        splashIconSize: 250,
        animationDuration: Duration(milliseconds: 1500),
        splash: Center(
          child: Column(
            children: [
              Container(
                height: 225,
                child: Image.asset(
                  'assets/images/splash_screen.jpg',
                  height: 250,
                  width: 250,
                ),
              ),
              Text(
                PROJECT_TITLE,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: color_2),
              )
            ],
          ),
        ),
        nextScreen: isLogin ? HomeScreen() : MobileNumberInput());
  }
}
