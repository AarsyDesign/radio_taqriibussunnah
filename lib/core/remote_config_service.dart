import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_config.dart';
import 'remote_radio_config.dart';

class RemoteConfigService {
  RemoteConfigService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<RemoteRadioConfig?> fetchConfig() async {
    if (AppConfig.remoteConfigUrl.contains('ISI_URL_PUBLIC_CONFIG')) {
      return null;
    }

    try {
      final uri = Uri.tryParse(AppConfig.remoteConfigUrl);
      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        return null;
      }

      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        return RemoteRadioConfig.fromJson(decoded);
      }
    } catch (_) {}

    return null;
  }

  void dispose() {
    _client.close();
  }
}
