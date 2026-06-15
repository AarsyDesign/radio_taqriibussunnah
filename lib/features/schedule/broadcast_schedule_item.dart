import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import 'broadcast_schedule_model.dart';

class BroadcastScheduleItem extends StatelessWidget {
  const BroadcastScheduleItem({
    required this.model,
    required this.index,
    super.key,
  });

  final BroadcastScheduleModel model;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF143529) : AppConstants.ivory;
    final numberColor = isDark
        ? AppConstants.softGold.withValues(alpha: 0.18)
        : AppConstants.cream;
    final titleColor = isDark ? AppConstants.ivory : colorScheme.onSurface;
    final bodyColor = isDark
        ? AppConstants.cream.withValues(alpha: 0.88)
        : colorScheme.onSurfaceVariant;
    final primaryTextColor = isDark
        ? AppConstants.softGold
        : AppConstants.primaryGreen;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppConstants.softGold.withValues(alpha: isDark ? 0.36 : 0.26),
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepGreen.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: numberColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppConstants.softGold.withValues(alpha: 0.35),
                ),
              ),
              child: Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w900,
                ),
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
                        model.time,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: primaryTextColor,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (model.isLiveSlot) const _LiveBadge(),
                      if (model.category != null)
                        _CategoryBadge(label: model.category!),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    model.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    model.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bodyColor,
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

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppConstants.warmCream.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppConstants.mediumGreen,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppConstants.softGold.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppConstants.softGold.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        child: Text(
          'Live',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppConstants.primaryGreen,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
