import 'package:flutter/material.dart';

class UpdateLogsPage extends StatelessWidget {
  const UpdateLogsPage({super.key});

  static const List<_UpdateLogEntry> _entries = [
    _UpdateLogEntry(
      version: '1.0.0',
      date: 'Rilis awal',
      changes: [
        'Pemutar radio online',
        'Informasi sedang diputar',
        'Jadwal kajian',
        'Tautan resmi Telegram dan website',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Riwayat Pembaruan'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
          itemBuilder: (context, index) {
            final entry = _entries[index];
            return _UpdateLogCard(entry: entry);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: _entries.length,
        ),
      ),
    );
  }
}

class _UpdateLogCard extends StatelessWidget {
  const _UpdateLogCard({required this.entry});

  final _UpdateLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Versi ${entry.version}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                entry.date,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final change in entry.changes) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colorScheme.tertiary,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    change,
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

class _UpdateLogEntry {
  const _UpdateLogEntry({
    required this.version,
    required this.date,
    required this.changes,
  });

  final String version;
  final String date;
  final List<String> changes;
}
