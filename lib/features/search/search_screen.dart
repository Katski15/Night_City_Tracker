import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locations_provider.dart';
import '../../core/widgets/location_card.dart';
import '../../core/widgets/location_detail_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('SEARCH')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'SEARCH NAME, LANDMARK, OR TAG',
              ),
              onChanged: locations.setQuery,
            ),
          ),
          if (locations.districts.isNotEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: const Text('ALL DISTRICTS'),
                      selected: locations.districtFilter == null,
                      onSelected: (_) => locations.setDistrictFilter(null),
                    ),
                  ),
                  for (final d in locations.districts)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(d.toUpperCase()),
                        selected: locations.districtFilter == d,
                        onSelected: (_) => locations.setDistrictFilter(
                            locations.districtFilter == d ? null : d),
                      ),
                    ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Expanded(
            child: locations.filtered.isEmpty
                ? Center(
                    child: Text('NO RESULTS',
                        style: Theme.of(context).textTheme.bodySmall))
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
