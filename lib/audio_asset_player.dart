import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

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
    // Need to play immediatedly in order to get duration.
    _player = await AudioCache().play(filePath);

    // Give audioplayers API time to get duration.
    await sleep(200);

    // The getDuration method returns int ms, not a Duration object.
    _durationMs = await _player.getDuration();

    // Now that we have the duration, stop the player.
    await _player.stop();

    _controller.add(0.0);

    //TODO: Does this work on iOS?
    _subscription = _player.onAudioPositionChanged.listen(
        (duration) => _controller.add(duration.inMilliseconds / _durationMs));
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
