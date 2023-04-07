import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/controller/history_controller.dart';
import 'package:dhyanin_app/models/history_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FastingStatusProvider extends ChangeNotifier {
  bool isStarted = false;
  String startedHours = "";
  DateTime startedTime = DateTime.now();
  double value = 0;
  double fastedHours = 7;
  int fastingHours = 7;

  incFastingHours() {
    fastingHours++;
    notifyListeners();
  }

  decFastingHours() {
    fastingHours--;
    notifyListeners();
  }

  Timer timer = Timer(const Duration(days: 30), () => print('Timer finished'));
  HistoryController historyController = HistoryController();

  List<History> listHistory = [];

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

  void startTimer(double seconds) {
    value = seconds;
    fastedHours = (seconds / 3600);
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
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
          listHistory = historyController.read("history");
          listHistory.add(History(
              dateTime: DateTime.now(), fastingHours: int.parse(startedHours)));
          historyController.save("history", listHistory.cast<History>());
          print('history is saved: $listHistory');
          notifyListeners();
        } else {
          value--;
          notifyListeners();
          print(value);
        }
      },
    );
  }

  endFast() {
    value = 0;
    timer.cancel();
    isStarted = false;
    notifyListeners();
  }

  completeFast() {
    isStarted = false;
    notifyListeners();
  }

  addFastInHistory() {
    HistoryController.init();
    try {
      listHistory = historyController.read("history");
      listHistory.add(History(
          dateTime: startedTime.add(Duration(hours: int.parse(startedHours))),
          fastingHours: int.parse(startedHours)));
      historyController.save("history", listHistory.cast<History>());
    } catch (e) {
      print(e);
    }
  }
}
