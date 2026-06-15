# Radio Taqriibussunnah

Aplikasi Flutter untuk streaming Radio Taqriibussunnah. Project ini dibuat sebagai pemutar radio online dengan tampilan sederhana, elegan, dan mudah digunakan untuk mendengarkan kajian Islam, murottal, serta siaran live melalui server AzuraCast.

## Ringkasan Project

Radio Taqriibussunnah adalah aplikasi radio online berbasis Flutter dengan fokus utama:

- Memutar stream utama dari AzuraCast.
- Menampilkan informasi Now Playing dari endpoint publik AzuraCast.
- Menampilkan indikator live saat siaran langsung aktif.
- Menyediakan jadwal/susunan siaran harian lokal.
- Menyediakan informasi radio, tautan Telegram, website, dan riwayat pembaruan.
- Menjaga aplikasi tetap ringan tanpa Firebase, database, login, atau API key AzuraCast.

Project ini tidak memakai admin API AzuraCast dan tidak menyimpan API key di aplikasi.

## Status Saat Ini

Fitur utama yang sudah tersedia:

- Player radio stabil menggunakan `just_audio`.
- Audio session dan background audio aktif.
- Stream utama dari AzuraCast berjalan.
- Now Playing membaca endpoint publik AzuraCast.
- Field `playlist` dan status live dibaca secara aman jika tersedia dari JSON AzuraCast.
- Indikator bola merah berkedip muncul saat live aktif.
- Mini player global muncul saat player tidak idle.
- Tab utama: Radio, Jadwal, Tentang.
- Halaman Jadwal memiliki susunan siaran harian lokal.
- Card siaran aktif/AutoDJ berada di bawah judul Jadwal Kajian.
- Halaman Tentang menampilkan informasi radio, info live stream, tautan resmi, dan riwayat pembaruan.
- UI light mode hijau-krem dan dark mode dengan kontras card playlist yang lebih jelas.
- Logo utama memakai asset `assets/images/logo_radio.jpg`.

## Teknologi

Project menggunakan:

- Flutter
- Dart SDK `^3.12.2`
- `just_audio` untuk playback stream
- `audio_session` untuk konfigurasi audio
- `just_audio_background` untuk background audio/media notification
- `connectivity_plus` untuk monitoring koneksi
- `http` untuk fetch Now Playing dan remote config opsional
- `url_launcher` untuk membuka tautan
- `share_plus` untuk share radio
- `package_info_plus` untuk informasi aplikasi

## Struktur Folder Penting

```text
lib/
  main.dart
  app.dart
  app_theme.dart
  core/
    app_config.dart
    app_constants.dart
    app_links.dart
    radio_config_provider.dart
    remote_config_service.dart
    remote_radio_config.dart
  features/
    home/
      main_shell.dart
    radio/
      radio_controller.dart
      radio_service.dart
      now_playing_service.dart
      now_playing_model.dart
      connectivity_service.dart
      radio_page.dart
      widgets/
        mini_player.dart
    schedule/
      schedule_page.dart
      broadcast_schedule_model.dart
      broadcast_schedule_data.dart
      broadcast_schedule_item.dart
      schedule_model.dart
      schedule_data.dart
      schedule_item.dart
      schedule_service.dart
    about/
      about_page.dart
      about_dialog.dart
    update_logs/
      update_logs_page.dart
  widgets/
    app_link_button.dart

assets/
  images/
    logo_radio.jpg
```

## Alur Aplikasi

1. `main.dart` menjalankan aplikasi.
2. `app.dart` membuat `MaterialApp`, theme light/dark, dan `MainShell`.
3. `MainShell` membuat `RadioConfigProvider` dan `RadioController`.
4. `RadioController` mengatur status player, koneksi, retry, dan polling Now Playing.
5. `RadioService` hanya bertanggung jawab untuk audio playback menggunakan `AudioPlayer`.
6. `NowPlayingService` mengambil JSON dari endpoint publik AzuraCast.
7. `RadioPage` menampilkan logo, Now Playing, tombol play/pause, status, dan link.
8. `MiniPlayer` tampil secara global saat radio sudah pernah diputar.
9. `SchedulePage` menampilkan jadwal/susunan siaran harian lokal.
10. `AboutPage` menampilkan informasi radio dan keterangan live stream.

