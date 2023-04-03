import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FastingStatusProvider extends ChangeNotifier {
  bool isStarted = false;
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
        } catch (e) {
          print(e);
        }
      }
      notifyListeners();
    });
  }
}
