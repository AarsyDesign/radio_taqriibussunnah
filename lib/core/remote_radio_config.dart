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
    this.eventInfo,
    this.liveInfo,
    this.schedule = const [],
    this.updatedAt,
  });

  final String radioName;
  final String radioSubtitle;
  final String streamUrl;
  final String nowPlayingUrl;
  final String telegramUrl;
  final String websiteUrl;
  final bool isFallback;
  final RemoteEventInfo? eventInfo;
  final RemoteLiveInfo? liveInfo;
  final List<RemoteScheduleItem> schedule;
  final DateTime? updatedAt;

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
    final stream = _readString(
      json['streamUrl'],
      fallback: AppConfig.streamUrl,
    );
    final nowPlaying = _readString(
      json['nowPlayingUrl'],
      fallback: AppConfig.nowPlayingUrl,
    );

    return RemoteRadioConfig(
      radioName: _readString(json['radioName'], fallback: AppConfig.radioName),
      radioSubtitle: _readString(
        json['radioSubtitle'],
        fallback: AppConfig.radioSubtitle,
      ),
      streamUrl: stream,
      nowPlayingUrl: nowPlaying,
      telegramUrl: _readString(
        json['telegramUrl'],
        fallback: AppConfig.telegramUrl,
      ),
      websiteUrl: _readString(
        json['websiteUrl'],
        fallback: AppConfig.websiteUrl,
      ),
      eventInfo: RemoteEventInfo.fromObject(json['eventInfo']),
      liveInfo: RemoteLiveInfo.fromObject(json['liveInfo']),
      schedule: _readSchedule(json['schedule']),
      updatedAt: _readDateTime(json['updatedAt']),
      isFallback: false,
    );
  }

  bool get hasRemoteSchedule => schedule.isNotEmpty;

  static List<RemoteScheduleItem> _readSchedule(Object? value) {
    if (value is! List) {
      return const [];
    }

    final items = <RemoteScheduleItem>[];
    for (final item in value) {
      final scheduleItem = RemoteScheduleItem.fromObject(item);
      if (scheduleItem != null && scheduleItem.isActive) {
        items.add(scheduleItem);
      }
    }
    items.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return List.unmodifiable(items);
  }

  static String _readString(Object? value, {String fallback = ''}) {
    final str = value is String ? value.trim() : '';
    return str.isNotEmpty ? str : fallback;
  }

  static bool _readBool(Object? value, {bool fallback = false}) {
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

    return fallback;
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? fallback;
    }

    return fallback;
  }

  static DateTime? _readDateTime(Object? value) {
    final str = _readString(value);
    if (str.isEmpty) {
      return null;
    }

    return DateTime.tryParse(str);
  }

  static String? _readUrl(Object? value) {
    final str = _readString(value);
    if (str.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(str);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return null;
    }

    return str;
  }

  static String? _readImageUrl(Object? value) {
    final url = _readUrl(value);
    if (url == null) {
      return null;
    }

    final uri = Uri.parse(url);
    final normalizedDriveUrl = _normalizeGoogleDriveImageUrl(uri);
    if (normalizedDriveUrl != null) {
      return normalizedDriveUrl;
    }

    final path = uri.path.toLowerCase();
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp'];
    if (imageExtensions.any(path.endsWith)) {
      return url;
    }

    final query = uri.query.toLowerCase();
    if (query.contains('format=') || query.contains('image=')) {
      return url;
    }

    return url;
  }

  static String? _normalizeGoogleDriveImageUrl(Uri uri) {
    if (uri.host.toLowerCase() != 'drive.google.com') {
      return null;
    }

    final idFromQuery = uri.queryParameters['id']?.trim();
    final idFromPath = RegExp(
      r'/file/d/([^/]+)',
      caseSensitive: false,
    ).firstMatch(uri.path)?.group(1);
    final fileId = (idFromPath?.isNotEmpty ?? false) ? idFromPath : idFromQuery;
    if (fileId == null || fileId.isEmpty) {
      return null;
    }

    return Uri.https('drive.google.com', '/thumbnail', {
      'id': fileId,
      'sz': 'w1200',
    }).toString();
  }
}

class RemoteEventInfo {
  const RemoteEventInfo({
    required this.isActive,
    required this.title,
    required this.subtitle,
    required this.speaker,
    required this.dateText,
    required this.timeText,
    required this.location,
    required this.description,
    required this.buttonText,
    this.imageUrl,
    this.buttonUrl,
  });

