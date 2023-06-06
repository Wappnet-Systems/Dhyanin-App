import 'dart:async';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../../services/functions/check_connectivity.dart';
import '../../services/functions/get_duration.dart';
import '../../services/functions/get_time_difference.dart';
import '../../services/providers/colors_theme_provider.dart';
import '../../services/providers/fasting_status_provider.dart';
import '../../utils/styles.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/track_fasting/custom_fasting_card.dart';
import 'fasting_history_screen.dart';

class TrackFasting extends StatefulWidget {
  const TrackFasting({super.key});

  @override
  State<TrackFasting> createState() => _TrackFastingState();
}

class _TrackFastingState extends State<TrackFasting> {
  late FastingStatusProvider model; //provider model
  bool _enabled = true; //to disable snackbar for sometime

  var receivedData = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("trackdata")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  //add user on firebase database
  Future<void> addUser(String time, String hours) {
    // Call the user's CollectionReference to add a new user
    return receivedData
        .set({
          'id': receivedData.id,
          'fasting': true,
          'startTime': time,
          'hours': hours,
        })
        .then((value) => () {})
        .catchError((error) => () {});
  }

  @override
  void initState() {
    model = Provider.of<FastingStatusProvider>(context, listen: false);
    CheckInternetConnectivity.checkConnectivity(context);
    model.getUser();
    try {
      if (model.isStarted) {
        if ((int.parse(model.startedHours) * 3600) -
                getTimeDifference(model.startedTime) <
            0) {
          model.addFastInHistory();
          model.isStarted = false;
          Future.delayed(Duration.zero, () {
            model.completeFast();
          });
          receivedData.update({
            'fasting': false,
            'hours': '7',
          });
        } else {
          model.startTimer((double.parse(model.startedHours) * 3600) -
              getTimeDifference(model.startedTime));
        }
      }
    } catch (e) {}

    super.initState();
  }

  @override
  void dispose() {
    model.timer.cancel();
    super.dispose();
  }

