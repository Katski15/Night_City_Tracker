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
  double _fitScale = 1;
  bool _didInitialFit = false;

  void _fitToWidth(double viewportWidth) {
    final scale = viewportWidth / mapCanvasSize.width;
    _fitScale = scale;
    _transformController.value = Matrix4.identity()..scale(scale);
  }

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
            child: LayoutBuilder(builder: (context, constraints) {
              if (!_didInitialFit) {
                _didInitialFit = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _fitToWidth(constraints.maxWidth));
                  }
                });
              }
              return InteractiveViewer(
                transformationController: _transformController,
                minScale: _fitScale * 0.6,
                maxScale: _fitScale * 5,
                boundaryMargin: const EdgeInsets.all(200),
                constrained: false,
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
                            left: pos.dx - 11,
                            top: pos.dy - 11,
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LocationDetailScreen(item: item),
                                ),
                              ),
                              child: Opacity(
                                opacity: found ? 0.35 : 1,
                                child: Container(
                                  width: 22,
                                  height: 22,
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
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: NCColors.divider)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    for (final c in categories)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: categoryColor(c),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(c.toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Pinch to zoom, drag to pan. Dimmed = already found. Schematic layout, not exact in-game scale.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
