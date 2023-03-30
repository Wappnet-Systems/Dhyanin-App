import 'dart:async';
import 'package:dhyanin_app/controller/history_controller.dart';
import 'package:dhyanin_app/models/history_model.dart';
import 'package:dhyanin_app/screens/pages/history_screen.dart';
import 'package:dhyanin_app/screens/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class TrackFasting extends StatefulWidget {
  const TrackFasting({super.key});

  @override
  State<TrackFasting> createState() => _TrackFastingState();
}

class _TrackFastingState extends State<TrackFasting> {
  int fastingHours = 7; //user will change value of hours
  double defaultValue = 0;
  double value = 100;
  bool isStarted = false;
  int focusedMins = 0;

  List<History> listHistory = [];

  // late Timer _timer;
  Timer _timer =
      Timer(const Duration(minutes: 2), () => print('Timer finished'));

  HistoryController historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    HistoryController.init();
  }

  //get duration from value(seconds)
  String _getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void startTimer() {
    value = fastingHours.toDouble() * 3600;
    focusedMins = value.toInt();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (value <= 1) {
          setState(() {
            timer.cancel();
            value = defaultValue;
            isStarted = false;
            // listHistory = historyController.read("history");
            // listHistory.add(
            //     History(dateTime: DateTime.now(), focusedSecs: focusedMins));
            // historyController.save("history", listHistory.cast<History>());
          });
        } else {
          setState(() {
            value--;
          });
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
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   mainAxisSize: MainAxisSize.max,
              //   children: <Widget>[
              //     IconButton(
              //       icon: Icon(
              //         Icons.history,
              //         color: primary_color,
              //         size: 35,
              //       ),
              //       onPressed: () {
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (BuildContext context) =>
              //                     const HistoryScreen()));
              //       },
              //     ),
              //   ],
              // ),
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
                              initialValue: value,
                              min: 0,
                              // max: 100, //for testing slider movement
                              max: fastingHours.toDouble() * 3600,
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
                                    _getDuration(
                                        Duration(seconds: value.toInt())),
                                    style: TextStyle(
                                      color: primary_color,
                                      fontSize: 46,
                                    ),
                                  ),
                                );
                              },
                            ),
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
                              if (fastingHours >= 8) {
                                fastingHours--;
                              }
                            });
                          },
                        ),
                        Text(
                          "${fastingHours.toString()} hr",
                          style: const TextStyle(fontSize: 25),
                        ),
                        IconButton(
                            icon: const Icon(Icons.add_circle_outlined),
                            color: primary_color,
                            iconSize: 40,
                            onPressed: () => setState(() => fastingHours++)),
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isStarted) {
                            isStarted = true;
                            startTimer();
                          } else {
                            //todo: functionality to save or delete the fast
                            _timer.cancel();
                            // value = defaultValue;
                            isStarted = false;
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
                          isStarted ? "End Fast" : "Start Fast",
                          style: const TextStyle(
                            color: background_color,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
