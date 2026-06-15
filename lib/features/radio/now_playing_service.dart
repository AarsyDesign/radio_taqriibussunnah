import 'dart:convert';

import 'package:http/http.dart' as http;

import 'now_playing_model.dart';

class NowPlayingService {
  NowPlayingService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<NowPlayingModel?> fetchNowPlaying({
    required String url,
    required String fallbackName,
  }) async {
    if (url.isEmpty || url.contains('ISI_NOW_PLAYING')) return null;

    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return null;
      }

      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic>) {
        return null;
      }

      return NowPlayingModel.fromJson(json, fallbackName: fallbackName);
    } catch (_) {
      return null;
    }
  }

  void dispose() {
    _client.close();
  }
}
