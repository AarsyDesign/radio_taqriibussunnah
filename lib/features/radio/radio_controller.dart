// ignore_for_file: prefer_initializing_formals

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/radio_config_provider.dart';
import '../../core/remote_radio_config.dart';
import '../../core/app_constants.dart';
import 'connectivity_service.dart';
import 'now_playing_model.dart';
import 'now_playing_service.dart';
import 'radio_service.dart';

enum RadioStatus {
  idle,
  loading,
  playing,
  paused,
  reconnecting,
  offline,
  error,
}

class RadioController extends ChangeNotifier {
  RadioController({
    required RadioConfigProvider configProvider,
    RadioService? radioService,
    ConnectivityService? connectivityService,
    NowPlayingService? nowPlayingService,
  }) : _configProvider = configProvider,
       _radioService = radioService ?? RadioService(),
       _connectivityService = connectivityService ?? ConnectivityService(),
       _nowPlayingService = nowPlayingService ?? NowPlayingService() {
    _configProvider.addListener(notifyListeners);
    _connectivitySubscription = _connectivityService.onConnectionChanged.listen(
      _handleConnectionChanged,
    );
    _playbackEventSubscription = _radioService.playbackEventStream.listen(
      (event) {
        if (_isDisposed) return;
        if (_userWantsToPlay) {
          if (event.processingState == ProcessingState.ready) {
            _retryAttempt = 0;
            _isReconnecting = false;
            _setStatus(RadioStatus.playing);
          } else if (event.processingState == ProcessingState.buffering ||
                     event.processingState == ProcessingState.loading) {
            _setStatus(RadioStatus.loading);
          }
        }
      },
      onError: (_) => _handleStreamError(),
    );
    unawaited(_checkInitialConnection());
    startNowPlayingPolling();
  }

  static const int _maxRetryAttempts = 5;
  static const Duration _nowPlayingPollingInterval = Duration(seconds: 20);

  final RadioConfigProvider _configProvider;
  final RadioService _radioService;
  final ConnectivityService _connectivityService;
  final NowPlayingService _nowPlayingService;

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<PlaybackEvent>? _playbackEventSubscription;
  Timer? _retryTimer;
  Timer? _nowPlayingTimer;

  RadioStatus _status = RadioStatus.idle;
  NowPlayingModel? _nowPlaying;
  bool _userWantsToPlay = false;
  bool _isReconnecting = false;
  bool _isLoadingNowPlaying = false;
  bool _isOnline = true;
  int _retryAttempt = 0;
  bool _isDisposed = false;

  RadioStatus get status => _status;

  RemoteRadioConfig get config => _configProvider.config;

  NowPlayingModel? get nowPlaying => _nowPlaying;

  bool get isLoadingNowPlaying => _isLoadingNowPlaying;

  bool get isPlaying => _status == RadioStatus.playing;

  bool get isLoading => _status == RadioStatus.loading;

  bool get isReconnecting => _isReconnecting;

  bool get userWantsToPlay => _userWantsToPlay;

  bool get canRetry =>
      _status == RadioStatus.error || _status == RadioStatus.offline;

  bool get shouldShowMiniPlayer => _status != RadioStatus.idle;

  String get statusMessage {
    return switch (_status) {
      RadioStatus.idle => AppConstants.readyStatus,
      RadioStatus.loading => AppConstants.connectingStatus,
      RadioStatus.playing => AppConstants.playingStatus,
      RadioStatus.paused => AppConstants.pausedStatus,
      RadioStatus.reconnecting => AppConstants.reconnectingStatus,
      RadioStatus.offline => AppConstants.offlineStatus,
      RadioStatus.error => AppConstants.errorStatus,
    };
  }

  Future<void> loadNowPlaying() async {
    if (_isLoadingNowPlaying) {
      return;
    }

    _isLoadingNowPlaying = true;
    notifyListeners();

    final result = await _nowPlayingService.fetchNowPlaying(
      url: config.nowPlayingUrl,
      fallbackName: config.radioName,
    );
    if (_isDisposed) {
      return;
    }

    _isLoadingNowPlaying = false;
    if (result != null) {
      _nowPlaying = result;
    }
    notifyListeners();
  }

  Future<void> refreshNowPlaying() {
    return loadNowPlaying();
  }

  void startNowPlayingPolling() {
    _nowPlayingTimer?.cancel();
    unawaited(loadNowPlaying());
    _nowPlayingTimer = Timer.periodic(
      _nowPlayingPollingInterval,
      (_) => unawaited(loadNowPlaying()),
    );
  }

