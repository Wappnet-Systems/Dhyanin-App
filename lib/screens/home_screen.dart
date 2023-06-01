import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/services/providers/fasting_status_provider.dart';
import 'package:dhyanin_app/services/providers/theme_provider.dart';
import 'package:dhyanin_app/screens/track_fasting/track_fasting_screen.dart';
import 'package:dhyanin_app/utils/images.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/services/functions/check_connectivity.dart';
import 'package:dhyanin_app/widgets/custom_weekday_card.dart';
import 'package:dhyanin_app/services/functions/get_time_difference.dart';
import 'package:dhyanin_app/services/functions/greeting.dart';
import 'package:dhyanin_app/widgets/custom_home_screen_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/header_drawer.dart';
import '../widgets/list_drawer.dart';
import 'breath_meditation/audio_page_screen.dart';
import 'breath_meditation/meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FastingStatusProvider model;
  late ColorsThemeNotifier colorsModel;
  String userName = "user";
  var weekDay = [0, 0, 0, 0, 0, 0, 0];
  var collectionReference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("sessions");
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    getProfile();
    setDatesValue();
    colorsModel = Provider.of<ColorsThemeNotifier>(context, listen: false);
    model = Provider.of<FastingStatusProvider>(context, listen: false);

    CheckInternetConnectivity.checkConnectivity(context);
    model.getUser();
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
    getSavedImagePaths();
    fetchSessionsData();
    super.initState();
  }

  @override
  void dispose() {
    model.timer.cancel();
    super.dispose();
  }

  //to fetch local stored images
  Future<void> getSavedImagePaths() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPaths = prefs.getStringList('savedImagePaths') ?? [];
    savedImagePaths = await savedPaths;
  }

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
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
        child: Container(
          decoration: BoxDecoration(
              gradient: RadialGradient(
            center: Alignment.topLeft,
            colors: [
              colorsModel.primaryColor,
              colorsModel.secondaryColor1,
            ],
          )),
          child: Scaffold(
            body: Consumer<ThemeManagerProvider>(
              builder: (context, themeModel, child) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .03),
                        Row(
                          children: [
                            Text(
                              'Hello ${userName},',
                              style: headingStyle,
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: Icon(
                                  Icons.settings,
                                  size: 32,
                                )),
                          ],
                        ),
                        Text(
                          'Good ' + greeting(),
                          style: headingStyle,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        const Text(
                          'Have a great day!',
                          style: bodyStyle,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              WeekDayCard(date: weekDay[0], weekDay: 'Mon'),
                              WeekDayCard(date: weekDay[1], weekDay: 'Tue'),
                              WeekDayCard(date: weekDay[2], weekDay: 'Wed'),
                              WeekDayCard(date: weekDay[3], weekDay: 'Thu'),
                              WeekDayCard(date: weekDay[4], weekDay: 'Fri'),
                              WeekDayCard(date: weekDay[5], weekDay: 'Sat'),
                              WeekDayCard(date: weekDay[6], weekDay: 'Sun'),
                            ]),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Choose what you want to do today!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        MyCard(
                          image_path: meditationImage,
                          title: 'Breathing Meditation',
                          subTitle:
                              'Focus your attention to your breath! Calm your mind and reduce stress!',
                          next_page:
                              Meditation(updateSessionData: fetchSessionsData),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .01,
                        ),
                        const MyCard(
                          image_path: trackFastingImage,
                          title: 'Track Fasting',
                          subTitle:
                              'Restrict your eating to a certain period of time for various health benefits!',
                          next_page: TrackFasting(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .04,
                        ),
                        data.length != 0
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  "Start From Your saved Sessions!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                        data.length != 0
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: colorsModel.primaryColor,
                                                width: 0.3),
                                            gradient: LinearGradient(
                                              begin:
                                                  FractionalOffset.centerRight,
                                              end: FractionalOffset.center,
                                              colors: [
                                                colorsModel.primaryColor,
                                                colorsModel.secondaryColor1,
                                              ],
                                            )),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  playSession(index);
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .play_circle_fill_outlined,
                                                  color: colorsModel
                                                      .secondaryColor2,
                                                  size: 30,
                                                ),
                                              ),
                                              Text(
                                                '${data[index]['name']}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  infoSession(index);
                                                },
                                                icon: Icon(
                                                  Icons.info_outline,
                                                  color: colorsModel
                                                      .secondaryColor2,
                                                  size: 25,
                                                ),
                                              ),
                                              Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  deleteSession(index);
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: colorsModel
                                                      .secondaryColor1,
                                                  size: 28,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .02,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            endDrawer: Drawer(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  MyHeaderDrawer(context),
                  MyDrawerList(context),
                ],
              ),
            ),
          ),
        ));
  }

  Future<List<Map<String, dynamic>>> retrieveSessionsData() async {
    List<Map<String, dynamic>> dataList = [];

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("sessions")
          .get();

      querySnapshot.docs.forEach((document) {
        dataList.add(document.data());
      });
    } catch (e) {
      print("Error retrieving data: $e");
    }

    return dataList;
  }

  void fetchSessionsData() async {
    List<Map<String, dynamic>> dataList = await retrieveSessionsData();

    setState(() {
      data = dataList;
    });
  }

  setDatesValue() {
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

  void playSession(int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AudioPage(
          duration: data[index]['duration'],
          repeatTimes: data[index]['repeatTimes'],
          inhaleSeconds: data[index]['inhaleSeconds'],
          holdSeconds: data[index]['holdSeconds'],
          exhaleSeconds: data[index]['exhaleSeconds']),
    ));
  }

  void infoSession(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${data[index]['name']}'),
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Duration: ',
                      style: sessionStyleHeading,
                    ),
                    Text(
                      '${data[index]['duration']} minutes',
                      style: sessionStyleBody,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Repeat Cycles: ',
                      style: sessionStyleHeading,
                    ),
                    Text(
                      '${data[index]['repeatTimes']}',
                      style: sessionStyleBody,
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  'Breathing Seconds',
                  style: sessionStyleHeading,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '   Inhale:  ${data[index]['inhaleSeconds']}',
                  style: sessionStyleBody,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '   Hold:    ${data[index]['holdSeconds']}',
                  style: sessionStyleBody,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  '   Exhale: ${data[index]['exhaleSeconds']}',
                  style: sessionStyleBody,
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteSession(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Session'),
            content: Text('Do you really want to delete this session?'),
            actions: [
              MaterialButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  var documentReference =
                      await collectionReference.doc(data[index]['id']);
                  await documentReference.delete();
                  setState(() {
                    data.removeAt(index);
                  });
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
