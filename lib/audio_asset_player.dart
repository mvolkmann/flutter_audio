import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

// This class provides a simplifying layer over the audioplayers library.
class AudioAssetPlayer {
  final String filePath; // after "assets/"
  final _controller = StreamController<double>();

  late final AudioPlayer _player;
  late final StreamSubscription _subscription;
  late final int _durationMs;

  Stream<double> get progressStream => _controller.stream;
  Stream<PlayerState> get stateStream => _player.onPlayerStateChanged;

  AudioAssetPlayer(this.filePath);

  Future<void> sleep(int ms) => Future.delayed(Duration(milliseconds: ms));

  Future<void> init() async {
    // We need to play the file in order to get its duration.
    _player = await AudioCache().play(filePath);

    _player.onDurationChanged.listen((Duration duration) {
      // Now that we have the duration, stop the player.
      _player.stop();

      _durationMs = duration.inMilliseconds;
      _controller.add(0.0);
      _subscription = _player.onAudioPositionChanged.listen((duration) {
        _controller.add(duration.inMilliseconds / _durationMs);
      });
    });
  }

  // The three methods calls passed in a List to the wait method
  // all return a Future.  This waits for all of them to complete.
  Future<void> dispose() => Future.wait(
      [_player.dispose(), _subscription.cancel(), _controller.close()]);

  Future<void> play() => _player.resume();

  Future<void> pause() => _player.pause();

  Future<void> reset() async {
    await _player.stop();
    _controller.add(0.0);
  }
}
