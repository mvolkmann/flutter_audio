import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(
      MaterialApp(
        title: 'Audio Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static AudioCache cache = AudioCache();
  //static AudioPlayer player = AudioPlayer();
  static const filePath = 'audio/ear_teebs_2.wav';
  AudioPlayer? player;

  /*
  void playAudio() async {
    var result = await audioPlayer.play(
      'assets/audio/ear_teebs_2.wav',
      isLocal: true,
    );
    print('main.dart playLocal: result = $result');
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Demo'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Icon(Icons.play_arrow),
              //onPressed: () => player.loop(filePath),
              onPressed: () async {
                if (player != null) {
                  player!.resume();
                } else {
                  player = await cache.loop(filePath);
                }
              },
            ),
            ElevatedButton(
              child: Icon(Icons.pause),
              onPressed: () {
                if (player != null) player!.pause();
              },
            )
          ],
        ),
      ),
    );
  }
}
