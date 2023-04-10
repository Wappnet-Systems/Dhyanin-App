import 'package:audioplayers/audioplayers.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AudioPage extends StatefulWidget {
  final int? indexOfAudio;
  const AudioPage({super.key, required this.indexOfAudio});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool isPlaying = false; //Audio play or pause status
  Duration duration = Duration.zero; //Total duration of the audio
  Duration position = Duration.zero; //Current position of the audio

  AudioPlayer audioPlayer = AudioPlayer();

  // https://www.mcgill.ca/wellness-hub/files/wellness-hub/breathing_meditation_0.mp3 //for 5 minutes

  void initPlayer() async {
    if (widget.indexOfAudio == 0) {
      await audioPlayer.setSourceUrl(
          "https://firebasestorage.googleapis.com/v0/b/dhyanin-622d7.appspot.com/o/breath_5min.mp3?alt=media&token=3338c37f-7eec-40ff-8699-6de94a8032a0");
    } else if (widget.indexOfAudio == 1) {
      await audioPlayer.setSourceUrl(
          "https://firebasestorage.googleapis.com/v0/b/dhyanin-622d7.appspot.com/o/breath_10min.mp3?alt=media&token=9eed7fc2-e5f0-45c8-bf3d-7427d0d3ce12");
    } else if (widget.indexOfAudio == 2) {
      await audioPlayer.setSourceUrl(
          "https://firebasestorage.googleapis.com/v0/b/dhyanin-622d7.appspot.com/o/breath_15min.mp3?alt=media&token=642f82ea-4ee8-4450-a3a9-d9a70f99dc83");
    } else if (widget.indexOfAudio == 3) {
      await audioPlayer.setSourceUrl(
          "https://firebasestorage.googleapis.com/v0/b/dhyanin-622d7.appspot.com/o/breath_20min.mp3?alt=media&token=f0c3bee2-2a50-447e-81a6-654e81b5abfd");
    } else {
      await audioPlayer.setSourceUrl(
          "https://firebasestorage.googleapis.com/v0/b/dhyanin-622d7.appspot.com/o/breath_30min.mp3?alt=media&token=85951b66-e7b6-493a-ac15-5d126b99448b");
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
