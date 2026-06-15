import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/app_constants.dart';
import '../../widgets/app_link_button.dart';
import 'radio_controller.dart';

class RadioPage extends StatefulWidget {
  const RadioPage({required this.controller, super.key});

  final RadioController controller;

  @override
  State<RadioPage> createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 58, 20, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.sizeOf(context).height -
                      MediaQuery.paddingOf(context).vertical -
                      56,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _LogoImage(),
                        const SizedBox(height: 22),
                        Text(
                          controller.config.radioName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w900,
                                height: 1.12,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.config.radioSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                        ),
                        const SizedBox(height: 18),
                        _NowPlayingCard(
                          title:
                              controller.nowPlaying?.title ??
                              controller.config.radioName,
                          artist:
                              controller.nowPlaying?.artist ??
                              controller.config.radioSubtitle,
                          isOnline: controller.nowPlaying?.isOnline ?? false,
                          isLive: controller.nowPlaying?.isLive ?? false,
                          listeners: controller.nowPlaying?.listeners,
                          playlist: controller.nowPlaying?.playlist,
                          isLoading: controller.isLoadingNowPlaying,
                          onRefresh: controller.refreshNowPlaying,
                        ),
                        const SizedBox(height: 22),
                        _PlayButton(
                          showPause: controller.userWantsToPlay,
                          isLoading: controller.isLoading,
                          onPressed: controller.togglePlay,
                        ),
                        const SizedBox(height: 18),
                        if (controller.canRetry) ...[
                          _RetryStatusCard(
                            title: controller.status == RadioStatus.offline
                                ? AppConstants.noConnectionTitle
                                : AppConstants.unavailableTitle,
                            subtitle: controller.status == RadioStatus.offline
                                ? AppConstants.noConnectionSubtitle
                                : AppConstants.unavailableSubtitle,
                            onRetry: controller.retry,
                          ),
                          const SizedBox(height: 14),
                        ],
                        _StatusPill(
                          message: controller.statusMessage,
                          showProgress: controller.isReconnecting,
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            AppLinkButton(
                              label: AppConstants.telegramLabel,
                              icon: Icons.telegram,
                              url: controller.config.telegramUrl,
                            ),
                            AppLinkButton(
                              label: AppConstants.websiteLabel,
                              icon: Icons.language_rounded,
                              url: controller.config.websiteUrl,
                            ),
                            OutlinedButton.icon(
                              onPressed: () => SharePlus.instance.share(
                                ShareParams(
                                  text:
                                      'Dengarkan ${controller.config.radioName} di ${controller.config.websiteUrl}',
                                  subject: controller.config.radioName,
                                ),
                              ),
                              icon: const Icon(Icons.share_rounded, size: 18),
                              label: const Text(AppConstants.shareLabel),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          AppConstants.footerText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                letterSpacing: 0.2,
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
      ),
    );
  }
}

class _RetryStatusCard extends StatelessWidget {
  const _RetryStatusCard({
    required this.title,
    required this.subtitle,
    required this.onRetry,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colorScheme.secondary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

class _NowPlayingCard extends StatelessWidget {
  const _NowPlayingCard({
    required this.title,
    required this.artist,
    required this.isOnline,
    required this.isLive,
    required this.listeners,
    required this.playlist,
    required this.isLoading,
    required this.onRefresh,
  });

  final String title;
  final String artist;
  final bool isOnline;
  final bool isLive;
  final int? listeners;
  final String? playlist;
  final bool isLoading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF143529) : AppConstants.ivory;
    final titleColor = isDark ? AppConstants.ivory : colorScheme.onSurface;
    final subtitleColor = isDark
        ? AppConstants.cream.withValues(alpha: 0.9)
        : colorScheme.onSurfaceVariant;
    final badgeTextColor = isDark ? AppConstants.ivory : colorScheme.primary;
    final dividerColor = AppConstants.softGold.withValues(
      alpha: isDark ? 0.34 : 0.24,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppConstants.softGold.withValues(alpha: isDark ? 0.36 : 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.deepGreen.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.graphic_eq_rounded,
                color: colorScheme.secondary,
                size: 18,
              ),
              const SizedBox(width: 8),
              if (isLive) ...[
                const _LivePulseIndicator(),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  isLive ? 'Live sedang berlangsung' : 'Sedang diputar',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: isLoading ? null : onRefresh,
                icon: isLoading
                    ? SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          color: colorScheme.secondary,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Refresh'),
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: dividerColor, height: 1),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          if (artist.isNotEmpty) ...[
            const SizedBox(height: 5),
            Text(
              artist,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: subtitleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          if (playlist != null && playlist!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Playlist: ${playlist!.trim()}',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _BroadcastStatusBadge(
                isOnline: isOnline,
                isLive: isLive,
                textColor: badgeTextColor,
              ),
              if (listeners != null) _ListenersBadge(listeners: listeners!),
            ],
          ),
        ],
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

class _BroadcastStatusBadge extends StatelessWidget {
  const _BroadcastStatusBadge({
    required this.isOnline,
    required this.isLive,
    required this.textColor,
  });

  final bool isOnline;
  final bool isLive;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isOnline
        ? colorScheme.tertiary
        : colorScheme.onSurfaceVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          isLive
              ? 'Live'
              : isOnline
              ? 'Sedang siaran'
              : 'Belum siaran',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isOnline ? textColor : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ListenersBadge extends StatelessWidget {
  const _ListenersBadge({required this.listeners});

  final int listeners;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          'Pendengar: $listeners',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w800,
          ),
        ),
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
      width: 116,
      height: 116,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppConstants.ivory,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/logo_radio.jpg',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.radio, color: colorScheme.primary, size: 52);
          },
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.message, required this.showProgress});

  final String message;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showProgress) ...[
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.showPause,
    required this.isLoading,
    required this.onPressed,
  });

  final bool showPause;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icon = showPause ? Icons.pause_rounded : Icons.play_arrow_rounded;

    return Column(
      children: [
        SizedBox(
          width: 112,
          height: 112,
          child: FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              disabledBackgroundColor: colorScheme.secondary.withValues(
                alpha: 0.5,
              ),
              foregroundColor: colorScheme.onPrimary,
              disabledForegroundColor: colorScheme.onPrimary.withValues(
                alpha: 0.7,
              ),
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: colorScheme.onPrimary,
                      strokeWidth: 3,
                    ),
                  )
                : Icon(icon, size: 58),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          showPause ? 'Tekan untuk menjeda siaran' : AppConstants.playHint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