  void stopNowPlayingPolling() {
    _nowPlayingTimer?.cancel();
    _nowPlayingTimer = null;
  }

  Future<void> togglePlay() async {
    if (_userWantsToPlay) {
      await _pause();
      return;
    }

    _userWantsToPlay = true;
    _retryAttempt = 0;
    await _play();
  }

  Future<void> stopPlayback() async {
    _userWantsToPlay = false;
    _retryAttempt = 0;
    _isReconnecting = false;
    _cancelRetryTimer();

    try {
      await _radioService.pause();
      _setStatus(RadioStatus.idle);
    } catch (_) {
      _setStatus(RadioStatus.idle);
    }
  }

  Future<void> retry() async {
    _cancelRetryTimer();
    _userWantsToPlay = true;
    _retryAttempt = 0;
    _isReconnecting = false;

    _isOnline = await _connectivityService.checkNow();
    if (!_isOnline) {
      _setStatus(RadioStatus.offline);
      return;
    }

    await _play();
  }

  Future<void> _checkInitialConnection() async {
    _isOnline = await _connectivityService.checkNow();
    if (!_isOnline) {
      _setStatus(RadioStatus.offline);
    }
  }

  Future<void> _play({bool isReconnect = false}) async {
    _cancelRetryTimer();

    if (!_isOnline) {
      _setStatus(RadioStatus.offline);
      return;
    }

    _isReconnecting = isReconnect;
    _setStatus(isReconnect ? RadioStatus.reconnecting : RadioStatus.loading);

    try {
      // Jangan await play() karena live stream akan memblokir hingga siaran putus.
      unawaited(_radioService.play(
        streamUrl: config.streamUrl,
        radioName: config.radioName,
        radioSubtitle: config.radioSubtitle,
        reloadStream: isReconnect,
      ).catchError((_) {
        if (!_isDisposed) {
          _isReconnecting = false;
          _handleStreamError();
        }
      }));
    } catch (_) {
      _isReconnecting = false;
      _handleStreamError();
    }
  }

  Future<void> _pause() async {
    _userWantsToPlay = false;
    _retryAttempt = 0;
    _isReconnecting = false;
    _cancelRetryTimer();

    try {
      await _radioService.pause();
      _setStatus(RadioStatus.paused);
    } catch (_) {
      _setStatus(RadioStatus.error);
    }
  }

  void _handleConnectionChanged(bool isOnline) {
    if (_isDisposed) {
      return;
    }

    final wasOffline = !_isOnline;
    _isOnline = isOnline;

    if (!isOnline) {
      _cancelRetryTimer();
      _setStatus(RadioStatus.offline);
      return;
    }

    if (!_userWantsToPlay) {
      if (_status == RadioStatus.offline) {
        _setStatus(RadioStatus.idle);
      }
      return;
    }

    if (wasOffline && !isPlaying) {
      _retryAttempt = 0;
      unawaited(_play(isReconnect: true));
    }
  }

  void _handleStreamError() {
    if (_isDisposed) {
      return;
    }

    if (!_userWantsToPlay) {
      _setStatus(RadioStatus.error);
      return;
    }

    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (!_isOnline) {
      _setStatus(RadioStatus.offline);
      return;
    }

    if (_retryTimer?.isActive ?? false) {
      return;
    }

    if (_retryAttempt >= _maxRetryAttempts) {
      _userWantsToPlay = false;
      _isReconnecting = false;
      _setStatus(RadioStatus.error);
      return;
    }

    _retryAttempt += 1;
    _isReconnecting = true;
    _setStatus(RadioStatus.reconnecting);

    _retryTimer = Timer(_retryDelayForAttempt(_retryAttempt), () {
      if (_isDisposed || !_userWantsToPlay) {
        return;
      }

      unawaited(_play(isReconnect: true));
    });
  }

  Duration _retryDelayForAttempt(int attempt) {
    return switch (attempt) {
      1 => const Duration(seconds: 3),
      2 => const Duration(seconds: 5),
      _ => const Duration(seconds: 10),
    };
  }

  void _cancelRetryTimer() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  void _setStatus(RadioStatus status) {
    if (_isDisposed || _status == status) {
      return;
    }

    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _configProvider.removeListener(notifyListeners);
    _cancelRetryTimer();
    stopNowPlayingPolling();
    unawaited(_connectivitySubscription?.cancel());
    unawaited(_playbackEventSubscription?.cancel());
    unawaited(_connectivityService.dispose());
    _nowPlayingService.dispose();
    unawaited(_radioService.dispose());
    super.dispose();
  }
}
