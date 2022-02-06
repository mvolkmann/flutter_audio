import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import './audio_asset_player.dart';

// This code is derived from the YouTube video at
// https://www.youtube.com/watch?v=xyooeKm0xw8.
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
  static const filePath = 'audio/ear_teebs_2.wav';
  static const iconSize = 50.0;

  final player = AudioAssetPlayer(filePath);

  late final Future<void> initFuture;

  var progress = 0.0;
  var state = PlayerState.STOPPED;

  @override
  void initState() {
    setup();
    super.initState();
  }

  void setup() async {
    initFuture = player.init();
    await initFuture;
    player.progressStream.listen((p) {
      setState(() => progress = p);
    });
    player.stateStream.listen((s) {
      setState(() => state = s);
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Demo'),
      ),
      body: Center(
        child: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Text('Loading ...');
            }

            return Card(
              elevation: 3,
              child: Column(
                children: [
                  Text(
                    player.filePath,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPlayButton(),
                      _buildPauseButton(),
                      _buildStopButton(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: LinearProgressIndicator(value: progress),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPauseButton() {
    var paused = state != PlayerState.PLAYING;
    return IconButton(
      icon: Icon(
        Icons.pause,
        color: paused ? Colors.grey : Colors.orange,
        size: iconSize,
      ),
      onPressed: paused ? null : player.pause,
    );
  }

  Widget _buildPlayButton() {
    var playing = state == PlayerState.PLAYING;
    return IconButton(
      icon: Icon(
        Icons.play_arrow,
        color: playing ? Colors.green : Colors.grey,
        size: iconSize,
      ),
      onPressed: playing ? null : player.play,
    );
  }

  Widget _buildStopButton() {
    var stopped = state == PlayerState.STOPPED;
    return IconButton(
      icon: Icon(
        Icons.stop,
        color: stopped ? Colors.grey : Colors.red,
        size: iconSize,
      ),
      onPressed: stopped ? null : player.reset,
    );
  }
}
