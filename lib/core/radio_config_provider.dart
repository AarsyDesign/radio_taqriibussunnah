import 'package:flutter/foundation.dart';

import 'remote_config_service.dart';
import 'remote_radio_config.dart';

class RadioConfigProvider extends ChangeNotifier {
  RadioConfigProvider({RemoteConfigService? service})
      : _service = service ?? RemoteConfigService();

  final RemoteConfigService _service;

  RemoteRadioConfig _config = RemoteRadioConfig.fallback();
  bool _isLoading = false;
  bool _isDisposed = false;

  RemoteRadioConfig get config => _config;
  bool get isLoading => _isLoading;
  bool get usingFallback => _config.isFallback;

  Future<void> load() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final newConfig = await _service.fetchConfig();
    if (_isDisposed) return;

    _config = newConfig;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() => load();

  @override
  void dispose() {
    _isDisposed = true;
    _service.dispose();
    super.dispose();
  }
}