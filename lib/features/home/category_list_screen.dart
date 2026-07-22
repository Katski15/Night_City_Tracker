import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/locations_provider.dart';
import '../../core/widgets/location_card.dart';
import '../../core/widgets/location_detail_screen.dart';

/// Shows all items within a single category. Uses its own local search
/// text rather than the shared provider filter, so it doesn't interfere
/// with the Search tab's state.
class CategoryListScreen extends StatefulWidget {
  final String category;
  const CategoryListScreen({super.key, required this.category});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationsProvider>();
    final items = locations.all
        .where((i) => i.category == widget.category)
        .where((i) =>
            _query.isEmpty ||
            i.name.toLowerCase().contains(_query.toLowerCase()) ||
            i.landmark.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.category.toUpperCase())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'FILTER THIS CATEGORY',
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text('NO RESULTS',
                        style: Theme.of(context).textTheme.bodySmall))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
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
