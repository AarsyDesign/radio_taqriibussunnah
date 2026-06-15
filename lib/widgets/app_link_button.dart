import 'package:flutter/material.dart';

import '../core/app_links.dart';

class AppLinkButton extends StatelessWidget {
  const AppLinkButton({
    required this.label,
    required this.icon,
    required this.url,
    super.key,
  });

  final String label;
  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OutlinedButton(
      onPressed: () => _openLink(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.secondary.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Flexible(child: Text(label)),
        ],
      ),
    );
  }

  Future<void> _openLink(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final opened = await AppLinks.openUrl(url);

    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka link')),
      );
    }
  }
}
