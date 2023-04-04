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
}
