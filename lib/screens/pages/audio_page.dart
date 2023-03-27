import 'package:audioplayers/audioplayers.dart';
import 'package:dhyanin_app/utils/colors.dart';
import 'package:dhyanin_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  bool isPlaying = false; //Audio play or pause status
  Duration duration = Duration.zero; //Total duration of the audio
  Duration position = Duration.zero; //Current position of the audio

  AudioPlayer audioPlayer = AudioPlayer();

  void initPlayer() async {
    await audioPlayer.setSource(AssetSource("3min_breath.mp3"));
    duration = (await audioPlayer.getDuration())!;
  }

  @override
  void initState() {
    super.initState();
    initPlayer();
    //Listen to states: playing, pausing, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
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
        duration = newPosition;
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
            Text(
              "The song",
              style: textStyle_body,
            ),
            Slider(
                activeColor: primary_color,
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                }),
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
