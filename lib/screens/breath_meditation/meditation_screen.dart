import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/screens/breath_meditation/audio_page_screen.dart';
import 'package:dhyanin_app/screens/breath_meditation/meditation_history_screen.dart';
import 'package:dhyanin_app/services/controller/meditation_history_controller.dart';
import 'package:dhyanin_app/services/functions/check_connectivity.dart';
import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Meditation extends StatefulWidget {
  final Function updateSessionData;
  const Meditation({super.key, required this.updateSessionData});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  int value = 5; //index value of by default duration
  int repeatValue = 1; //to repeat meditation
  double inhaleSeconds = 2;
  double holdSeconds = 0;
  double exhaleSeconds = 4;
  bool addSession = false;
  TextEditingController _sessionNameController = TextEditingController();

  var data = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection("sessions")
      .doc();

  //Custom radio button widget for duration
  Widget customRadioButton(String text, int index) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return Container(
      height: MediaQuery.of(context).size.height * 0.042,
      decoration: leftToRightGradient(model, value, index),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            value = index;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: (value == index)
              ? null
              : Theme.of(context).colorScheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(
              color: (value == index)
                  ? model.secondaryColor2
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: (value == index)
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  //Custom radio button widget for duration
  Widget customRadioButtonRepeat(String text, int index) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return Container(
      height: MediaQuery.of(context).size.height * 0.042,
      decoration: leftToRightGradient(model, repeatValue, index),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            repeatValue = index;
          });
        },
        style: OutlinedButton.styleFrom(
            backgroundColor: (repeatValue == index)
                ? null
                : Theme.of(context).colorScheme.background,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            side: BorderSide(
              color: (repeatValue == index)
                  ? model.secondaryColor2
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            )),
        child: Text(
          text,
          style: TextStyle(
            color: (repeatValue == index)
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  //alert dialogue box for session's name input
  Future<void> _showBox(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Session Name'),
          content: TextFormField(
            controller: _sessionNameController,
            decoration: InputDecoration(hintText: 'Enter Session Name'),
          ),
          actions: [
            MaterialButton(
              child: Text('Save'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    CheckInternetConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    _sessionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return Container(
      decoration: topLeftToBottomRightGradient(model),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Breathing Meditation'),
        body: Consumer<ColorsThemeNotifier>(
          builder: (context, themeModel, child) => SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              top: 15.0, left: 5.0, bottom: 15.0),
                          child: Text(
                            'Select Duration (Per Cycle)',
                            style: bodyStyle,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.history,
                            color: themeModel.secondaryColor2,
                            size: 35,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        const MeditationHistoryScreen()));
                          },
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          customRadioButton('5 min', 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButton('10 min', 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButton('15 min', 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButton('20 min', 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButton('30 min', 30),
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
                      padding: EdgeInsets.only(left: 5.0, bottom: 15.0),
                      child: Text(
                        'Select Repeat Cycle',
                        style: bodyStyle,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          customRadioButtonRepeat('1 time', 1),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButtonRepeat('2 times', 2),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButtonRepeat('3 times', 3),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButtonRepeat('4 times', 4),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          customRadioButtonRepeat('5 times', 5),
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
                      padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                      child: Text(
                        'Select Breathing Seconds',
                        style: bodyStyle,
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.background,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.onSurface)),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        // height: MediaQuery.of(context).size.height * 0.28,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    'Inhale (2-6)',
                                    textAlign: TextAlign.left,
                                    style: sliderText,
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      valueIndicatorColor:
                                          themeModel.secondaryColor2,
                                    ),
                                    child: Slider(
                                        value: inhaleSeconds,
                                        label: inhaleSeconds.round().toString(),
                                        min: 2,
                                        max: 6,
                                        activeColor: themeModel.secondaryColor2,
                                        inactiveColor: themeModel
                                            .secondaryColor2
                                            .withOpacity(0.4),
                                        divisions: 4,
                                        onChanged: (newValue) {
                                          inhaleSeconds = newValue;
                                          setState(() {});
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Hold (0-8)  ',
                                    style: sliderText,
                                  ),
                                  flex: 3,
                                ),
                                Flexible(
                                  flex: 7,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      valueIndicatorColor:
                                          themeModel.secondaryColor2,
                                    ),
                                    child: Slider(
                                        value: holdSeconds,
                                        label: holdSeconds.round().toString(),
                                        min: 0,
                                        max: 8,
                                        activeColor: themeModel.secondaryColor2,
                                        inactiveColor: themeModel
                                            .secondaryColor2
                                            .withOpacity(0.4),
                                        divisions: 8,
                                        onChanged: (newValue) {
                                          holdSeconds = newValue;
                                          setState(() {});
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    'Exhale (4-8)',
                                    style: sliderText,
                                  ),
                                ),
                                Flexible(
                                  flex: 7,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      valueIndicatorColor:
                                          themeModel.secondaryColor2,
                                    ),
                                    child: Slider(
                                        value: exhaleSeconds,
                                        label: exhaleSeconds.round().toString(),
                                        min: 4,
                                        max: 8,
                                        activeColor: themeModel.secondaryColor2,
                                        inactiveColor: themeModel
                                            .secondaryColor2
                                            .withOpacity(0.4),
                                        divisions: 4,
                                        onChanged: (newValue) {
                                          exhaleSeconds = newValue;
                                          setState(() {});
                                        }),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              activeColor: themeModel.secondaryColor2,
                              checkColor: themeModel.backgroundColor,
                              value: addSession,
                              onChanged: ((value) {
                                setState(() {
                                  addSession = value!;
                                });
                              })),
                          Text(
                            'Want to save in sessions?',
                            style: sliderText,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          if (addSession) {
                            await _showBox(context);
                            data.set({
                              'id': data.id,
                              'name': _sessionNameController.text != ""
                                  ? _sessionNameController.text
                                  : "My Session",
                              'duration': value,
                              'repeatTimes': repeatValue,
                              'inhaleSeconds': inhaleSeconds,
                              'holdSeconds': holdSeconds,
                              'exhaleSeconds': exhaleSeconds
                            });
                          }
                          widget.updateSessionData();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AudioPage(
                              duration: value,
                              repeatTimes: repeatValue,
                              inhaleSeconds: inhaleSeconds,
                              holdSeconds: holdSeconds,
                              exhaleSeconds: exhaleSeconds,
                            ),
                          ));
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            gradient: rightToLeftGradient(model),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
