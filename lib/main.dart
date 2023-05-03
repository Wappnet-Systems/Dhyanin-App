import 'package:dhyanin_app/provider/fasting_status_provider.dart';
import 'package:dhyanin_app/screens/pages/splash_screen.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    //initialize firebase
    final Future<FirebaseApp> initialization = Firebase.initializeApp();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FastingStatusProvider())
      ],
      child: FutureBuilder(
          future: initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("object");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                  title: projectTitle,
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primarySwatch: Colors.blue,
                  ),
                  home: const SplashScreen());
            }
            return CircularProgressIndicator();
          }),
    );
  }
}
