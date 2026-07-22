import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/nc_theme.dart';
import '../../core/providers/locations_provider.dart';
import '../../core/providers/progress_provider.dart';
import '../../core/widgets/category_colors.dart';
import '../../core/widgets/location_detail_screen.dart';
import 'district_layout.dart';
import 'district_map_painter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _categoryFilter;
  final _transformController = TransformationController();

  @override
  Widget build(BuildContext context) {
    final locations = context.watch<LocationsProvider>();
    final progress = context.watch<ProgressProvider>();

    if (locations.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final categories = locations.categories;
    final visibleItems = _categoryFilter == null
        ? locations.all
        : locations.all.where((i) => i.category == _categoryFilter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('MAP')),
      body: Column(
        children: [
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
                    selected: _categoryFilter == null,
                    onSelected: (_) => setState(() => _categoryFilter = null),
                  ),
                ),
                for (final c in categories)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(c.toUpperCase()),
                      selected: _categoryFilter == c,
                      selectedColor: categoryColor(c),
                      onSelected: (_) => setState(
                          () => _categoryFilter = _categoryFilter == c ? null : c),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.5,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(40),
              child: SizedBox(
                width: mapCanvasSize.width,
                height: mapCanvasSize.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: DistrictMapPainter()),
                    ),
                    for (final item in visibleItems)
                      Builder(builder: (context) {
                        final zone = zoneFor(item.district);
                        final pos = pinPosition(item.id, zone.rect);
                        final found = progress.isFound(item.id);
                        final color = categoryColor(item.category);
                        return Positioned(
                          left: pos.dx - 10,
                          top: pos.dy - 10,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    LocationDetailScreen(item: item),
                              ),
                            ),
                            child: Opacity(
                              opacity: found ? 0.4 : 1,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 2),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: NCColors.divider)),
            ),
            child: Text(
              'Pinch to zoom, drag to pan. Dimmed pins are already found. '
              'Map layout is schematic, not to exact in-game scale.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
