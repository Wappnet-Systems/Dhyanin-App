import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhyanin_app/services/providers/colors_theme_provider.dart';
import 'package:dhyanin_app/utils/images.dart';
import 'package:dhyanin_app/widgets/custom_app_bar.dart';
import 'package:dhyanin_app/widgets/breath_meditation/custom_audio_screen_icon.dart';
import 'package:dhyanin_app/widgets/custom_snackbar.dart';
import 'package:dhyanin_app/widgets/breath_meditation/default_image_background.dart';
import 'package:dhyanin_app/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../services/controller/meditation_history_controller.dart';
import '../../services/models/meditation_history_model.dart';
import '../../widgets/list_drawer.dart';

String fileBackgroundImage = "";

class AudioPage extends StatefulWidget {
  final int? duration;
  final int? repeatTimes;
  final double inhaleSeconds;
  final double holdSeconds;
  final double exhaleSeconds;
  const AudioPage(
      {super.key,
      required this.duration,
      required this.repeatTimes,
      required this.inhaleSeconds,
      required this.holdSeconds,
      required this.exhaleSeconds});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  bool isPlaying = false; //Audio play or pause status
  Duration duration = Duration.zero; //Total duration of the audio
  Duration position = Duration.zero; //Current position of the audio
  int timesPlayed = 0; //audio completed this many times
  late AnimationController _breathingController; //animation for breathing
  String breathMessage = "Inhale"; //message for guide(inhale,exhale)
  var _breath = 0.0; //start position for animation
  int meditationMinutes = 5; //total meditation minutes for one cycle
  int remainingMeditationMinutes = 5; //remaining meditation minutes
  int selectedAudio = 1; //will be changed by user later for audio change
  Duration currPosition = Duration.zero;
  bool _enabled = true; //to disable audiochange button for some time
  String backgroundImage = backgroundImage1; //default image for background
  int imageIndex = 1; //will be changed by user later for background change
  int completedMeditationMinutes = 0; //completed meditation minutes
  bool isFileImage = false; //if user selects images from gallary
  AudioPlayer audioPlayer = AudioPlayer();
  MeditationHistoryController historyController = MeditationHistoryController();
  List<MeditationHistory> listHistory = [];

  void initPlayer() async {
    meditationMinutes = widget.duration!;
    remainingMeditationMinutes = widget.duration!;
    audioPlayer.play(AssetSource(audio1));
    duration = (await audioPlayer.getDuration())!;
  }

