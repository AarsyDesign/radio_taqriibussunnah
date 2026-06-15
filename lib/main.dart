import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'app.dart';
import 'core/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: AppConfig.notificationChannelId,
    androidNotificationChannelName: AppConfig.notificationChannelName,
    androidNotificationOngoing: true,
  );

  runApp(const RadioTaqriibussunnahApp());
}
