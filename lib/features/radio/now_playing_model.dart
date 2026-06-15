import '../../core/app_config.dart';

class NowPlayingModel {
  const NowPlayingModel({
    required this.title,
    required this.artist,
    required this.text,
    required this.isOnline,
    required this.isLive,
    required this.listeners,
    this.playlist,
  });

  final String title;
  final String artist;
  final String text;
  final bool isOnline;
  final bool isLive;
  final int? listeners;
  final String? playlist;

  factory NowPlayingModel.fromJson(
    Map<String, dynamic> json, {
    String fallbackName = AppConfig.radioName,
  }) {
    final song = _readSong(json);
    final artist = _readString(song['artist']);
    final text = _readString(song['text']);
    final rawTitle = _readString(song['title']);
    final title = rawTitle.isNotEmpty
        ? rawTitle
        : text.isNotEmpty
        ? text
        : fallbackName;
    final hasMetadata = rawTitle.isNotEmpty || text.isNotEmpty;

    return NowPlayingModel(
      title: title,
      artist: artist,
      text: text,
      isOnline: _readOnlineStatus(json) ?? hasMetadata,
      isLive: _readLiveStatus(json) ?? false,
      listeners: _readListeners(json),
      playlist: _readPlaylist(json),
    );
  }

  static Map<String, dynamic> _readSong(Map<String, dynamic> json) {
    final nowPlaying = json['now_playing'];
    if (nowPlaying is! Map<String, dynamic>) {
      return const {};
    }

    final song = nowPlaying['song'];
    if (song is! Map<String, dynamic>) {
      return const {};
    }

    return song;
  }

  static String _readString(Object? value) {
    return value is String ? value.trim() : '';
  }

  static bool? _readOnlineStatus(Map<String, dynamic> json) {
    final station = json['station'];
    if (station is Map<String, dynamic>) {
      final isOnline = station['is_online'];
      if (isOnline is bool) {
        return isOnline;
      }
    }

    final live = json['live'];
    if (live is Map<String, dynamic>) {
      final isLive = live['is_live'];
      if (isLive is bool) {
        return isLive;
      }
    }

    return null;
  }

  static bool? _readLiveStatus(Map<String, dynamic> json) {
    final live = json['live'];
    if (live is Map<String, dynamic>) {
      final isLive = _readBool(live['is_live']);
      if (isLive != null) {
        return isLive;
      }

      final streamerOnline = _readBool(live['streamer_online']);
      if (streamerOnline != null) {
        return streamerOnline;
      }
    }

    final nowPlaying = json['now_playing'];
    if (nowPlaying is Map<String, dynamic>) {
      final isLive = _readBool(nowPlaying['is_live']);
      if (isLive != null) {
        return isLive;
      }
    }

    final station = json['station'];
    if (station is Map<String, dynamic>) {
      final streamerOnline = _readBool(station['streamer_online']);
      if (streamerOnline != null) {
        return streamerOnline;
      }
    }

    return null;
  }

  static int? _readListeners(Map<String, dynamic> json) {
    final listeners = json['listeners'];
    if (listeners is! Map<String, dynamic>) {
      return null;
    }

    final current = listeners['current'];
    if (current is int) {
      return current;
    }
    if (current is num) {
      return current.toInt();
    }

    return null;
  }

  static String? _readPlaylist(Map<String, dynamic> json) {
    final nowPlaying = json['now_playing'];
    if (nowPlaying is! Map<String, dynamic>) {
      return null;
    }

    final playlist = _readString(nowPlaying['playlist']);
    if (playlist.isEmpty) {
      return null;
    }

    return playlist;
  }

  static bool? _readBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    return null;
  }
}
