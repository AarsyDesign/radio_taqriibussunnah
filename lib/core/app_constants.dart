import 'package:flutter/material.dart';

class AppConstants {
  const AppConstants._();

  static const appSubtitle = 'Kajian Islam & Murottal';
  static const readyStatus = 'Siap diputar';
  static const connectingStatus = 'Menyambungkan siaran...';
  static const playingStatus = 'Sedang siaran';
  static const pausedStatus = 'Siaran dijeda';
  static const reconnectingStatus = 'Mencoba menyambungkan kembali...';
  static const offlineStatus = 'Tidak ada koneksi internet';
  static const errorStatus = 'Siaran belum tersedia, coba beberapa saat lagi';
  static const unavailableTitle = 'Siaran belum tersedia';
  static const unavailableSubtitle = 'Silakan coba beberapa saat lagi.';
  static const noConnectionTitle = 'Tidak ada koneksi internet';
  static const noConnectionSubtitle = 'Periksa koneksi lalu coba kembali.';
  static const retryLabel = 'Coba Lagi';
  static const playHint = 'Tekan untuk memulai siaran';
  static const footerText = 'Streaming kajian dan murottal pilihan';
  static const telegramLabel = 'Telegram';
  static const websiteLabel = 'Website';
  static const shareLabel = 'Bagikan';
  static const aboutLabel = 'Tentang';
  static const scheduleTitle = 'Jadwal Kajian';
  static const scheduleLiveLabel = 'Sedang Live';
  static const scheduleNote = 'Jadwal dapat berubah sewaktu-waktu.';
  static const aboutDescription =
      'Radio online yang menyiarkan kajian Islam, murottal, dan faedah ilmiah dari Ma’had Taqriibussunnah Pontianak.';
  static const aboutNote =
      'Jika siaran belum tersedia, silakan coba beberapa saat lagi.';

  // New Palette
  static const primaryGreen = Color(0xFF12372A);
  static const deepGreen = Color(0xFF0F2F24);
  static const mediumGreen = Color(0xFF1F5C45);
  static const softGreen = Color(0xFF7BAE7F);
  static const cream = Color(0xFFF6EEDC);
  static const warmCream = Color(0xFFEFE1C6);
  static const ivory = Color(0xFFFFFDF6);
  static const softGold = Color(0xFFC9A45C);
  static const textDark = Color(0xFF1F2A24);
  static const textMuted = Color(0xFF6F766F);

  // Legacy support (remapped to new light-elegant theme)
  static const primaryColor = ivory;
  static const primaryDarkColor = cream;
  static const accentColor = mediumGreen;
  static const softGreenColor = softGreen;
  static const textColor = textDark;
}
