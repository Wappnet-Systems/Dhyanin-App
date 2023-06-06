import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meditation_history_model.dart';

class MeditationHistoryController {
  List<String>? list = [];
  List<MeditationHistory>? historyList = [];

  //to read saved history
  Future<List<MeditationHistory>> read() async {
    List<MeditationHistory> historyList = [];
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("meditationHistory")
          .get();

      querySnapshot.docs.forEach((doc) {
        var data = doc.data();
        var history = MeditationHistory(
          dateTime: data['dateTime'].toDate(),
          duration: data['duration'],
          repeatTimes: data['repeatTimes'],
        );
        historyList.add(history);
      });
    } catch (e) {}

    return historyList;
  }
}
