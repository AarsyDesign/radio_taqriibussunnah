import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../../core/app_constants.dart';
import '../../core/radio_config_provider.dart';
import '../../widgets/app_link_button.dart';
import '../update_logs/update_logs_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({required this.configProvider, super.key});

  final RadioConfigProvider configProvider;

  static const List<String> _highlights = [
    'Kajian Islam',
    "Murottal Al-Qur'an",
    'Siaran langsung kajian',
    'Terhubung dengan channel Telegram resmi',
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: configProvider,
      builder: (context, _) {
        final config = configProvider.config;
        final colorScheme = Theme.of(context).colorScheme;

        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 58, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _LogoImage(),
                      const SizedBox(height: 18),
                      Text(
                        config.radioName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppConfig.radioDescription,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const _InfoCard(highlights: _highlights),
                      const SizedBox(height: 14),
                      const _LiveBroadcastInfoCard(),
                      const SizedBox(height: 14),
                      _ConfigStatusCard(configProvider: configProvider),
                      const SizedBox(height: 18),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          AppLinkButton(
                            label: AppConstants.telegramLabel,
                            icon: Icons.telegram,
                            url: config.telegramUrl,
                          ),
                          AppLinkButton(
                            label: AppConstants.websiteLabel,
                            icon: Icons.language_rounded,
                            url: config.websiteUrl,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const _UpdateLogsButton(),
                      const SizedBox(height: 18),
                      Text(
                        AppConstants.aboutNote,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LiveBroadcastInfoCard extends StatelessWidget {
  const _LiveBroadcastInfoCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppConstants.warmCream.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppConstants.softGold.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppConstants.ivory.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.sensors_rounded,
              color: AppConstants.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Siaran live kajian akan tersambung melalui server Radio Taqriibussunnah. Saat kajian live berlangsung, aplikasi otomatis memutar siaran langsung dari stream utama.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfigStatusCard extends StatelessWidget {
  const _ConfigStatusCard({required this.configProvider});

  final RadioConfigProvider configProvider;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final usingFallback = configProvider.usingFallback;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(
            usingFallback ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
            color: usingFallback
                ? colorScheme.onSurfaceVariant
                : colorScheme.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status konfigurasi',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  usingFallback ? 'Bawaan aplikasi' : 'Online',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (configProvider.isLoading)
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
          else
            IconButton(
              onPressed: configProvider.refresh,
              icon: const Icon(Icons.refresh_rounded, size: 20),
              color: colorScheme.primary,
              tooltip: 'Refresh konfigurasi',
            ),
        ],
      ),
    );
  }
}

class _UpdateLogsButton extends StatelessWidget {
  const _UpdateLogsButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const UpdateLogsPage()));
      },
      icon: const Icon(Icons.history_rounded, size: 20),
      label: const Text('Riwayat Pembaruan'),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.highlights});

  final List<String> highlights;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi resmi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in highlights) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.primary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 106,
      height: 106,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppConstants.ivory,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo_radio.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.radio, color: colorScheme.primary, size: 50);
          },
        ),
      ),
    );
  }
}
