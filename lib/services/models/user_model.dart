import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? id;
  final String startTime;
  final String hours;
  const UserModel({this.id, required this.startTime, required this.hours});

  toJson() {
    return {
      'start': startTime,
      'hours': hours,
    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: FirebaseAuth.instance.currentUser?.uid,
        startTime: data['start'],
        hours: data['hours']);
  }
}
