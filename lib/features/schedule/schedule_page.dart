import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../../core/app_constants.dart';
import '../radio/radio_controller.dart';
import 'broadcast_schedule_data.dart';
import 'broadcast_schedule_item.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({required this.controller, super.key});

  final RadioController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                _ActiveBroadcastCard(controller: controller),
                  const SizedBox(height: 14),
                  const _DaurohInfoCard(),
                  const SizedBox(height: 22),
                  const _BroadcastScheduleSection(),
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
  }
}

class _ActiveBroadcastCard extends StatelessWidget {
  const _ActiveBroadcastCard({required this.controller});

  final RadioController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final isLive = controller.nowPlaying?.isLive ?? false;
        
        final cardColor = isLive
            ? colorScheme.errorContainer.withValues(alpha: isDark ? 0.25 : 0.8)
            : (isDark ? const Color(0xFF143529) : AppConstants.ivory.withValues(alpha: 0.9));
        
        final borderColor = isLive
            ? colorScheme.error.withValues(alpha: 0.5)
            : AppConstants.softGold.withValues(alpha: isDark ? 0.36 : 0.28);
            
        final titleColor = isLive
            ? colorScheme.error
            : (isDark ? AppConstants.ivory : colorScheme.onSurface);
            
        final subtitleColor = isDark
            ? AppConstants.cream.withValues(alpha: 0.9)
            : colorScheme.onSurfaceVariant;

        final nowPlayingTitle = controller.nowPlaying?.title;
        final nowPlayingText = controller.nowPlaying?.text;
        final titleData = (nowPlayingTitle != null && nowPlayingTitle.isNotEmpty)
            ? nowPlayingTitle
            : (nowPlayingText != null && nowPlayingText.isNotEmpty ? nowPlayingText : '');
        
        final playlist = controller.nowPlaying?.playlist;

        return DecoratedBox(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isLive
                        ? colorScheme.error.withValues(alpha: 0.15)
                        : AppConstants.softGold.withValues(alpha: isDark ? 0.2 : 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isLive ? Icons.sensors_rounded : Icons.graphic_eq_rounded,
                    color: isLive ? colorScheme.error : (isDark ? AppConstants.softGold : colorScheme.primary),
                    size: 21,
                  ),
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
                              isLive ? 'Kajian Live Sedang Berlangsung' : 'Siaran aktif / AutoDJ',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: titleColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (isLive) ...[
                            const SizedBox(width: 8),
                            const _LivePulseIndicator(),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (isLive && titleData.isNotEmpty) ...[
                        Text(
                          titleData,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subtitleColor,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        if (playlist != null && playlist.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Playlist: $playlist',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: subtitleColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ] else ...[
                        Text(
                          'Siaran berjalan melalui stream utama Radio Taqriibussunnah.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subtitleColor,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
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
      },
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
  const _DaurohInfoCard();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppConstants.warmCream.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppConstants.softGold.withValues(alpha: 0.38),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppConstants.ivory,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.event_note_rounded,
                color: AppConstants.primaryGreen,
              ),
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
                        'Info Dauroh / Event Khusus',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: AppConstants.primaryGreen,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const _InfoBadge(label: 'Pengumuman'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Informasi kegiatan khusus akan ditampilkan di sini saat tersedia.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.textMuted,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppConstants.ivory.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppConstants.primaryGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _BroadcastScheduleSection extends StatelessWidget {
  const _BroadcastScheduleSection();

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
        for (final entry in broadcastScheduleItems.indexed) ...[
          BroadcastScheduleItem(model: entry.$2, index: entry.$1),
          if (entry.$1 != broadcastScheduleItems.length - 1)
            const SizedBox(height: 12),
        ],
      ],
    );
  }
}
