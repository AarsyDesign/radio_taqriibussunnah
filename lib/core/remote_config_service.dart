import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_config.dart';
import 'remote_radio_config.dart';

class RemoteConfigService {
  RemoteConfigService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<RemoteRadioConfig> fetchConfig() async {
    if (AppConfig.remoteConfigUrl.contains('ISI_URL_REMOTE_CONFIG')) {
      return RemoteRadioConfig.fallback();
    }

    try {
      final response = await _client
          .get(Uri.parse(AppConfig.remoteConfigUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return RemoteRadioConfig.fallback();
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return RemoteRadioConfig.fromJson(decoded);
      }
    } catch (_) {}

    return RemoteRadioConfig.fallback();
  }

  void dispose() {
    _client.close();
  }
}