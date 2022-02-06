import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' show PlayerState;
import './audio_asset_player.dart';

// This code is derived from the YouTube video at
// https://www.youtube.com/watch?v=xyooeKm0xw8.
class AudioPlayerWidget extends StatefulWidget {
  final String filePath;

  const AudioPlayerWidget(this.filePath, {Key? key}) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  static const iconSize = 50.0;

  late final AudioAssetPlayer player;

  late final Future<void> initFuture;

  var progress = 0.0;
  var state = PlayerState.STOPPED;

  @override
  void initState() {
    super.initState();
    player = AudioAssetPlayer(widget.filePath);
    setup();
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
    return FutureBuilder(
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
                style: Theme.of(context).textTheme.headline5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayButton(),
                  _buildStopButton(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: LinearProgressIndicator(value: progress),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    var playing = state == PlayerState.PLAYING;
    return IconButton(
      icon: Icon(
        playing ? Icons.pause : Icons.play_arrow,
        color: playing ? Colors.orange : Colors.green,
        size: iconSize,
      ),
      onPressed: playing ? player.pause : player.play,
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