## Konfigurasi Utama

Konfigurasi dasar ada di:

```text
lib/core/app_config.dart
```

Nilai penting:

```dart
static const String appName = 'Radio Taqriibussunnah';
static const String radioName = 'Radio Taqriibussunnah';
static const String radioSubtitle = 'Kajian Islam & Murottal';
static const String streamUrl = 'http://151.245.85.182/listen/radio/radio.mp3';
static const String nowPlayingUrl = 'http://151.245.85.182/api/nowplaying_static/radio.json';
```

Catatan:

- `streamUrl` adalah stream utama yang diputar aplikasi.
- `nowPlayingUrl` adalah endpoint publik untuk informasi sedang diputar.
- Tidak ada API key AzuraCast.
- Tidak memakai admin API AzuraCast.

## Integrasi AzuraCast

Aplikasi memakai dua jalur publik:

1. Stream audio:

```text
http://151.245.85.182/listen/radio/radio.mp3
```

2. Now Playing static JSON:

```text
http://151.245.85.182/api/nowplaying_static/radio.json
```

Data yang dibaca dari Now Playing:

- Judul audio
- Artist
- Text metadata
- Jumlah pendengar
- Playlist jika tersedia
- Status online station
- Status live dari `live.is_live`, `live.streamer_online`, `now_playing.is_live`, atau `station.streamer_online` jika tersedia

Parsing dibuat aman. Jika struktur JSON berubah atau field kosong, aplikasi tidak crash.

## Siaran Live

Siaran live kajian dapat masuk ke AzuraCast melalui SHOUTcast DSP Winamp atau encoder lain yang terhubung ke server radio.

Di aplikasi:

- Audio tetap diputar dari stream utama.
- Saat live berlangsung, AzuraCast mengganti isi stream utama.
- Aplikasi otomatis memutar siaran live karena sumber audio tetap `streamUrl`.
- Jika Now Playing mengirim status live, card Now Playing menampilkan indikator bola merah berkedip.

Tidak ada logic audio khusus untuk live. Live sepenuhnya mengikuti stream utama server.

## Radio Player

File penting:

```text
lib/features/radio/radio_service.dart
lib/features/radio/radio_controller.dart
```

`RadioService`:

- Membuat satu `AudioPlayer`.
- Mengatur `AudioSource.uri`.
- Mengaktifkan background media item.
- Menyediakan play, pause, dispose.

`RadioController`:

- Mengatur status player: idle, loading, playing, paused, reconnecting, offline, error.
- Memantau koneksi internet.
- Melakukan retry reconnect.
- Polling Now Playing setiap 20 detik.
- Menjadi sumber state untuk `RadioPage` dan `MiniPlayer`.

Penting:

- Jangan membuat `AudioPlayer` baru di UI.
- Jangan mengubah `streamUrl` sembarangan.
- Jangan memindahkan logic audio ke widget.

## Now Playing

File:

```text
lib/features/radio/now_playing_model.dart
lib/features/radio/now_playing_service.dart
```

`NowPlayingModel` memiliki field:

- `title`
- `artist`
- `text`
- `isOnline`
- `isLive`
- `listeners`
- `playlist`

Jika `playlist` tersedia, card Now Playing menampilkan:

```text
Playlist: nama playlist
```

Jika tidak tersedia, bagian playlist tidak ditampilkan.

## Halaman Radio

File:

```text
lib/features/radio/radio_page.dart
```

Isi utama halaman:

- Logo radio dari `assets/images/logo_radio.jpg`
- Nama radio
- Subtitle radio
- Card Now Playing
- Indikator live merah berkedip jika live aktif
- Tombol play/pause besar
- Status koneksi/player
- Link Telegram, website, dan tombol share

Dark mode pada card Now Playing dibuat lebih kontras supaya title, playlist, metadata, dan badge tetap terbaca.

## Mini Player

File:

```text
lib/features/radio/widgets/mini_player.dart
```

