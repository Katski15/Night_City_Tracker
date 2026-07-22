import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/nc_theme.dart';
import '../../core/providers/locations_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/widgets/clipped_panel.dart';
import '../../core/widgets/category_colors.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationsProvider>();
    final progress = context.watch<ProgressProvider>();

    if (locations.loading || !progress.loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final total = locations.all.length;
    final overallRatio = progress.ratio(total);

    return Scaffold(
      appBar: AppBar(title: const Text('PROGRESS')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClippedPanel(
            accentColor: NCColors.cyan,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OVERALL COMPLETION',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: NCColors.textSecondary, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text('${progress.foundIds.length} / $total',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: LinearProgressIndicator(
                      value: overallRatio, minHeight: 8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('BY CATEGORY', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          for (final category in locations.categories) ...[
            _CategoryRow(
              category: category,
              items: locations.all.where((i) => i.category == category).toList(),
              foundIds: progress.foundIds,
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: NCColors.panel,
                  title: const Text('RESET PROGRESS?'),
                  content: const Text(
                      'This clears every item you\'ve marked as found. This cannot be undone.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('CANCEL')),
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('RESET')),
                  ],
                ),
              );
              if (confirmed == true) {
                await progress.reset();
              }
            },
            icon: const Icon(Icons.restart_alt),
            label: const Text('RESET PROGRESS'),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final List items;
  final Set<String> foundIds;

  const _CategoryRow({
    required this.category,
    required this.items,
    required this.foundIds,
  });

  @override
  Widget build(BuildContext context) {
    final found = items.where((i) => foundIds.contains(i.id)).length;
    final ratio = items.isEmpty ? 0.0 : found / items.length;
    final accent = categoryColor(category);

    return ClippedPanel(
      accentColor: accent,
      clipSize: 12,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge),
              Text('$found / ${items.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: NCColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: ratio, minHeight: 6, color: accent),
        ],
      ),
    );
  }
}
