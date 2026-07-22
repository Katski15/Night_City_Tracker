import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/nc_theme.dart';
import '../../core/providers/locations_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/widgets/location_card.dart';
import '../../core/widgets/location_detail_screen.dart';

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

    final categories = locations.categories;
    final total = locations.all.length;
    final foundCount = progress.foundIds.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NIGHT CITY TRACKER'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$foundCount / $total LOGGED',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: NCColors.cyan, letterSpacing: 1.5),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (categories.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: const Text('ALL'),
                      selected: locations.categoryFilter == null,
                      onSelected: (_) => locations.setCategoryFilter(null),
                    ),
                  ),
                  for (final c in categories)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(c.toUpperCase()),
                        selected: locations.categoryFilter == c,
                        onSelected: (_) => locations.setCategoryFilter(
                            locations.categoryFilter == c ? null : c),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: locations.filtered.isEmpty
                ? Center(
                    child: Text('NO ENTRIES MATCH THIS FILTER',
                        style: Theme.of(context).textTheme.bodySmall),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 12),
                    itemCount: locations.filtered.length,
                    itemBuilder: (context, index) {
                      final item = locations.filtered[index];
                      return LocationCard(
                        item: item,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LocationDetailScreen(item: item),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
