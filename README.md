# Radio Taqriibussunnah

Aplikasi Flutter untuk streaming Radio Taqriibussunnah. Aplikasi ini fokus pada pemutar radio online yang ringan, mudah dirawat, dan aman karena hanya memakai endpoint publik AzuraCast tanpa API key, login, Firebase, atau database.

## Ringkasan

Fitur utama saat ini:

- Streaming radio dari AzuraCast menggunakan `just_audio`.
- Background audio dan media notification melalui `just_audio_background`.
- Informasi Now Playing dari endpoint publik AzuraCast.
- Deteksi status live jika field live tersedia dari payload Now Playing.
- Monitoring koneksi internet dan retry reconnect otomatis.
- Mini player global saat radio sedang aktif atau pernah diputar.
- Tab utama: Radio, Jadwal, dan Tentang.
- Jadwal siaran lokal dengan dukungan remote schedule opsional.
- Remote config publik opsional untuk mengganti info radio, link, event, live info, dan jadwal tanpa rebuild aplikasi.
- Theme light/dark dengan tombol toggle.
- Launcher icon memakai `assets/images/app_icon.png`.

## Teknologi

- Flutter
- Dart SDK `^3.12.2`
- `just_audio`
- `audio_session`
- `just_audio_background`
- `connectivity_plus`
- `http`
- `url_launcher`
- `share_plus`
- `package_info_plus`

## Struktur Penting

```text
lib/
  main.dart
  app.dart
  core/
    app_config.dart
    app_constants.dart
    app_links.dart
    radio_config_provider.dart
    remote_config_service.dart
    remote_radio_config.dart
  features/
    home/main_shell.dart
    radio/
      radio_controller.dart
      radio_service.dart
      now_playing_service.dart
      now_playing_model.dart
      connectivity_service.dart
      radio_page.dart
      widgets/mini_player.dart
    schedule/
      schedule_page.dart
      schedule_service.dart
      schedule_data.dart
      broadcast_schedule_data.dart
    about/
      about_page.dart
      about_dialog.dart
    update_logs/update_logs_page.dart
  widgets/app_link_button.dart

assets/
  images/
    app_icon.png
    splash_logo.png
```

## Konfigurasi Utama

Konfigurasi default ada di:

```text
lib/core/app_config.dart
```

Nilai penting saat ini:

```dart
static const String appName = 'Radio Taqriibussunnah';
static const String radioName = 'Radio Taqriibussunnah';
static const String radioSubtitle = 'Kajian Islam & Murottal';
static const String streamUrl = 'http://151.245.85.182/listen/radio/radio.mp3';
static const String nowPlayingUrl = 'http://151.245.85.182/api/nowplaying_static/radio.json';
static const String telegramUrl = 'https://t.me/taqriibussunnahptk';
static const String websiteUrl = 'https://daurohpontianak2026.vercel.app';
```

Placeholder opsional:

```dart
static const String scheduleUrl = 'ISI_SCHEDULE_URL_DI_SINI';
static const String remoteConfigUrl = 'ISI_URL_PUBLIC_CONFIG_WEB_ADMIN_DI_SINI';
```

Jika `scheduleUrl` atau `remoteConfigUrl` masih placeholder, aplikasi otomatis memakai data fallback lokal.

## Alur Aplikasi

1. `main.dart` menginisialisasi Flutter dan `JustAudioBackground`.
2. `app.dart` membuat `MaterialApp`, light/dark theme, dan `MainShell`.
3. `MainShell` membuat `RadioConfigProvider` dan `RadioController`.
4. `RadioConfigProvider` memuat remote config jika URL publik sudah diisi.
5. `RadioController` mengatur audio state, koneksi, retry, dan polling Now Playing.
6. `RadioService` menangani playback audio.
7. `RadioPage`, `SchedulePage`, `AboutPage`, dan `MiniPlayer` membaca state dari controller/provider.

## Integrasi AzuraCast

Aplikasi memakai endpoint publik:

```text
http://151.245.85.182/listen/radio/radio.mp3
http://151.245.85.182/api/nowplaying_static/radio.json
```

Data Now Playing yang dibaca:

- Judul audio
- Artist
- Text metadata
- Jumlah pendengar
- Playlist jika tersedia
- Status online station
- Status live dari beberapa kemungkinan field AzuraCast

Parsing dibuat defensif. Jika struktur JSON berubah atau field kosong, aplikasi tidak crash dan tetap memakai fallback yang tersedia.

## Radio Player

File utama:

```text
lib/features/radio/radio_service.dart
lib/features/radio/radio_controller.dart
```

`RadioService` membuat satu `AudioPlayer`, mengatur source stream, dan menyediakan operasi play, pause, stop, dispose.

`RadioController` mengelola status:

