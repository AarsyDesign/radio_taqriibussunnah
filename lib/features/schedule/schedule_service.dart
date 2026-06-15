import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/app_config.dart';
import 'schedule_data.dart';
import 'schedule_model.dart';

class ScheduleService {
  ScheduleService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<ScheduleModel>> fetchSchedule() async {
    if (AppConfig.scheduleUrl.contains('ISI_SCHEDULE_URL_DI_SINI')) {
      return List<ScheduleModel>.of(ScheduleData.scheduleItems);
    }

    try {
      final response = await _client
          .get(Uri.parse(AppConfig.scheduleUrl))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return List<ScheduleModel>.of(ScheduleData.scheduleItems);
      }

      final decoded = jsonDecode(response.body);
      final parsed = _parseSchedule(decoded);
      if (parsed.isNotEmpty) {
        return parsed;
      }
    } catch (_) {}

    return List<ScheduleModel>.of(ScheduleData.scheduleItems);
  }

  void dispose() {
    _client.close();
  }

  List<ScheduleModel> _parseSchedule(Object? decoded) {
    final list = _extractList(decoded);
    if (list.isEmpty) {
      return const [];
    }

    return list.map<ScheduleModel>((item) {
      final map = item is Map<String, dynamic>
          ? item
          : Map<String, dynamic>.from(item as Map);

      final title = _readString(map['title'] ?? map['name'] ?? map['program']);
      final time = _readTime(map);
      final description = _readString(
        map['description'] ?? map['notes'] ?? map['summary'],
      );
      final day = _readString(map['day'] ?? map['weekday'] ?? map['days']);
      final isLive = map['isLive'] is bool
          ? map['isLive'] as bool
          : map['is_live'] is bool
          ? map['is_live'] as bool
          : false;

      return ScheduleModel(
        title: title.isNotEmpty ? title : 'Kajian Radio',
        time: time.isNotEmpty ? time : 'Menyesuaikan',
        description: description.isNotEmpty
            ? description
            : 'Siaran kajian dari AzuraCast',
        day: day.isNotEmpty ? day : null,
        isLive: isLive,
      );
    }).toList(growable: false);
  }

  List<Object?> _extractList(Object? decoded) {
    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      for (final key in ['schedule', 'data', 'items', 'results']) {
        final value = decoded[key];
        if (value is List) {
          return value;
        }
      }
    }

    return const [];
  }

  String _readString(Object? value) {
    return value is String ? value.trim() : '';
  }

  String _readTime(Map<String, dynamic> map) {
    final start = _readString(map['start_time'] ?? map['start'] ?? map['time']);
    final end = _readString(map['end_time'] ?? map['end']);

    if (start.isNotEmpty && end.isNotEmpty) {
      return '$start - $end';
    }

    if (start.isNotEmpty) {
      return start;
    }

    return _readString(map['time']);
  }
}
