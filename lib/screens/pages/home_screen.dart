import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/provider/fasting_status_provider.dart';
import 'package:dhyanin_app/screens/pages/track_fasting_screen.dart';
import 'package:dhyanin_app/screens/widgets/greeting.dart';
import 'package:dhyanin_app/screens/widgets/my_card.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FastingStatusProvider model;

  int getTimeDifference(DateTime timeStarted) {
    Duration diff = DateTime.now().difference(timeStarted);
    return diff.inSeconds;
  }

  @override
  void initState() {
    model = Provider.of<FastingStatusProvider>(context, listen: false);
    model.getUser();
    try {
      if (model.isStarted) {
        model.startTimer((double.parse(model.startedHours) * 3600) -
            getTimeDifference(model.startedTime));
      }
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  @override
  void dispose() {
    model.timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * .03),
                const Text(
                  'Good',
                  style: textStyle_heading,
                ),
                Text(
                  greeting(),
                  style: textStyle_heading,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                const Text(
                  'Have a great day!',
                  style: textStyle_body,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .04,
                ),
                const MyCard(
                  image_path: 'assets/images/meditation.png',
                  name: 'Meditation',
                  next_page: Meditation(),
                ),
                const MyCard(
                  image_path: 'assets/images/fasting.jpg',
                  name: 'Track Fasting',
                  next_page: TrackFasting(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
