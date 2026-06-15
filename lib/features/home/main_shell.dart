import 'package:flutter/material.dart';

import '../../core/radio_config_provider.dart';
import '../../theme_controller.dart';
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
      backgroundColor: colorScheme.surface,
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
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface.withValues(alpha: 0.7),
                shape: BoxShape.circle,
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
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: colorScheme.surface,
          indicatorColor: colorScheme.surfaceContainerHighest,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            );
          }),
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
