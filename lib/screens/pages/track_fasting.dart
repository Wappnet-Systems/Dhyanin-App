import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TrackFasting extends StatefulWidget {
  const TrackFasting({super.key});

  @override
  State<TrackFasting> createState() => _TrackFastingState();
}

class _TrackFastingState extends State<TrackFasting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      body: Text('hello'),
    );
  }
}