  final bool isActive;
  final String title;
  final String subtitle;
  final String speaker;
  final String dateText;
  final String timeText;
  final String location;
  final String description;
  final String? imageUrl;
  final String buttonText;
  final String? buttonUrl;

  factory RemoteEventInfo.fromJson(Map<String, dynamic> json) {
    return RemoteEventInfo(
      isActive: RemoteRadioConfig._readBool(json['isActive']),
      title: RemoteRadioConfig._readString(json['title']),
      subtitle: RemoteRadioConfig._readString(json['subtitle']),
      speaker: RemoteRadioConfig._readString(json['speaker']),
      dateText: RemoteRadioConfig._readString(json['dateText']),
      timeText: RemoteRadioConfig._readString(json['timeText']),
      location: RemoteRadioConfig._readString(json['location']),
      description: RemoteRadioConfig._readString(json['description']),
      imageUrl: RemoteRadioConfig._readImageUrl(json['imageUrl']),
      buttonText: RemoteRadioConfig._readString(
        json['buttonText'],
        fallback: 'Buka Info',
      ),
      buttonUrl: RemoteRadioConfig._readUrl(json['buttonUrl']),
    );
  }

  static RemoteEventInfo? fromObject(Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    final info = RemoteEventInfo.fromJson(value);
    if (!info.isActive) {
      return null;
    }

    return info;
  }
}

class RemoteLiveInfo {
  const RemoteLiveInfo({
    required this.isActive,
    required this.title,
    required this.speaker,
    required this.topic,
    required this.timeText,
    required this.description,
    required this.showRedLiveIndicator,
    required this.buttonText,
    this.imageUrl,
    this.buttonUrl,
  });

  final bool isActive;
  final String title;
  final String speaker;
  final String topic;
  final String timeText;
  final String description;
  final String? imageUrl;
  final bool showRedLiveIndicator;
  final String buttonText;
  final String? buttonUrl;

  factory RemoteLiveInfo.fromJson(Map<String, dynamic> json) {
    return RemoteLiveInfo(
      isActive: RemoteRadioConfig._readBool(json['isActive']),
      title: RemoteRadioConfig._readString(json['title']),
      speaker: RemoteRadioConfig._readString(json['speaker']),
      topic: RemoteRadioConfig._readString(json['topic']),
      timeText: RemoteRadioConfig._readString(json['timeText']),
      description: RemoteRadioConfig._readString(json['description']),
      imageUrl: RemoteRadioConfig._readImageUrl(json['imageUrl']),
      showRedLiveIndicator: RemoteRadioConfig._readBool(
        json['showRedLiveIndicator'],
      ),
      buttonText: RemoteRadioConfig._readString(
        json['buttonText'],
        fallback: 'Buka Info',
      ),
      buttonUrl: RemoteRadioConfig._readUrl(json['buttonUrl']),
    );
  }

  static RemoteLiveInfo? fromObject(Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    final info = RemoteLiveInfo.fromJson(value);
    if (!info.isActive) {
      return null;
    }

    return info;
  }
}

class RemoteScheduleItem {
  const RemoteScheduleItem({
    required this.title,
    required this.timeText,
    required this.description,
    required this.category,
    required this.sortOrder,
    required this.isActive,
    required this.isLiveSlot,
  });

  final String title;
  final String timeText;
  final String description;
  final String category;
  final int sortOrder;
  final bool isActive;
  final bool isLiveSlot;

  factory RemoteScheduleItem.fromJson(Map<String, dynamic> json) {
    return RemoteScheduleItem(
      title: RemoteRadioConfig._readString(json['title']),
      timeText: RemoteRadioConfig._readString(json['timeText']),
      description: RemoteRadioConfig._readString(json['description']),
      category: RemoteRadioConfig._readString(json['category']),
      sortOrder: RemoteRadioConfig._readInt(json['sortOrder']),
      isActive: RemoteRadioConfig._readBool(json['isActive'], fallback: true),
      isLiveSlot: RemoteRadioConfig._readBool(json['isLiveSlot']),
    );
  }

  static RemoteScheduleItem? fromObject(Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }

    final item = RemoteScheduleItem.fromJson(value);
    if (!item.isActive || item.title.isEmpty || item.timeText.isEmpty) {
      return null;
    }

    return item;
  }
}
