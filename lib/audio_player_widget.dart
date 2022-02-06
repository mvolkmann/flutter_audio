import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' show PlayerState;
import './audio_asset_player.dart';
import './extensions/widget_extensions.dart';

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

  @override
  void dispose() {
    player.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initFuture,
      builder: (context, snapshot) {
        // Initially snapshot.connectionState is ConnectionState.waiting.
        if (snapshot.connectionState != ConnectionState.done) {
          return Text('Loading ...');
        }

        return Card(
          color: Colors.yellow[100],
          elevation: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player.filePath,
                style: Theme.of(context).textTheme.headline6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildPlayButton(),
                  _buildStopButton(),
                ],
              ),
              LinearProgressIndicator(value: progress),
            ],
          ).padding(10),
        );
      },
    );
  }

  Widget _buildButton({
    required Color color,
    required IconData icon,
    required VoidCallback? onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: iconSize),
      onPressed: onPressed,
      padding: const EdgeInsets.all(0),
    );
  }

  Widget _buildPlayButton() {
    var playing = state == PlayerState.PLAYING;
    return _buildButton(
      color: playing ? Colors.orange : Colors.green,
      icon: playing ? Icons.pause : Icons.play_arrow,
      onPressed: playing ? player.pause : player.play,
    );
  }

  Widget _buildStopButton() {
    var stopped = state == PlayerState.STOPPED;
    return _buildButton(
      color: stopped ? Colors.grey : Colors.red,
      icon: Icons.stop,
      onPressed: stopped ? null : player.reset,
    );
  }
}
