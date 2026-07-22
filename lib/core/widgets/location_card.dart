import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/nc_theme.dart';
import '../models/location_item.dart';
import '../providers/progress_provider.dart';
import 'clipped_panel.dart';
import 'category_colors.dart';

class LocationCard extends StatelessWidget {
  final LocationItem item;
  final VoidCallback? onTap;

  const LocationCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final found = progress.isFound(item.id);
    final accent = categoryColor(item.category);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: found ? 0.55 : 1,
          child: ClippedPanel(
            accentColor: accent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            color: accent,
                            child: Text(
                              item.category.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.district.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: NCColors.textSecondary,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              decoration:
                                  found ? TextDecoration.lineThrough : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.landmark,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    found ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: found ? NCColors.cyan : NCColors.textSecondary,
                  ),
                  onPressed: () => progress.toggle(item.id),
                  tooltip: found ? 'Mark as not found' : 'Mark as found',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
