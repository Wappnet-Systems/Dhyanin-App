import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dhyanin_app/controller/history_controller.dart';
import 'package:dhyanin_app/provider/fasting_status_provider.dart';
import 'package:dhyanin_app/screens/auth/mobile_number_input_screen.dart';
import 'package:dhyanin_app/screens/pages/track_fasting_screen.dart';
import 'package:dhyanin_app/screens/widgets/check_connectivity.dart';
import 'package:dhyanin_app/screens/widgets/custom_snackbar.dart';
import 'package:dhyanin_app/screens/widgets/custom_weekday_card.dart';
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
  var weekDay = [0, 0, 0, 0, 0, 0, 0];

  @override
  void initState() {
    setDatesValue();
    model = Provider.of<FastingStatusProvider>(context, listen: false);
    CheckInternetConnectivity.checkConnectivity(context);
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
                        exit(0);
                      },
                      child: Text("Yes"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("No"),
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
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .03),
                    const Text(
                      'Hello,',
                      style: headingStyle,
                    ),
                    Text(
                      'Good ' + greeting(),
                      style: headingStyle,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    const Text(
                      'Have a great day!',
                      style: bodyStyle,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Row(children: [
                      WeekDayCard(date: weekDay[0], weekDay: 'Mon'),
                      WeekDayCard(date: weekDay[1], weekDay: 'Tue'),
                      WeekDayCard(date: weekDay[2], weekDay: 'Wed'),
                      WeekDayCard(date: weekDay[3], weekDay: 'Thu'),
                      WeekDayCard(date: weekDay[4], weekDay: 'Fri'),
                      WeekDayCard(date: weekDay[5], weekDay: 'Sat'),
                      WeekDayCard(date: weekDay[6], weekDay: 'Sun'),
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .06,
                    ),
                    Text(
                      "Choose what you want to do today!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    const MyCard(
                      image_path: 'assets/images/meditation.png',
                      title: 'Breathing Meditation',
                      subTitle:
                          'Focus your attention to your breath! Calm your mind and reduce stress!',
                      next_page: Meditation(),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .01,
                    ),
                    const MyCard(
                      image_path: 'assets/images/fasting.jpg',
                      title: 'Track Fasting',
                      subTitle:
                          'Restrict your eating to a certain period of time for various health benefits!',
                      next_page: TrackFasting(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  setDatesValue() {
    int todayDate = DateTime.now().day;
    int todayWeekday = DateTime.now().weekday;
    int nextDay = 0;
    int previousDay = -1;
    for (int i = todayWeekday; i <= 7; i++) {
      weekDay[i - 1] = DateTime.now().add(Duration(days: nextDay++)).day;
    }
    if (todayWeekday > 1) {
      for (int i = todayWeekday - 1; i > 0; i--) {
        weekDay[i - 1] = DateTime.now().add(Duration(days: previousDay--)).day;
      }
    }
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
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("No"),
              ),
            ],
            actionsAlignment: MainAxisAlignment.end,
          );
        });
  }
}
