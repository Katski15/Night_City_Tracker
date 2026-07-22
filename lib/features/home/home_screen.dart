import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/nc_theme.dart';
import '../../core/providers/locations_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/widgets/clipped_panel.dart';
import '../../core/widgets/category_colors.dart';
import 'category_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationsProvider>();
    final progress = context.watch<ProgressProvider>();

    if (locations.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (locations.error != null) {
      return Scaffold(body: Center(child: Text(locations.error!)));
    }

    final total = locations.all.length;
    final foundCount = progress.foundIds.length;
    final overallRatio = total == 0 ? 0.0 : foundCount / total;
    final categories = locations.categories;

    return Scaffold(
      appBar: AppBar(title: const Text('NIGHT CITY TRACKER')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClippedPanel(
            accentColor: NCColors.cyan,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OVERALL PROGRESS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: NCColors.textSecondary, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                Text('$foundCount / $total',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: overallRatio, minHeight: 8),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('CATEGORIES', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.35,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              final items =
                  locations.all.where((i) => i.category == category).toList();
              final found =
                  items.where((i) => progress.isFound(i.id)).length;
              final accent = categoryColor(category);

              return InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryListScreen(category: category),
                  ),
                ),
                child: ClippedPanel(
                  accentColor: accent,
                  clipSize: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        category.toUpperCase(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$found / ${items.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: NCColors.textSecondary)),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: items.isEmpty ? 0 : found / items.length,
                            minHeight: 5,
                            color: accent,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
