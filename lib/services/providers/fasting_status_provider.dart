import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/services/controller/history_controller.dart';
import 'package:dhyanin_app/services/models/history_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FastingStatusProvider extends ChangeNotifier {
  bool isStarted = false; //to check whether fast is started or not
  String startedHours =
      "7"; //default value of fastingHours to update to database when fast is over or ended
  DateTime startedTime = DateTime.now(); //time when fast started
  double value = 0; //value (in seconds) to keep track of clock
  double fastedHours =
      7; //to calculate remaining hours when fast is already started and user is coming from outside app
  int fastingHours = 7; //fasting hours selected by user

  //to increase fasting hours
  incFastingHours() {
    fastingHours++;
    notifyListeners();
  }

  //to decrease fasting hours
  decFastingHours() {
    fastingHours--;
    notifyListeners();
  }

  Timer timer = Timer(const Duration(days: 30), () => print('Timer finished'));

  //to save fast details when completed
  HistoryController historyController = HistoryController();
  List<History> listHistory = [];

  //function to get details of user
  Future<void> getUser() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("trackdata")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot doc) {
      if (doc.exists) {
        try {
          isStarted = doc['fasting'];
          startedHours = doc['hours'];
          startedTime = DateTime.parse(doc['startTime']);
        } catch (e) {
          print(e);
        }
      }
      notifyListeners();
    });
  }

  //function to start timer when fast is started
  void startTimer(double seconds) {
    value = seconds;
    fastedHours = (seconds / 3600);
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        if (value < 2) {
          timer.cancel();
          isStarted = false;
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("trackdata")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'fasting': false, 'hours': '7'});
          value = 0;
          var documentReference = await FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection("fastHistory")
              .doc();
          await documentReference.set({
            'dateTime': DateTime.now(),
            "fastingHours": int.parse(startedHours)
          });
          notifyListeners();
        } else {
          value--;
          notifyListeners();
          print(value);
        }
      },
    );
  }

  //when user end fast before fasting hours
  endFast() {
    value = 0;
    timer.cancel();
    isStarted = false;
    notifyListeners();
  }

  void completeFast() {
    isStarted = false;
    notifyListeners();
  }

  //when user successfully complete fast, to add in history
  addFastInHistory() async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("fastHistory")
          .doc();
      await documentReference.set({
        'dateTime': startedTime.add(Duration(hours: int.parse(startedHours))),
        "fastingHours": int.parse(startedHours)
      });
    } catch (e) {
      print(e);
    }
  }
}
