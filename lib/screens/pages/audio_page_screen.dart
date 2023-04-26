import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dhyanin_app/screens/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/screens/widgets/custom_snackbar.dart';
import 'package:dhyanin_app/screens/widgets/get_duration.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class AudioPage extends StatefulWidget {
  final int? indexOfAudio;
  final int? repeatTimes;
  const AudioPage(
      {super.key, required this.indexOfAudio, required this.repeatTimes});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  bool isPlaying = false; //Audio play or pause status
  Duration duration = Duration.zero; //Total duration of the audio
  Duration position = Duration.zero; //Current position of the audio
  int timesPlayed = 0; //audio completed this times
  late AnimationController _breathingController;
  String breathMessage = "Inhale";
  var _breath = 0.0;
  late int meditationMinutes;
  late int remainingMeditationMinutes;
  int selectedAudio = 1;
  Duration currPosition = Duration.zero;
  bool _enabled = true;
  String backgroundImage = 'assets/images/background/background_image_1.jpg';
  int imageIndex = 1;
  int completedMeditationMinutes = 0;
  AudioPlayer audioPlayer = AudioPlayer();

  void initPlayer() async {
    if (widget.indexOfAudio == 0) {
      meditationMinutes = 5;
      remainingMeditationMinutes = 5;
    } else if (widget.indexOfAudio == 1) {
      meditationMinutes = 10;
      remainingMeditationMinutes = 10;
    } else if (widget.indexOfAudio == 2) {
      meditationMinutes = 15;
      remainingMeditationMinutes = 15;
    } else if (widget.indexOfAudio == 3) {
      meditationMinutes = 20;
      remainingMeditationMinutes = 20;
    } else {
      meditationMinutes = 30;
      remainingMeditationMinutes = 30;
    }
    audioPlayer.play(AssetSource(audio1));
    duration = (await audioPlayer.getDuration())!;
  }

  @override
  void initState() {
    _breathingController =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _breathingController.reverse();
        breathMessage = "Exhale";
      } else if (status == AnimationStatus.dismissed) {
        _breathingController.forward();
        breathMessage = "Inhale";
      }
    });
    _breathingController.addListener(() {
      setState(() {
        _breath = _breathingController.value;
      });
    });
    _breathingController.forward();
    initPlayer();
    //Listen to states: playing, pausing, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      try {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      } catch (e) {
        print(e);
      }
    });

    //Listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    //Listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      if (position.inSeconds > 58) {
        print('oncomplete event fired');
        setState(() {
          currPosition += Duration(seconds: 60);
          position = Duration.zero;
          completedMeditationMinutes++;
        });
        String audiopath = audio1;
        switch (selectedAudio) {
          case 1:
            {
              audiopath = audio1;
            }
            break;
          case 2:
            {
              audiopath = audio2;
            }
            break;
          case 3:
            {
              audiopath = audio3;
            }
            break;
          case 4:
            {
              audiopath = audio4;
            }
            break;
          case 5:
            {
              audiopath = audio5;
            }
            break;
        }

        if (timesPlayed <= int.parse(widget.repeatTimes.toString()) &&
            remainingMeditationMinutes > 1) {
          remainingMeditationMinutes--;
          audioPlayer.play(AssetSource(audiopath), position: Duration.zero);
        } else {
          setState(() {
            timesPlayed++;
            completedMeditationMinutes = 0;
          });
          if (timesPlayed <= int.parse(widget.repeatTimes.toString())) {
            audioPlayer.play(AssetSource(audiopath), position: Duration.zero);
            remainingMeditationMinutes = meditationMinutes;
            currPosition = Duration.zero;
          }
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _breathingController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 30.0 + 180.0 * _breath;
    return Scaffold(
      backgroundColor: background_color,
      appBar: const CustomAppBar(title: 'Breath Meditation'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height * .87,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImage),
                      colorFilter: const ColorFilter.mode(
                          Color(0xFFFFFFFF), BlendMode.dstATop),
                      opacity: 1,
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2.3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                  height: duration != Duration.zero
                                      ? (widget.repeatTimes! +
                                                  1 -
                                                  timesPlayed) !=
                                              0
                                          ? size
                                          : 200
                                      : 200,
                                  width: duration != Duration.zero
                                      ? (widget.repeatTimes! +
                                                  1 -
                                                  timesPlayed) !=
                                              0
                                          ? size
                                          : 200
                                      : 200,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(100.0),
                                    color: const Color(0xFFEF65C8)
                                        .withOpacity(0.8),
                                  )),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            duration != Duration.zero
                                ? (widget.repeatTimes! + 1 - timesPlayed) != 0
                                    ? Text(
                                        breathMessage,
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.black),
                                      )
                                    : const Text(
                                        'Successfully Completed!',
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xFF000000)),
                                      )
                                : const Text(
                                    'Loading...',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularStepProgressIndicator(
                              totalSteps: meditationMinutes,
                              currentStep: completedMeditationMinutes,
                              selectedColor: primary_color.withOpacity(0.8),
                              unselectedColor: primary_color.withOpacity(0.2),
                              child: Center(
                                child: Text(
                                  formatTime(currPosition + position),
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            // Text(
                            //   '${formatTime(currPosition + position)} || ',
                            //   style: const TextStyle(fontSize: 18),
                            // ),
                            // meditationMinutes == 5
                            //     ? const Text(
                            //         '0',
                            //         style: TextStyle(fontSize: 18),
                            //       )
                            //     : const Text(''),
                            // Text(
                            //   '${meditationMinutes.toString()}' ':00',
                            //   style: const TextStyle(fontSize: 18),
                            // )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 6,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  Color(0xFFEF65C8).withOpacity(0.8),
                              child: IconButton(
                                icon: Icon(Icons.audiotrack),
                                iconSize: 50,
                                onPressed: () async {
                                  if (isPlaying && _enabled) {
                                    setState(() {
                                      if (selectedAudio < 5) {
                                        selectedAudio++;
                                      } else {
                                        selectedAudio = 1;
                                      }
                                      _enabled = false;
                                    });
                                    Timer(Duration(seconds: 10),
                                        () => setState(() => _enabled = true));

                                    Duration currentPositionOfAudio = position;

                                    audioPlayer.pause();
                                    audioPlayer.release();

                                    switch (selectedAudio) {
                                      case 1:
                                        {
                                          audioPlayer.play(AssetSource(audio1),
                                              position: Duration(
                                                  seconds:
                                                      currentPositionOfAudio
                                                          .inSeconds));
                                          CustomSnackbar.functionSnackbar(
                                              context,
                                              "Audio Changed to Forest Sounds");
                                        }
                                        break;
                                      case 2:
                                        {
                                          audioPlayer.play(AssetSource(audio2),
                                              position: Duration(
                                                  seconds:
                                                      currentPositionOfAudio
                                                          .inSeconds));
                                          CustomSnackbar.functionSnackbar(
                                              context,
                                              "Audio Changed to Waves Voice");
                                        }
                                        break;
                                      case 3:
                                        {
                                          audioPlayer.play(AssetSource(audio3),
                                              position: Duration(
                                                  seconds:
                                                      currentPositionOfAudio
                                                          .inSeconds));

                                          CustomSnackbar.functionSnackbar(
                                              context,
                                              "Audio Changed to Stress Relief Music");
                                        }
                                        break;
                                      case 4:
                                        {
                                          audioPlayer.play(AssetSource(audio4),
                                              position: Duration(
                                                  seconds:
                                                      currentPositionOfAudio
                                                          .inSeconds));

                                          CustomSnackbar.functionSnackbar(
                                              context,
                                              "Audio Changed to Focus Voice");
                                        }
                                        break;
                                      case 5:
                                        {
                                          audioPlayer.play(AssetSource(audio5),
                                              position: Duration(
                                                  seconds:
                                                      currentPositionOfAudio
                                                          .inSeconds));
                                          CustomSnackbar.functionSnackbar(
                                              context,
                                              "Audio Changed to Flute Meditation Voice");
                                        }
                                        break;
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  const Color.fromARGB(255, 239, 101, 200)
                                      .withOpacity(0.8),
                              child: IconButton(
                                icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow),
                                iconSize: 50,
                                onPressed: () async {
                                  if ((widget.repeatTimes! + 1 - timesPlayed) !=
                                      0) {
                                    if (isPlaying) {
                                      _breathingController.stop();
                                      await audioPlayer.pause();
                                    } else {
                                      _breathingController.forward();
                                      await audioPlayer.resume();
                                    }
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            CircleAvatar(
                              radius: 35,
                              backgroundColor:
                                  const Color.fromARGB(255, 239, 101, 200)
                                      .withOpacity(0.8),
                              child: IconButton(
                                icon: Icon(Icons.image),
                                iconSize: 50,
                                onPressed: () async {
                                  imageIndex < 7
                                      ? imageIndex++
                                      : imageIndex = 1;
                                  backgroundImage =
                                      'assets/images/background/background_image_$imageIndex.jpg';
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularStepProgressIndicator(
                                  totalSteps: widget.repeatTimes! + 1,
                                  currentStep: timesPlayed,
                                  selectedColor: primary_color.withOpacity(0.8),
                                  unselectedColor:
                                      primary_color.withOpacity(0.2),
                                  // child: Center(
                                  //   child: Text(
                                  //     "Cycles",
                                  //     style: const TextStyle(fontSize: 18),
                                  //   ),
                                  // )
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Text(
                                '${(widget.repeatTimes! + 1).toString()} Cycles',
                                // (widget.repeatTimes! + 1 - timesPlayed)
                                //         .toString() +
                                //     ' out of ' +
                                //     (widget.repeatTimes! + 1).toString() +
                                //     ' cycles remaining',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String time = "$minutes:$seconds";
    return time;
  }
}
