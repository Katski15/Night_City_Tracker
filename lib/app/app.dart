import 'package:flutter/material.dart';
import 'nc_theme.dart';
import '../features/home/home_screen.dart';
import '../features/search/search_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/settings/settings_screen.dart';

class NightCityTrackerApp extends StatelessWidget {
  const NightCityTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Night City Tracker',
      debugShowCheckedModeBanner: false,
      theme: NCTheme.dark,
      home: const _RootNav(),
    );
  }
}

class _RootNav extends StatefulWidget {
  const _RootNav();

  @override
  State<_RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<_RootNav> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SearchScreen(),
    ProgressScreen(),
    SettingsScreen(),
  ];

  static const _icons = [
    Icons.location_on_outlined,
    Icons.search,
    Icons.checklist,
    Icons.tune,
  ];
  static const _selectedIcons = [
    Icons.location_on,
    Icons.search,
    Icons.checklist,
    Icons.tune,
  ];
  static const _labels = ['HOME', 'SEARCH', 'PROGRESS', 'SETTINGS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: NCColors.divider)),
        ),
        child: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            for (var i = 0; i < _labels.length; i++)
              NavigationDestination(
                icon: Icon(_icons[i]),
                selectedIcon: Icon(_selectedIcons[i]),
                label: _labels[i],
              ),
          ],
        ),
      ),
    );
  }
}
