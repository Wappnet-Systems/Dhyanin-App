import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/controller/history_controller.dart';
import 'package:dhyanin_app/models/history_model.dart';
import 'package:dhyanin_app/models/user_model.dart';
import 'package:dhyanin_app/provider/fasting_status_provider.dart';
import 'package:dhyanin_app/screens/pages/history_screen.dart';
import 'package:dhyanin_app/screens/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/screens/widgets/get_time.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:intl/intl.dart';

class TrackFasting extends StatefulWidget {
  const TrackFasting({super.key});

  @override
  State<TrackFasting> createState() => _TrackFastingState();
}

class _TrackFastingState extends State<TrackFasting> {
  int fastingHours = 7; //user will change value of hours
  double defaultValue = 0;
  double value = 0;
  double fastedHours = 0;
  double timeDifference = 0;

  List<History> listHistory = [];

  var receivedData = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("trackdata")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  Future<void> addUser(String time, String hours) {
    // Call the user's CollectionReference to add a new user
    return receivedData
        .set({
          'id': receivedData.id,
          'fasting': true,
          'startTime': time,
          'hours': hours
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Timer _timer = Timer(const Duration(days: 30), () => print('Timer finished'));

  // late Timer _timer;

  HistoryController historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    final model = Provider.of<FastingStatusProvider>(context, listen: false);
    model.getUser();
    try {
      HistoryController.init();
      if (model.isStarted) {
        // print('Started time is ${model.startedTime}');
        // print('started hours is ${model.startedHours}');
        // print('Time difference is ${getTimeDifference(model.startedTime)}');
        Future.delayed(Duration.zero, () {
          startTimer(
              context,
              (double.parse(model.startedHours) * 3600) -
                  getTimeDifference(model.startedTime));
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //get duration from value(seconds)
  String _getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  int getTimeDifference(DateTime timeStarted) {
    Duration diff = DateTime.now().difference(timeStarted);
    return diff.inSeconds;
  }

  void startTimer(BuildContext context, double seconds) {
    final model = Provider.of<FastingStatusProvider>(context, listen: false);
    value = seconds;
    var focusedMins = value.toInt();
    fastedHours = (seconds / 3600);
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (value < 1) {
          model.isStarted = false;
          setState(() {
            timer.cancel();
            value = defaultValue;
            listHistory = historyController.read("history");
            listHistory.add(History(
                dateTime: DateTime.now(),
                fastingHours: int.parse(model.startedHours)));
            historyController.save("history", listHistory.cast<History>());
            print('history is saved: $listHistory');
          });
        } else {
          if (mounted) {
            setState(() {
              value--;
              print(value);
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      appBar: CustomAppBar(title: 'Track My Fast'),
      body: Consumer<FastingStatusProvider>(
        builder: (context, fastingStatusModel, child) => SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
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
                        color: primary_color,
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
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Center(
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: Stack(
                            children: [
                              SleekCircularSlider(
                                initialValue: !fastingStatusModel.isStarted
                                    ? 0.0
                                    : (double.parse(fastingStatusModel
                                                .startedHours) *
                                            3600) -
                                        double.parse(getTimeDifference(
                                                fastingStatusModel.startedTime)
                                            .toString()),
                                min: 0.0,
                                // max: 100, //for testing slider movement
                                max: !fastingStatusModel.isStarted
                                    ? fastingHours.toDouble() * 3600
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
                                    trackColor: color_1,
                                    progressBarColor: primary_color,
                                    hideShadow: true,
                                    dotColor: primary_color,
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
                                          ? _getDuration(
                                              Duration(seconds: value.toInt()))
                                          : _getDuration(Duration(
                                              seconds: (int.parse(
                                                          fastingStatusModel
                                                              .startedHours) *
                                                      3600) -
                                                  getTimeDifference(
                                                      fastingStatusModel
                                                          .startedTime))),
                                      style: TextStyle(
                                        color: primary_color,
                                        fontSize: 46,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outlined),
                            iconSize: 40,
                            color: primary_color,
                            onPressed: () {
                              setState(() {
                                if (fastingHours >= 8 &&
                                    !fastingStatusModel.isStarted) {
                                  fastingHours--;
                                }
                              });
                            },
                          ),
                          !fastingStatusModel.isStarted
                              ? Text(
                                  "${fastingHours.toString()} hr",
                                  style: const TextStyle(fontSize: 25),
                                )
                              : Text(
                                  "${fastingStatusModel.startedHours.toString()} hr",
                                  style: const TextStyle(fontSize: 25),
                                ),
                          IconButton(
                              icon: const Icon(Icons.add_circle_outlined),
                              color: primary_color,
                              iconSize: 40,
                              onPressed: () {
                                setState(() {
                                  if (!fastingStatusModel.isStarted) {
                                    fastingHours++;
                                  }
                                });
                              }),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            try {
                              if (!fastingStatusModel.isStarted) {
                                fastingStatusModel.isStarted = true;
                                startTimer(
                                    context, fastingHours.toDouble() * 3600);
                                addUser(DateTime.now().toString(),
                                    fastingHours.toString());
                              } else {
                                //todo: functionality to save or delete the fast
                                _timer.cancel();
                                receivedData.update({
                                  'fasting': false,
                                });
                                fastingStatusModel.isStarted = false;
                              }
                            } catch (e) {
                              print(e);
                            }
                          });
                        },
                        child: Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: primary_color,
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
                            style: const TextStyle(
                              color: background_color,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
