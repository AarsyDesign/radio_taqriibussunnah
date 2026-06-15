import 'package:flutter/material.dart';

import '../../core/app_config.dart';
import '../../core/app_constants.dart';
import 'schedule_item.dart';
import 'schedule_model.dart';
import 'schedule_service.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScheduleService _scheduleService;
  late Future<List<ScheduleModel>> _scheduleFuture;

  Future<void> _refreshSchedule() async {
    setState(() {
      _scheduleFuture = _scheduleService.fetchSchedule();
    });
    await _scheduleFuture;
  }

  @override
  void initState() {
    super.initState();
    _scheduleService = ScheduleService();
    _scheduleFuture = _scheduleService.fetchSchedule();
  }

  @override
  void dispose() {
    _scheduleService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppConstants.scheduleTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConfig.radioName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.center,
                child: TextButton.icon(
                  onPressed: _refreshSchedule,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Segarkan Jadwal'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              RefreshIndicator(
                onRefresh: _refreshSchedule,
                color: colorScheme.primary,
                backgroundColor: colorScheme.surface,
                child: FutureBuilder<List<ScheduleModel>>(
                  future: _scheduleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colorScheme.primary,
                          ),
                        ),
                      );
                    }

                    final items = snapshot.data ?? <ScheduleModel>[];
                    final hasLiveItem = items.any((item) => item.isLive);

                    if (hasLiveItem) {
                      final liveCount = items
                          .where((item) => item.isLive)
                          .length;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Text(
                                '${AppConstants.scheduleLiveLabel} • $liveCount program',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: colorScheme.secondary,
                                      fontWeight: FontWeight.w800,
                                    ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Column(
                            children: [
                              for (final item in items) ...[
                                ScheduleItemWidget(model: item),
                                const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ],
                      );
                    }

                    if (items.isEmpty) {
                      return Text(
                        'Tidak ada jadwal yang tersedia saat ini.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    }

                    return Column(
                      children: [
                        for (final item in items) ...[
                          ScheduleItemWidget(model: item),
                          const SizedBox(height: 12),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppConstants.scheduleNote,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
