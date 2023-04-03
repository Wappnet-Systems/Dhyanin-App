import 'package:dhyanin_app/screens/pages/splash_screen.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> initialization = Firebase.initializeApp();

    return FutureBuilder(
        future: initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("object");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
                title: PROJECT_TITLE,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: const SplashScreen());
          }
          return CircularProgressIndicator();
        });
  }
}
