import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dhyanin_app/screens/pages/home_screen.dart';
import 'package:dhyanin_app/screens/pages/mobile_number_input.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isLogin = false;
    return MaterialApp(
        title: PROJECT_TITLE,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AnimatedSplashScreen(
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
                      SPLASH,
                      height: 250,
                      width: 250,
                    ),
                  ),
                  Text(
                    PROJECT_TITLE,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color_2),
                  )
                ],
              ),
            ),
            nextScreen: isLogin ? HomeScreen() : MobileNumberInput()));
  }
}
