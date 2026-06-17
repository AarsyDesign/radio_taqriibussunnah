import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'app.dart';
import 'core/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await JustAudioBackground.init(
      androidNotificationChannelId: AppConfig.notificationChannelId,
      androidNotificationChannelName: AppConfig.notificationChannelName,
      androidNotificationOngoing: true,
      androidNotificationIcon: 'mipmap/ic_launcher',
    );
  } catch (error) {
    debugPrint('Background audio init skipped: $error');
  }

  runApp(const RadioTaqriibussunnahApp());
}
