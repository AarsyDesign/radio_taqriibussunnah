import 'package:url_launcher/url_launcher.dart';

class AppLinks {
  const AppLinks._();

  static Future<bool> openUrl(String url) async {
    try {
      return launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}
