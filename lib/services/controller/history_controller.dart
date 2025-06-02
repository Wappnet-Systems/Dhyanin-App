import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/history_model.dart';

class HistoryController {
  List<String>? list = [];
  List<History>? historyList = [];

  //to read saved history
  Future<List<History>> read() async {
    List<History> historyList = [];
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("fastHistory")
          .get();

      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        var history = History(
          dateTime: data['dateTime'].toDate(),
          fastingHours: data['fastingHours'],
        );
        historyList.add(history);
      });
    } catch (e) {}

    return historyList;
  }
}