Mini player muncul ketika status player bukan `idle`.

Fungsi:

- Menampilkan judul Now Playing atau nama radio.
- Menampilkan status player.
- Tombol close untuk menghentikan player.
- Tombol play/pause.

Mini player memakai controller yang sama, tidak membuat player baru.

## Halaman Jadwal

File utama:

```text
lib/features/schedule/schedule_page.dart
```

Urutan tampilan:

1. Judul halaman `Jadwal Kajian`
2. Subtitle nama radio
3. Card `Siaran aktif / AutoDJ`
4. Card info Dauroh/Event khusus
5. Section `Susunan Siaran Harian`
6. Daftar jadwal
7. Catatan perubahan jadwal

Data susunan siaran bersifat lokal/statis.

File data:

```text
lib/features/schedule/broadcast_schedule_data.dart
```

Data saat ini:

1. Murottal Al-Qur'an, 00.00-04.30
2. Kajian Pagi, 04.30-06.00
3. Kajian Aqidah, 08.00-10.00
4. Kajian Fiqih, 13.00-15.00
5. Murottal Sore, 15.30-17.00
6. Kajian Malam, 19.30-21.00
7. Siaran Bebas / AutoDJ, Menyesuaikan

Jadwal ini tidak mengambil data dari admin API AzuraCast.

## Halaman Tentang

File:

```text
lib/features/about/about_page.dart
```

Isi halaman:

- Logo radio
- Nama dan deskripsi radio
- Informasi resmi
- Card informasi live stream
- Link Telegram dan website
- Tombol Riwayat Pembaruan
- Catatan aplikasi

Status konfigurasi internal tidak ditampilkan ke pengguna umum.

## Theme dan UI

File:

```text
lib/app_theme.dart
lib/core/app_constants.dart
```

Palet utama:

- Hijau tua
- Hijau sedang
- Krem
- Ivory
- Soft gold

Prinsip UI:

- Light mode hijau-krem tetap lembut.
- Dark mode tetap kontras dan nyaman dibaca.
- Card tidak terlalu besar.
- Radius sederhana.
- Tombol mudah disentuh.
- Teks penting tidak memakai abu-abu terlalu tipis.

## Asset Logo

Logo utama berada di:

```text
assets/images/logo_radio.jpg
```

Konfigurasi asset:

```yaml
flutter:
  assets:
    - assets/images/
```

Konfigurasi launcher icon dan splash:

```yaml
flutter_launcher_icons:
  image_path: assets/images/logo_radio.jpg

flutter_native_splash:
  image: assets/images/logo_radio.jpg
```

Jika mengganti logo, simpan file baru di `assets/images/` lalu sesuaikan path jika nama file berubah.

## Cara Menjalankan Project

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

## Cara Update Jadwal Siaran

Edit file:

```text
lib/features/schedule/broadcast_schedule_data.dart
```

Contoh item:

```dart
BroadcastScheduleModel(
  title: 'Kajian Pagi',
  time: '04.30-06.00',
  description: 'Kajian dan faedah pembuka hari',
  category: 'Kajian',
)
```

Jika ingin menampilkan badge live pada item tertentu:

```dart
isLiveSlot: true
```

## Cara Update Link Radio

Edit file:

```text
lib/core/app_config.dart
```

Field yang umum diubah:

- `streamUrl`
- `nowPlayingUrl`
- `telegramUrl`
- `websiteUrl`

Pastikan URL stream dan Now Playing adalah endpoint publik yang dapat diakses tanpa API key.

## Remote Config Opsional

Project memiliki dukungan remote config sederhana:

```text
lib/core/remote_config_service.dart
lib/core/remote_radio_config.dart
lib/core/radio_config_provider.dart
```

Default saat ini:

```dart
static const String remoteConfigUrl = 'ISI_URL_REMOTE_CONFIG_JSON_DI_SINI';
```

Karena masih placeholder, aplikasi memakai fallback dari `AppConfig`.

Format JSON remote config jika suatu saat dipakai:

