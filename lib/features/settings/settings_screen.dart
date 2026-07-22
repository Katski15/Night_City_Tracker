import 'package:flutter/material.dart';
import '../../app/nc_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        children: [
          const _SectionLabel('DATA SOURCE'),
          const ListTile(
            title: Text('Local asset file'),
            subtitle: Text(
                'Item locations are bundled locally in assets/data/locations.json. '
                'Edit that file to add or update entries.'),
          ),
          const _SectionLabel('ABOUT'),
          const ListTile(
            title: Text('Night City Tracker'),
            subtitle: Text(
                'A fan-made companion tracker. Not affiliated with or endorsed by CD Projekt Red.'),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: NCColors.yellow, letterSpacing: 1.5),
      ),
    );
  }
}
