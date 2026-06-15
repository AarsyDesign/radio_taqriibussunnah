import 'package:flutter/material.dart';

import '../../core/app_constants.dart';
import '../../core/radio_config_provider.dart';
import '../../core/theme/theme_controller.dart';
import '../about/about_page.dart';
import '../radio/radio_controller.dart';
import '../radio/radio_page.dart';
import '../radio/widgets/mini_player.dart';
import '../schedule/schedule_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({required this.themeController, super.key});

  final ThemeController themeController;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final RadioConfigProvider _configProvider;
  late final RadioController _radioController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _configProvider = RadioConfigProvider()..load();
    _radioController = RadioController(configProvider: _configProvider);
  }

  @override
  void dispose() {
    _radioController.dispose();
    _configProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    RadioPage(controller: _radioController),
                    const SchedulePage(),
                    AboutPage(configProvider: _configProvider),
                  ],
                ),
              ),
              MiniPlayer(controller: _radioController),
            ],
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 16,
            right: 16,
            child: Material(
              color: colorScheme.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(999),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.deepGreen.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    widget.themeController.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  color: colorScheme.primary,
                  onPressed: widget.themeController.toggleTheme,
                  tooltip: widget.themeController.isDarkMode
                      ? 'Mode Terang'
                      : 'Mode Gelap',
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(
            top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.18)),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.radio_rounded),
              label: 'Radio',
            ),
            const NavigationDestination(
              icon: Icon(Icons.event_note_rounded),
              label: 'Jadwal',
            ),
            const NavigationDestination(
              icon: Icon(Icons.info_outline_rounded),
              label: 'Tentang',
            ),
          ],
        ),
      ),
    );
  }
}
