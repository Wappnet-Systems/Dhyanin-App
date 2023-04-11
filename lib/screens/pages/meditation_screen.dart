import 'package:dhyanin_app/screens/pages/audio_page_screen.dart';
import 'package:dhyanin_app/screens/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/screens/widgets/simple_card.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:flutter/material.dart';

class Meditation extends StatefulWidget {
  const Meditation({super.key});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  int value = 0; //index value of by default duration
  int repeatValue = 0;

  //Custom radio button widget for duration
  Widget customRadioButton(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          value = index;
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: (value == index) ? color_2 : Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: (value == index) ? color_2 : Colors.black,
        ),
      ),
    );
  }

  //Custom radio button widget for duration
  Widget customRadioButtonRepeat(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          repeatValue = index;
        });
      },
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side:
            BorderSide(color: (repeatValue == index) ? color_2 : Colors.black),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: (repeatValue == index) ? color_2 : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      appBar: const CustomAppBar(title: 'Dhyanin'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15.0, left: 5.0, bottom: 20.0),
                child: Text(
                  'Select Duration',
                  style: textStyle_body,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    customRadioButton('5 min', 0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    customRadioButton('10 min', 1),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    customRadioButton('15 min', 2),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    customRadioButton('20 min', 3),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    customRadioButton('30 min', 4),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0, left: 5.0, bottom: 20.0),
                child: Text(
                  'Select Repeat Cycle',
                  style: textStyle_body,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    customRadioButtonRepeat('1 time', 0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    customRadioButtonRepeat('2 times', 1),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    customRadioButtonRepeat('3 times', 2),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0, left: 5.0),
                child: Text(
                  'Choose Your Meditation',
                  style: textStyle_body,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SimpleCard(
                name: 'Breathe',
                next_page: AudioPage(
                  indexOfAudio: value,
                  repeatTimes: repeatValue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
