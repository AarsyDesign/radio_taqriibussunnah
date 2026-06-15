import 'app_config.dart';

class RemoteRadioConfig {
  const RemoteRadioConfig({
    required this.radioName,
    required this.radioSubtitle,
    required this.streamUrl,
    required this.nowPlayingUrl,
    required this.telegramUrl,
    required this.websiteUrl,
    required this.isFallback,
  });

  final String radioName;
  final String radioSubtitle;
  final String streamUrl;
  final String nowPlayingUrl;
  final String telegramUrl;
  final String websiteUrl;
  final bool isFallback;

  factory RemoteRadioConfig.fallback() {
    return const RemoteRadioConfig(
      radioName: AppConfig.radioName,
      radioSubtitle: AppConfig.radioSubtitle,
      streamUrl: AppConfig.streamUrl,
      nowPlayingUrl: AppConfig.nowPlayingUrl,
      telegramUrl: AppConfig.telegramUrl,
      websiteUrl: AppConfig.websiteUrl,
      isFallback: true,
    );
  }

  factory RemoteRadioConfig.fromJson(Map<String, dynamic> json) {
    final stream = _readString(json['streamUrl']);
    final nowPlaying = _readString(json['nowPlayingUrl']);

    if (stream.isEmpty || nowPlaying.isEmpty) {
      return RemoteRadioConfig.fallback();
    }

    return RemoteRadioConfig(
      radioName: _readString(json['radioName'], fallback: AppConfig.radioName),
      radioSubtitle: _readString(json['radioSubtitle'], fallback: AppConfig.radioSubtitle),
      streamUrl: stream,
      nowPlayingUrl: nowPlaying,
      telegramUrl: _readString(json['telegramUrl'], fallback: AppConfig.telegramUrl),
      websiteUrl: _readString(json['websiteUrl'], fallback: AppConfig.websiteUrl),
      isFallback: false,
    );
  }

  static String _readString(dynamic value, {String fallback = ''}) {
    final str = value is String ? value.trim() : '';
    return str.isNotEmpty ? str : fallback;
  }
}