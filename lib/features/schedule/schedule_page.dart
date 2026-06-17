import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../../core/app_constants.dart';
import '../../core/radio_config_provider.dart';
import '../../core/remote_radio_config.dart';
import '../../widgets/app_link_button.dart';
import '../radio/radio_controller.dart';
import 'broadcast_schedule_data.dart';
import 'broadcast_schedule_item.dart';
import 'broadcast_schedule_model.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({
    required this.controller,
    required this.configProvider,
    super.key,
  });

  final RadioController controller;
  final RadioConfigProvider configProvider;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller, configProvider]),
      builder: (context, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final eventInfo = configProvider.eventInfo;
        final liveInfo = configProvider.liveInfo;
        final azuraCastLive = controller.nowPlaying?.isLive ?? false;
        final showLiveCard = azuraCastLive || liveInfo != null;
        final scheduleItems = configProvider.hasRemoteSchedule
            ? configProvider.remoteScheduleItems
                  .map(BroadcastScheduleModel.fromRemote)
                  .toList(growable: false)
            : broadcastScheduleItems;

        return ColoredBox(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 58, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppConstants.scheduleTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConfig.radioName,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (showLiveCard) ...[
                        _ActiveBroadcastCard(
                          controller: controller,
                          liveInfo: liveInfo,
                          azuraCastLive: azuraCastLive,
                        ),
                        const SizedBox(height: 14),
                      ],
                      if (eventInfo != null) ...[
                        _DaurohInfoCard(eventInfo: eventInfo),
                        const SizedBox(height: 22),
                      ],
                      _BroadcastScheduleSection(items: scheduleItems),
                      const SizedBox(height: 16),
                      Text(
                        'Jadwal dapat berubah sewaktu-waktu mengikuti kondisi siaran dan pengaturan playlist.',
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

class _ActiveBroadcastCard extends StatelessWidget {
  const _ActiveBroadcastCard({
    required this.controller,
    required this.liveInfo,
    required this.azuraCastLive,
  });

  final RadioController controller;
  final RemoteLiveInfo? liveInfo;
  final bool azuraCastLive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showPulse =
        azuraCastLive || (liveInfo?.showRedLiveIndicator ?? false);
    final nowPlayingTitle = controller.nowPlaying?.title ?? '';
    final nowPlayingText = controller.nowPlaying?.text ?? '';
    final nowPlayingPlaylist = controller.nowPlaying?.playlist ?? '';
    final fallbackTitle = nowPlayingTitle.isNotEmpty
        ? nowPlayingTitle
        : nowPlayingText;
    final title = _firstFilled([
      liveInfo?.title,
      'Kajian Live Sedang Berlangsung',
    ]);
    final topic = _firstFilled([liveInfo?.topic, fallbackTitle]);
    final speaker = _firstFilled([liveInfo?.speaker]);
    final timeText = _firstFilled([liveInfo?.timeText]);
    final description = _firstFilled([
      liveInfo?.description,
      nowPlayingPlaylist.isNotEmpty ? 'Playlist: $nowPlayingPlaylist' : null,
      'Siaran langsung dari stream utama Radio Taqriibussunnah.',
    ]);
    final cardColor = colorScheme.errorContainer.withValues(
      alpha: isDark ? 0.24 : 0.78,
    );
    final bodyColor = isDark
        ? AppConstants.cream.withValues(alpha: 0.9)
        : colorScheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.42)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RemoteImageBox(
              imageUrl: liveInfo?.imageUrl,
              icon: Icons.sensors_rounded,
              size: 58,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colorScheme.error,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                        ),
                      ),
                      if (showPulse) ...[
                        const SizedBox(width: 8),
                        const _LivePulseIndicator(),
                      ],
                    ],
                  ),
                  if (topic.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      topic,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: bodyColor,
                        fontWeight: FontWeight.w800,
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (speaker.isNotEmpty || timeText.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      [
                        speaker,
                        timeText,
                      ].where((item) => item.isNotEmpty).join(' - '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: bodyColor,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                  ],
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bodyColor,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  if (liveInfo?.buttonUrl != null) ...[
                    const SizedBox(height: 12),
                    AppLinkButton(
                      label: liveInfo!.buttonText,
                      icon: Icons.open_in_new_rounded,
                      url: liveInfo!.buttonUrl!,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LivePulseIndicator extends StatefulWidget {
  const _LivePulseIndicator();

  @override
  State<_LivePulseIndicator> createState() => _LivePulseIndicatorState();
}

class _LivePulseIndicatorState extends State<_LivePulseIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(
      begin: 0.82,
      end: 1.22,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacity = Tween<double>(
      begin: 0.55,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: const Color(0xFFE53935),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE53935).withValues(alpha: 0.38),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaurohInfoCard extends StatelessWidget {
  const _DaurohInfoCard({required this.eventInfo});

  final RemoteEventInfo eventInfo;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final details = [
      eventInfo.subtitle,
      eventInfo.speaker,
      eventInfo.dateText,
      eventInfo.timeText,
      eventInfo.location,
    ].where((item) => item.isNotEmpty).toList(growable: false);
    final cardColor = isDark
        ? const Color(0xFF173429)
        : AppConstants.warmCream.withValues(alpha: 0.72);
    final borderColor = AppConstants.softGold.withValues(
      alpha: isDark ? 0.44 : 0.38,
    );
    final titleColor = isDark ? AppConstants.ivory : AppConstants.primaryGreen;
    final detailColor = isDark ? AppConstants.cream : AppConstants.textMuted;
    final descriptionColor = isDark
        ? AppConstants.ivory.withValues(alpha: 0.94)
        : AppConstants.textMuted;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RemoteImageBox(
              imageUrl: eventInfo.imageUrl,
              icon: Icons.event_note_rounded,
              size: 64,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        eventInfo.title.isNotEmpty
                            ? eventInfo.title
                            : 'Info Dauroh / Event Khusus',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: titleColor,
                              fontWeight: FontWeight.w900,
                              height: 1.2,
                            ),
                      ),
                      const _InfoBadge(label: 'Pengumuman'),
                    ],
                  ),
                  for (final detail in details) ...[
                    const SizedBox(height: 5),
                    Text(
                      detail,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: detailColor,
                        fontWeight: FontWeight.w700,
                        height: 1.32,
                      ),
                    ),
                  ],
                  if (eventInfo.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      eventInfo.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: descriptionColor,
                        fontWeight: isDark ? FontWeight.w600 : null,
                        height: 1.35,
                      ),
                    ),
                  ],
                  if (eventInfo.buttonUrl != null) ...[
                    const SizedBox(height: 12),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: colorScheme.copyWith(
                          primary: isDark
                              ? AppConstants.softGold
                              : colorScheme.primary,
                        ),
                      ),
                      child: AppLinkButton(
                        label: eventInfo.buttonText,
                        icon: Icons.open_in_new_rounded,
                        url: eventInfo.buttonUrl!,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoteImageBox extends StatelessWidget {
  const _RemoteImageBox({
    required this.imageUrl,
    required this.icon,
    required this.size,
  });

  final String? imageUrl;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fallback = _ImageFallback(icon: icon);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: imageUrl == null
            ? fallback
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return fallback;
                },
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppConstants.ivory.withValues(alpha: 0.86),
        border: Border.all(
          color: AppConstants.softGold.withValues(alpha: 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          AppConstants.appLogo,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(icon, color: AppConstants.primaryGreen);
          },
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark
            ? AppConstants.softGold.withValues(alpha: 0.18)
            : AppConstants.ivory.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
        border: isDark
            ? Border.all(color: AppConstants.softGold.withValues(alpha: 0.34))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isDark ? AppConstants.ivory : AppConstants.primaryGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _BroadcastScheduleSection extends StatelessWidget {
  const _BroadcastScheduleSection({required this.items});

  final List<BroadcastScheduleModel> items;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Susunan Siaran Harian',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Urutan siaran dapat menyesuaikan pengaturan playlist di server.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 14),
        for (final entry in items.indexed) ...[
          BroadcastScheduleItem(model: entry.$2, index: entry.$1),
          if (entry.$1 != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

String _firstFilled(List<String?> values) {
  for (final value in values) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isNotEmpty) {
      return trimmed;
    }
  }

  return '';
}
