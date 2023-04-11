import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/controller/history_controller.dart';
import 'package:dhyanin_app/provider/fasting_status_provider.dart';
import 'package:dhyanin_app/screens/auth/mobile_number_input_screen.dart';
import 'package:dhyanin_app/screens/pages/track_fasting_screen.dart';
import 'package:dhyanin_app/screens/widgets/get_time_difference.dart';
import 'package:dhyanin_app/screens/widgets/greeting.dart';
import 'package:dhyanin_app/screens/widgets/my_card.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FastingStatusProvider model;

  @override
  void initState() {
    model = Provider.of<FastingStatusProvider>(context, listen: false);
    model.getUser();
    HistoryController.init();
    try {
      if (model.isStarted) {
        if ((int.parse(model.startedHours) * 3600) -
                getTimeDifference(model.startedTime) <
            0) {
          // HistoryController.init();
          // model.addFastInHistory();
          // model.isStarted = false;
          // Future.delayed(Duration.zero, () {
          //   model.completeFast();
          // });
        }
        // else {
        //   model.startTimer((double.parse(model.startedHours) * 3600) -
        //       getTimeDifference(model.startedTime));
        // }
      }
    } catch (e) {
      print(e);
    }

    super.initState();
  }

  @override
  void dispose() {
    model.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: background_color,
                  title: Text('Exit App'),
                  content: Text('Do you want to exit?'),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text("Yes"),
                    ),
                  ],
                  actionsAlignment: MainAxisAlignment.end,
                );
              });
          return true;
        },
        child: Scaffold(
          backgroundColor: background_color,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: FloatingActionButton(
              onPressed: () {
                signOut(context);
              },
              backgroundColor: Color.fromARGB(255, 217, 65, 136),
              child: const Icon(Icons.logout_rounded),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .03),
                    const Text(
                      'Good',
                      style: textStyle_heading,
                    ),
                    Text(
                      greeting(),
                      style: textStyle_heading,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    const Text(
                      'Have a great day!',
                      style: textStyle_body,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    const MyCard(
                      image_path: 'assets/images/meditation.png',
                      name: 'Meditation',
                      next_page: Meditation(),
                    ),
                    const MyCard(
                      image_path: 'assets/images/fasting.jpg',
                      name: 'Track Fasting',
                      next_page: TrackFasting(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> signOut(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: background_color,
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
              MaterialButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MobileNumberInput()));
                  // Navigator.of(context).pushReplacement(
                  //     ,
                  //     result: MaterialPageRoute(
                  //         builder: (context) => MobileNumberInput()));
                },
                child: Text("Yes"),
              ),
            ],
            actionsAlignment: MainAxisAlignment.end,
          );
        });
  }
}
