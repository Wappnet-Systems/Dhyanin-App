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

class _AudioPageState extends State<AudioPage> {
  bool isPlaying = false; //Audio play or pause status
  Duration duration = Duration.zero; //Total duration of the audio
  Duration position = Duration.zero; //Current position of the audio
  int timesPlayed = 0; //audio completed this times

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
    super.initState();
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
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Lottie.asset(
                  'assets/lottie/audio.json',
                  width: double.infinity,
                  height: 350,
                ),
              ),
            ),
            const Text(
              "Meditation Audio",
              style: textStyle_body,
            ),
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
