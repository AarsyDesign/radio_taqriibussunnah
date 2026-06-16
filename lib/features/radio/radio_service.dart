import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../core/app_config.dart';

class RadioService {
  RadioService({AudioPlayer? audioPlayer})
    : _audioPlayer = audioPlayer ?? AudioPlayer();

  final AudioPlayer _audioPlayer;
  bool _isAudioSessionConfigured = false;
  bool _isStreamReady = false;
  String? _currentStreamUrl;

  Stream<PlaybackEvent> get playbackEventStream =>
      _audioPlayer.playbackEventStream;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Future<void> configureAudioSession() async {
    if (_isAudioSessionConfigured) {
      return;
    }

    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _isAudioSessionConfigured = true;
  }

  Future<void> play({
    required String streamUrl,
    required String radioName,
    required String radioSubtitle,
    bool reloadStream = false,
  }) async {
    await configureAudioSession();

    final streamChanged = _currentStreamUrl != streamUrl;

    if ((reloadStream || streamChanged) && _isStreamReady) {
      await _audioPlayer.stop();
      _isStreamReady = false;
    }

    if (!_isStreamReady) {
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(streamUrl),
          tag: MediaItem(
            id: streamUrl,
            title: radioName,
            artist: radioSubtitle,
            album: AppConfig.notificationAlbum,
          ),
        ),
      );
      _currentStreamUrl = streamUrl;
      _isStreamReady = true;
    }

    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _isStreamReady = false;
    _currentStreamUrl = null;
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