  @override
  void initState() {
    _breathingController = AnimationController(
        vsync: this,
        duration: Duration(seconds: widget.inhaleSeconds.toInt()),
        reverseDuration: Duration(seconds: widget.exhaleSeconds.toInt()));
    _breathingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.holdSeconds > 0) {
          _breathingController.stop();
          breathMessage = "Hold Your Breath";
        }
        Future.delayed(Duration(seconds: widget.holdSeconds.toInt()), () {
          if (mounted && isPlaying) {
            _breathingController.reverse();
            breathMessage = "Exhale";
          }
        });
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
          });
          if (timesPlayed < int.parse(widget.repeatTimes.toString())) {
            audioPlayer.play(AssetSource(audiopath), position: Duration.zero);
            remainingMeditationMinutes = meditationMinutes;
            completedMeditationMinutes = 0;
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
    if ((widget.repeatTimes! - timesPlayed) == 0) {
      addMeditationInHistory();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 30.0 + 180.0 * _breath;
    return Scaffold(
      appBar: const CustomAppBar(title: 'Breath Meditation'),
      body: Consumer<ColorsThemeNotifier>(
        builder: (context, themeModel, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SafeArea(
            child: SingleChildScrollView(
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
                          image: isFileImage
                              ? FileImage(File(backgroundImage))
                                  as ImageProvider<Object>
                              : AssetImage(backgroundImage),
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
                            height: MediaQuery.of(context).size.height / 2.4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                      height: duration != Duration.zero
                                          ? (widget.repeatTimes! -
                                                      timesPlayed) !=
                                                  0
                                              ? size
                                              : 200
                                          : 200,
                                      width: duration != Duration.zero
                                          ? (widget.repeatTimes! -
                                                      timesPlayed) !=
                                                  0
                                              ? size
                                              : 200
                                          : 200,
                                      child: Material(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: themeModel.primaryColor
                                            .withOpacity(0.6),
                                      )),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                duration != Duration.zero
                                    ? (widget.repeatTimes! - timesPlayed) != 0
                                        ? Text(
                                            breathMessage,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                color: Colors.black),
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
                                  selectedColor:
                                      themeModel.primaryColor.withOpacity(0.8),
                                  unselectedColor:
                                      themeModel.primaryColor.withOpacity(0.2),
                                  child: Center(
                                    child: Text(
                                      formatTime(currPosition + position),
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AudioIcon(
                                    icon: Icon(
                                      Icons.audiotrack,
                                      color: Colors.white,
                                    ),
                                    onPress: onPressEventAudio),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                AudioIcon(
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPress: () async {
                                      if ((widget.repeatTimes! - timesPlayed) !=
                                          0) {
                                        if (isPlaying) {
                                          _breathingController.stop();
                                          await audioPlayer.pause();
                                        } else {
                                          if (breathMessage == 'Inhale') {
                                            _breathingController.forward();
                                          } else {
                                            _breathingController.reverse();
                                          }
                                          await audioPlayer.resume();
                                        }
                                      }
                                    }),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                AudioIcon(
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                    onPress: () async {
                                      _breathingController.stop();
                                      audioPlayer.pause();
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  DefaultImage(
                                                    imagePath: backgroundImage1,
                                                    ontap: () {
                                                      isFileImage = false;
                                                      backgroundImage =
                                                          backgroundImage1;
                                                      resume();
                                                    },
                                                  ),
                                                  DefaultImage(
                                                    imagePath: backgroundImage2,
                                                    ontap: () {
                                                      isFileImage = false;

                                                      backgroundImage =
                                                          backgroundImage2;
                                                      resume();
                                                    },
                                                  ),
                                                  DefaultImage(
                                                    imagePath: backgroundImage3,
                                                    ontap: () {
                                                      isFileImage = false;

                                                      backgroundImage =
                                                          backgroundImage3;
                                                      resume();
                                                    },
                                                  ),
                                                  DefaultImage(
                                                    imagePath: backgroundImage4,
                                                    ontap: () {
                                                      isFileImage = false;

                                                      backgroundImage =
                                                          backgroundImage4;
                                                      resume();
                                                    },
                                                  ),
                                                  DefaultImage(
                                                    imagePath: backgroundImage5,
                                                    ontap: () {
                                                      isFileImage = false;

                                                      backgroundImage =
                                                          backgroundImage5;
                                                      resume();
                                                    },
                                                  ),
                                                  DefaultImage(
                                                    imagePath: backgroundImage6,
                                                    ontap: () {
                                                      isFileImage = false;

                                                      backgroundImage =
                                                          backgroundImage6;
                                                      audioPlayer.resume();
                                                      resume();
                                                    },
                                                  ),
                                                  DefaultImage(
                                                    imagePath: backgroundImage7,
                                                    ontap: () {
                                                      isFileImage = false;

                                                      backgroundImage =
                                                          backgroundImage7;
                                                      resume();
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.2,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            savedImagePaths
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                isFileImage =
                                                                    true;
                                                                backgroundImage =
                                                                    savedImagePaths[
                                                                        index];
                                                                resume();
                                                              },
                                                              child: Image.file(File(
                                                                  savedImagePaths[
                                                                      index])),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    }),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 5.0, top: 15.0),
                            child: Expanded(
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CircularStepProgressIndicator(
                                          totalSteps: widget.repeatTimes!,
                                          currentStep: timesPlayed,
                                          selectedColor: themeModel.primaryColor
                                              .withOpacity(0.8),
                                          unselectedColor: themeModel
                                              .primaryColor
                                              .withOpacity(0.2),
                                          child: Center(
                                            child: Text(
                                              timesPlayed.toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    Text(
                                      'Completed Cycles',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
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
        ),
      ),
    );
  }

  void resume() {
    if (breathMessage == 'Inhale') {
      _breathingController.forward();
    } else {
      _breathingController.reverse();
    }
    Navigator.of(context).pop();
    audioPlayer.resume();
  }

  //format time to keep track of completed cycles and add into currPosition
  String formatTime(Duration duration) {
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    String time = "$minutes:$seconds";
    return time;
  }

  //function to change audio
  Future<Function?> onPressEventAudio() async {
    if (isPlaying && _enabled) {
      setState(() {
        if (selectedAudio < 5) {
          selectedAudio++;
        } else {
          selectedAudio = 1;
        }
        _enabled = false;
      });
      Timer(Duration(seconds: 10), () {
        if (mounted) {
          setState(() => _enabled = true);
        }
      });

      Duration currentPositionOfAudio = position;

      audioPlayer.pause();
      audioPlayer.release();

      switch (selectedAudio) {
        case 1:
          {
            audioPlayer.play(AssetSource(audio1),
                position: Duration(seconds: currentPositionOfAudio.inSeconds));
            CustomSnackbar.functionSnackbar(
                context, "Audio Changed to Forest Sounds");
          }
          break;
        case 2:
          {
            audioPlayer.play(AssetSource(audio2),
                position: Duration(seconds: currentPositionOfAudio.inSeconds));
            CustomSnackbar.functionSnackbar(
                context, "Audio Changed to Waves Voice");
          }
          break;
        case 3:
          {
            audioPlayer.play(AssetSource(audio3),
                position: Duration(seconds: currentPositionOfAudio.inSeconds));

            CustomSnackbar.functionSnackbar(
                context, "Audio Changed to Stress Relief Music");
          }
          break;
        case 4:
          {
            audioPlayer.play(AssetSource(audio4),
                position: Duration(seconds: currentPositionOfAudio.inSeconds));

            CustomSnackbar.functionSnackbar(
                context, "Audio Changed to Focus Voice");
          }
          break;
        case 5:
          {
            audioPlayer.play(AssetSource(audio5),
                position: Duration(seconds: currentPositionOfAudio.inSeconds));
            CustomSnackbar.functionSnackbar(
                context, "Audio Changed to Flute Meditation Voice");
          }
          break;
      }
    }
    return null;
  }

  addMeditationInHistory() async {
    try {
      var documentReference = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("meditationHistory")
          .doc();
      await documentReference.set({
        'dateTime': DateTime.now(),
        'duration': meditationMinutes,
        'repeatTimes': widget.repeatTimes
      });
    } catch (e) {
      print(e);
    }
  }
}