```json
{
  "radioName": "Radio Taqriibussunnah",
  "radioSubtitle": "Kajian Islam & Murottal",
  "streamUrl": "https://example.com/listen/radio/radio.mp3",
  "nowPlayingUrl": "https://example.com/api/nowplaying_static/radio.json",
  "telegramUrl": "https://t.me/taqriibussunnahptk",
  "websiteUrl": "https://example.com"
}
```

Tetap jangan taruh API key di remote config publik.

## Riwayat Pengembangan

Tahap awal:

- Membuat project Flutter.
- Menyiapkan struktur tab Radio, Jadwal, dan Tentang.
- Menambahkan konfigurasi dasar radio.
- Menambahkan audio player menggunakan `just_audio`.

Tahap player:

- Menambahkan `RadioService`.
- Menambahkan `RadioController`.
- Menambahkan status player dan retry reconnect.
- Menambahkan monitoring koneksi internet.
- Menambahkan mini player global.

Tahap AzuraCast:

- Menghubungkan stream utama AzuraCast.
- Menambahkan Now Playing dari endpoint publik.
- Parsing metadata dibuat aman.
- Menambahkan listener count.
- Menambahkan field playlist optional.
- Menambahkan status live dan indikator pulse merah.

Tahap Jadwal:

- Menambahkan model jadwal siaran harian.
- Menambahkan data jadwal lokal/statis.
- Menambahkan widget item jadwal.
- Menata halaman Jadwal agar tidak terlihat acak.
- Menambahkan card siaran aktif/AutoDJ di bawah judul.

Tahap UI/UX:

- Menata theme hijau-krem.
- Merapikan Radio Page.
- Merapikan Mini Player.
- Merapikan Jadwal Page.
- Merapikan About Page.
- Memperbaiki dark mode pada card playlist dan jadwal.
- Menghapus status konfigurasi dari UI pengguna.

Tahap asset:

- Menambahkan logo radio di `assets/images/logo_radio.jpg`.
- Memakai logo tersebut untuk avatar utama radio.
- Menyesuaikan launcher icon dan splash config.

Tahap Git:

- Menghubungkan repo ke GitHub:

```text
https://github.com/AarsyDesign/radio_taqriibussunnah.git
```

- Melakukan commit dan push perubahan.
- Menyelesaikan konflik merge saat branch lokal dan remote sempat diverge.

## Checklist Sebelum Commit dan Push

Jalankan:

```powershell
flutter.bat analyze
```

Opsional:

```powershell
flutter.bat build web
```

Cek status:

```powershell
git status --short --branch
```

Commit:

```powershell
git add -A
git commit -m "Tulis pesan commit"
```

Push:

```powershell
git push origin main
```

Jika muncul pesan branch diverged:

```powershell
git pull origin main
```

Jika ada conflict:

1. Buka file yang conflict.
2. Hapus marker `<<<<<<<`, `=======`, `>>>>>>>`.
3. Pilih isi kode yang benar.
4. Jalankan `flutter.bat analyze`.
5. Stage dan commit hasil merge.

## Hal yang Sengaja Tidak Dipakai

Project ini sengaja tidak memakai:

- Firebase
- Database lokal/remote
- Login user
- API key AzuraCast
- Admin API AzuraCast
- AudioPlayer tambahan di widget
- Package tambahan untuk jadwal

Tujuannya agar aplikasi tetap ringan, aman, dan mudah dirawat.

## Catatan Maintenance

- Jangan ubah `RadioController` dan `RadioService` tanpa kebutuhan kuat.
- Jika hanya mengubah UI, cukup edit page/widget.
- Jika hanya mengubah jadwal, edit `broadcast_schedule_data.dart`.
- Jika hanya mengubah logo, pastikan asset path dan `pubspec.yaml` sesuai.
- Jika Now Playing tidak muncul, cek endpoint `nowPlayingUrl`.
- Jika audio tidak berjalan, cek `streamUrl` dan koneksi server AzuraCast.

## Lisensi dan Penggunaan

Project ini dibuat untuk kebutuhan Radio Taqriibussunnah. Sesuaikan lisensi penggunaan internal sesuai kebutuhan pengelola project.
