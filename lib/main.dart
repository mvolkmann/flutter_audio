import 'package:flutter/material.dart';
import './audio_player_widget.dart';
import './extensions/widget_extensions.dart';

void main() => runApp(
      MaterialApp(
        title: 'Audio Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home(),
      ),
    );

class Home extends StatelessWidget {
  static const filePath = 'audio/ear_teebs_2.wav';

  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Demo')),
      body: AudioPlayerWidget(filePath).padding(20),
    );
  }
}
