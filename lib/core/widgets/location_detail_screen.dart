import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/nc_theme.dart';
import '../models/location_item.dart';
import '../providers/progress_provider.dart';
import 'clipped_panel.dart';
import 'category_colors.dart';

class LocationDetailScreen extends StatelessWidget {
  final LocationItem item;
  const LocationDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final found = progress.isFound(item.id);
    final accent = categoryColor(item.category);

    return Scaffold(
      appBar: AppBar(title: Text(item.name.toUpperCase())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClippedPanel(
            accentColor: accent,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  color: accent,
                  child: Text(
                    item.category.toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1),
                  ),
                ),
                const SizedBox(height: 16),
                _Field(label: 'District', value: item.district),
                _Field(label: 'Landmark', value: item.landmark),
                _Field(label: 'Details', value: item.description),
                if (item.requirements != null)
                  _Field(label: 'Requirements', value: item.requirements!),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => progress.toggle(item.id),
            icon: Icon(found ? Icons.check_circle : Icons.radio_button_unchecked),
            label: Text(found ? 'MARKED AS FOUND' : 'MARK AS FOUND'),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: NCColors.textSecondary, letterSpacing: 1.5),
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
