import 'package:flutter/material.dart';
import './audio_player_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Demo'),
      ),
      body: Center(child: AudioPlayerWidget(filePath)),
    );
  }
}
