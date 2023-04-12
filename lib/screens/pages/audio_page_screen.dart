import 'package:audioplayers/audioplayers.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

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

  AudioPlayer audioPlayer = AudioPlayer();

  void initPlayer() async {
    if (widget.indexOfAudio == 0) {
      await audioPlayer.setSourceUrl(Breath5min);
    } else if (widget.indexOfAudio == 1) {
      await audioPlayer.setSourceUrl(Breath10min);
    } else if (widget.indexOfAudio == 2) {
      await audioPlayer.setSourceUrl(Breath15min);
    } else if (widget.indexOfAudio == 3) {
      await audioPlayer.setSourceUrl(Breath20min);
    } else {
      await audioPlayer.setSourceUrl(Breath30min);
    }
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
      setState(() {
        timesPlayed++;
      });
      if (timesPlayed <= int.parse(widget.repeatTimes.toString())) {
        if (widget.indexOfAudio == 0) {
          audioPlayer.play(UrlSource(Breath5min));
        } else if (widget.indexOfAudio == 1) {
          audioPlayer.play(UrlSource(Breath10min));
        } else if (widget.indexOfAudio == 2) {
          audioPlayer.play(UrlSource(Breath15min));
        } else if (widget.indexOfAudio == 3) {
          audioPlayer.play(UrlSource(Breath20min));
        } else {
          audioPlayer.play(UrlSource(Breath30min));
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                        height: size,
                        width: size,
                        child: Material(
                          borderRadius: BorderRadius.circular(100.0),
                          color: primary_color,
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    breathMessage,
                    style: textStyle_body,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 5,
              child: Column(
                children: [
                  Slider(
                      activeColor: primary_color,
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) {}),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration - position)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: primary_color,
                    child: IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      iconSize: 50,
                      onPressed: () async {
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      },
                    ),
                  )
                ],
              ),
            )
          ],
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
