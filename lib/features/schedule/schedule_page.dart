import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../../core/app_constants.dart';
import 'broadcast_schedule_data.dart';
import 'broadcast_schedule_item.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

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
                  const _DaurohInfoCard(),
                  const SizedBox(height: 22),
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
                  const SizedBox(height: 24),
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
