import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (results) => _controller.add(_isOnline(results)),
      onError: (_) => _controller.add(false),
    );
  }

  final Connectivity _connectivity;
  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Stream<bool> get onConnectionChanged => _controller.stream;

  Future<bool> checkNow() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isOnline(results);
    } catch (_) {
      return true;
    }
  }

  bool _isOnline(List<ConnectivityResult> results) {
    return results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _controller.close();
  }
}
