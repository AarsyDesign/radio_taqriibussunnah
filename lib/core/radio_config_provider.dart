import 'package:flutter/foundation.dart';

import 'remote_config_service.dart';
import 'remote_radio_config.dart';

class RadioConfigProvider extends ChangeNotifier {
  RadioConfigProvider({RemoteConfigService? service})
    : _service = service ?? RemoteConfigService();

  final RemoteConfigService _service;

  RemoteRadioConfig _config = RemoteRadioConfig.fallback();
  bool _isLoading = false;
  bool _hasRemoteConfigError = false;
  bool _isDisposed = false;

  RemoteRadioConfig get config => _config;
  bool get isLoading => _isLoading;
  bool get isLoadingRemoteConfig => _isLoading;
  bool get hasRemoteConfigError => _hasRemoteConfigError;
  bool get usingFallback => _config.isFallback;
  RemoteEventInfo? get eventInfo => _config.eventInfo;
  RemoteLiveInfo? get liveInfo => _config.liveInfo;
  List<RemoteScheduleItem> get remoteScheduleItems => _config.schedule;
  bool get hasRemoteSchedule => _config.hasRemoteSchedule;
  DateTime? get updatedAt => _config.updatedAt;

  Future<void> load() async {
    if (_isLoading) return;

    _isLoading = true;
    _hasRemoteConfigError = false;
    notifyListeners();

    try {
      final newConfig = await _service.fetchConfig();
      if (_isDisposed) return;

      _config = newConfig ?? RemoteRadioConfig.fallback();
      _hasRemoteConfigError = newConfig == null;
    } catch (_) {
      if (_isDisposed) return;

      _config = RemoteRadioConfig.fallback();
      _hasRemoteConfigError = true;
    } finally {
      if (!_isDisposed) {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refresh() => load();

  @override
  void dispose() {
    _isDisposed = true;
    _service.dispose();
    super.dispose();
  }
}
