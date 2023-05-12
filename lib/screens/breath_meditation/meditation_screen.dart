import 'package:dhyanin_app/screens/breath_meditation/audio_page_screen.dart';
import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/utils/styles.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Meditation extends StatefulWidget {
  const Meditation({super.key});

  @override
  State<Meditation> createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  int value = 0; //index value of by default duration
  int repeatValue = 0; //to repeat meditation
  double inhaleSeconds = 2;
  double holdSeconds = 0;
  double exhaleSeconds = 4;

  //Custom radio button widget for duration
  Widget customRadioButton(String text, int index) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return OutlinedButton(
      onPressed: () {
        setState(() {
          value = index;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: (value == index)
            ? model.primaryColor
            : Theme.of(context).colorScheme.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(
            color: (value == index)
                ? model.primaryColor
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
    );
  }

  //Custom radio button widget for duration
  Widget customRadioButtonRepeat(String text, int index) {
    ColorsThemeNotifier model =
        Provider.of<ColorsThemeNotifier>(context, listen: true);
    return OutlinedButton(
      onPressed: () {
        setState(() {
          repeatValue = index;
        });
      },
      style: OutlinedButton.styleFrom(
          backgroundColor: (repeatValue == index)
              ? model.primaryColor
              : Theme.of(context).colorScheme.background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          side: BorderSide(
            color: (repeatValue == index)
                ? model.primaryColor
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Dhyanin'),
      body: Consumer<ColorsThemeNotifier>(
        builder: (context, themeModel, child) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 5.0, bottom: 10.0),
                  child: Text(
                    'Select Duration (per cycle)',
                    style: bodyStyle,
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
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                  child: Text(
                    'Select Repeat Cycle',
                    style: bodyStyle,
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
                      ),
                      customRadioButtonRepeat('4 times', 3),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      customRadioButtonRepeat('5 times', 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                  child: Text(
                    'Select Breathing Seconds',
                    style: bodyStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Card(
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
                                        themeModel.primaryColor,
                                  ),
                                  child: Slider(
                                      value: inhaleSeconds,
                                      label: inhaleSeconds.round().toString(),
                                      min: 2,
                                      max: 6,
                                      activeColor: themeModel.primaryColor,
                                      inactiveColor: themeModel.primaryColor
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
                                        themeModel.primaryColor,
                                  ),
                                  child: Slider(
                                      value: holdSeconds,
                                      label: holdSeconds.round().toString(),
                                      min: 0,
                                      max: 8,
                                      activeColor: themeModel.primaryColor,
                                      inactiveColor: themeModel.primaryColor
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
                                        themeModel.primaryColor,
                                  ),
                                  child: Slider(
                                      value: exhaleSeconds,
                                      label: exhaleSeconds.round().toString(),
                                      min: 4,
                                      max: 8,
                                      activeColor: themeModel.primaryColor,
                                      inactiveColor: themeModel.primaryColor
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
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: themeModel.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            )),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AudioPage(
                              indexOfAudio: value,
                              repeatTimes: repeatValue,
                              inhaleSeconds: inhaleSeconds,
                              holdSeconds: holdSeconds,
                              exhaleSeconds: exhaleSeconds,
                            ),
                          ));
                        },
                        icon: Icon(
                          Icons.play_arrow,
                          size: 30,
                        ),
                        label: Text(
                          'Start',
                          style: const TextStyle(
                              fontSize: 25, color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