  void _showDialogue() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('End Fast'),
            content: Text('Do you really want to end fast now?'),
            actions: [
              MaterialButton(
                onPressed: () {
                  model.fastingHours = 7;
                  model.endFast();
                  receivedData.update({
                    'fasting': false,
                    'hours': '7',
                  });
                  Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier colorsModel =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    if (model.isStarted &&
        (int.parse(model.startedHours) * 3600) -
                getTimeDifference(model.startedTime) <
            0) {
      Future.delayed(Duration.zero, () {
        model.completeFast();
      });
      model.isStarted = false;
    }
    return Container(
      decoration: topLeftToBottomRightGradient(colorsModel),
      child: Scaffold(
        appBar: CustomAppBar(title: 'Track My Fast'),
        body: Consumer2<FastingStatusProvider, ColorsThemeNotifier>(
          builder: (context, fastingStatusModel, themeModel, child) => SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.history,
                          color: themeModel.secondaryColor2,
                          size: 35,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const HistoryScreen()));
                        },
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: SleekCircularSlider(
                              initialValue: !fastingStatusModel.isStarted
                                  ? 0.0
                                  : (double.parse(
                                              fastingStatusModel.startedHours) *
                                          3600) -
                                      double.parse(getTimeDifference(
                                              fastingStatusModel.startedTime)
                                          .toString()),
                              min: 0.0,
                              max: !fastingStatusModel.isStarted
                                  ? fastingStatusModel.fastingHours.toDouble() *
                                      3600
                                  : (double.parse(
                                          fastingStatusModel.startedHours) *
                                      3600),
                              appearance: CircularSliderAppearance(
                                customWidths: CustomSliderWidths(
                                  trackWidth: 15,
                                  handlerSize: 18,
                                  progressBarWidth: 15,
                                  shadowWidth: 0,
                                ),
                                customColors: CustomSliderColors(
                                  trackColor: themeModel.secondaryColor2
                                      .withOpacity(0.4),
                                  progressBarColor: themeModel.secondaryColor2,
                                  hideShadow: true,
                                  dotColor: themeModel.secondaryColor2,
                                ),
                                size: 250,
                                angleRange: 360,
                                startAngle: 270,
                              ),
                              onChange: null,
                              innerWidget: (double newValue) {
                                return Center(
                                  child: Text(
                                    !fastingStatusModel.isStarted
                                        ? getDuration(Duration(
                                            seconds: fastingStatusModel.value
                                                .toInt()))
                                        : getDuration(Duration(
                                            seconds: ((int.parse(
                                                        fastingStatusModel
                                                            .startedHours) *
                                                    3600) -
                                                getTimeDifference(
                                                    fastingStatusModel
                                                        .startedTime)))),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontFamily: "",
                                      fontSize: 46,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outlined),
                              iconSize: 40,
                              color: themeModel.secondaryColor2,
                              onPressed: () =>
                                  decrementFastingHours(fastingStatusModel),
                            ),
                            !fastingStatusModel.isStarted
                                ? Text(
                                    "${fastingStatusModel.fastingHours.toString()} hr",
                                    style: const TextStyle(fontSize: 25),
                                  )
                                : Text(
                                    "${fastingStatusModel.startedHours} hr",
                                    style: const TextStyle(fontSize: 25),
                                  ),
                            IconButton(
                                icon: const Icon(Icons.add_circle_outlined),
                                color: themeModel.secondaryColor2,
                                iconSize: 40,
                                onPressed: () =>
                                    incrementFastingHours(fastingStatusModel))
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              try {
                                if (!fastingStatusModel.isStarted) {
                                  fastingStatusModel.startedHours =
                                      fastingStatusModel.fastingHours
                                          .toString();
                                  fastingStatusModel.startedTime =
                                      DateTime.now();
                                  try {
                                    fastingStatusModel.isStarted = true;
                                    addUser(
                                        DateFormat("yyyy-MM-dd HH:mm:ss")
                                            .format(DateTime.now()),
                                        fastingStatusModel.fastingHours
                                            .toString());
                                    fastingStatusModel.startTimer(
                                        fastingStatusModel.fastingHours
                                                .toDouble() *
                                            3600);
                                  } catch (e) {}
                                } else {
                                  _showDialogue();
                                }
                              } catch (e) {}
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              gradient: rightToLeftGradient(themeModel),
                              color: themeModel.secondaryColor2,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 3,
                                  blurRadius: 3,
                                  offset: const Offset(0, 3),
                                  color: Colors.black.withOpacity(0.1),
                                )
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              fastingStatusModel.isStarted
                                  ? "End Fast"
                                  : "Start Fast",
                              style: TextStyle(
                                color: themeModel.backgroundColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      FastingCard(
                          title: "Fast Started",
                          isStarted: model.isStarted,
                          fastingDateTime: fastStartingTime()),
                      FastingCard(
                          title: "Fast Ending",
                          isStarted: model.isStarted,
                          fastingDateTime: fastEndingTime()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String fastStartingTime() {
    String day = DateFormat('yyyy-MM-dd').format(model.startedTime),
        time = DateFormat('hh:mm a').format(model.startedTime);
    ;
    if (model.startedTime.day == DateTime.now().day) {
      day = "Today";
    } else if (model.startedTime.day ==
        DateTime.now().subtract(Duration(days: 1)).day) {
      day = "Yesterday";
    }
    return day + ", " + time;
  }

  String fastEndingTime() {
    DateTime endingTime =
        model.startedTime.add(Duration(hours: int.parse(model.startedHours)));
    String day = DateFormat('yyyy-MM-dd').format(endingTime),
        time = DateFormat('hh:mm a').format(endingTime);
    ;
    if (endingTime.day == DateTime.now().day) {
      day = "Today";
    } else if (endingTime.day == DateTime.now().add(Duration(days: 1)).day) {
      day = "Tomorrow";
    }
    return day + ", " + time;
  }

  void decrementFastingHours(FastingStatusProvider provider) {
    if (!provider.isStarted) {
      setState(() {
        if (provider.fastingHours >= 8) {
          provider.decFastingHours();
        } else {
          if (_enabled) {
            CustomSnackbar.functionSnackbar(
                context, 'Fasting hours can\'t be less than 7 Hours!');
            _enabled = false;
            Timer(Duration(seconds: 5), () {
              if (this.mounted) {
                setState(() {
                  _enabled = true;
                });
              }
            });
          }
        }
      });
    }
  }

  void incrementFastingHours(FastingStatusProvider provider) {
    if (!provider.isStarted) {
      setState(() {
        if (provider.fastingHours < 48) {
          provider.incFastingHours();
        } else {
          if (_enabled) {
            _enabled = false;

            CustomSnackbar.functionSnackbar(
                context, 'Fasting hours can\'t be more than 48 Hours!');
            Timer(Duration(seconds: 5), () {
              if (this.mounted) {
                setState(() {
                  _enabled = true;
                });
              }
            });
          }
        }
      });
    }
  }
}