- `idle`
- `loading`
- `playing`
- `paused`
- `reconnecting`
- `offline`
- `error`

Controller juga memantau koneksi internet, retry sampai 5 kali, dan polling Now Playing setiap 20 detik.

## Jadwal

Halaman jadwal menampilkan jadwal siaran dengan dua sumber:

- Remote config schedule jika `remoteConfigUrl` aktif dan JSON memiliki field `schedule`.
- Fallback lokal dari `lib/features/schedule/broadcast_schedule_data.dart`.

Data lokal saat ini:

1. Murottal Al-Qur'an, 00.00-04.30
2. Kajian Pagi / Faedah Pagi, 04.30-05.00
3. Dzikir Pagi, 05.00-06.00
4. Kajian Aqidah, 08.00-10.00
5. Kajian Fiqih, 13.00-15.00
6. Murottal Sore, 15.30-17.00
7. Dzikir Petang, 17.00-18.00
8. Kajian Malam, 19.30-21.00
9. Siaran Bebas / AutoDJ, menyesuaikan

Ada juga `ScheduleService` yang bisa membaca `scheduleUrl` bila ingin memakai endpoint jadwal terpisah.

## Remote Config Opsional

Remote config adalah JSON publik, bukan tempat menyimpan rahasia. Jangan menaruh API key atau credential di sana.

Contoh format:

```json
{
  "radioName": "Radio Taqriibussunnah",
  "radioSubtitle": "Kajian Islam & Murottal",
  "streamUrl": "https://example.com/listen/radio/radio.mp3",
  "nowPlayingUrl": "https://example.com/api/nowplaying_static/radio.json",
  "telegramUrl": "https://t.me/taqriibussunnahptk",
  "websiteUrl": "https://example.com",
  "updatedAt": "2026-06-17T00:00:00+07:00",
  "eventInfo": {
    "isActive": true,
    "title": "Dauroh Pontianak 2026",
    "subtitle": "Info kajian/event khusus",
    "speaker": "Nama pemateri",
    "dateText": "Tanggal acara",
    "timeText": "Waktu acara",
    "location": "Lokasi acara",
    "description": "Ringkasan acara",
    "imageUrl": "https://example.com/banner.jpg",
    "buttonText": "Buka Info",
    "buttonUrl": "https://example.com"
  },
  "liveInfo": {
    "isActive": true,
    "title": "Siaran Live",
    "speaker": "Nama pemateri",
    "topic": "Tema kajian",
    "timeText": "Ba'da Maghrib",
    "description": "Keterangan live",
    "imageUrl": "https://example.com/live.jpg",
    "showRedLiveIndicator": true,
    "buttonText": "Buka Info",
    "buttonUrl": "https://example.com"
  },
  "schedule": [
    {
      "title": "Kajian Pagi",
      "timeText": "04.30-05.00",
      "description": "Kajian dan faedah pembuka hari",
      "category": "Kajian",
      "sortOrder": 1,
      "isActive": true,
      "isLiveSlot": false
    }
  ]
}
```

## Cara Menjalankan

Ambil dependency:

```powershell
flutter.bat pub get
```

Analisis kode:

```powershell
flutter.bat analyze
```

Jalankan aplikasi:

```powershell
flutter.bat run
```

Jalankan di Chrome:

```powershell
flutter.bat run -d chrome
```

Build web:

```powershell
flutter.bat build web
```

Build Android APK:

```powershell
flutter.bat build apk
```

## Maintenance Cepat

Update link radio:

```text
lib/core/app_config.dart
```

Update teks UI umum dan path logo:

```text
lib/core/app_constants.dart
```

Update jadwal lokal:

```text
lib/features/schedule/broadcast_schedule_data.dart
```

Update riwayat pembaruan:

```text
lib/features/update_logs/update_logs_page.dart
```

Update icon aplikasi:

```text
assets/images/app_icon.png
pubspec.yaml
```

## Checklist Sebelum Commit

```powershell
flutter.bat analyze
git status --short --branch
```

Opsional sebelum rilis:

```powershell
flutter.bat test
flutter.bat build apk
flutter.bat build web
```

## Catatan

- Jangan membuat `AudioPlayer` baru di widget.
- Jangan menaruh API key AzuraCast di aplikasi atau remote config publik.
- Jika Now Playing tidak tampil, cek `nowPlayingUrl`.
- Jika audio tidak berjalan, cek `streamUrl`, koneksi internet, dan server AzuraCast.
- Jika hanya mengubah UI, cukup edit page/widget terkait.
- Jika hanya mengubah jadwal, edit data jadwal atau remote config.

## Lisensi dan Penggunaan

Project ini dibuat untuk kebutuhan Radio Taqriibussunnah. Sesuaikan lisensi dan aturan penggunaan internal dengan kebutuhan pengelola project.
