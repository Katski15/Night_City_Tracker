import 'dart:math';
import 'dart:ui';

/// A simplified, hand-drawn schematic layout of Night City's districts —
/// NOT a reproduction of the game's actual map art, just rough relative
/// positioning (portrait orientation, non-overlapping boxes) so items can
/// be plotted somewhere sensible and tapped.
class DistrictZone {
  final String label;
  final Rect rect;
  const DistrictZone(this.label, this.rect);
}

/// Canvas is a fixed 800x1200 portrait coordinate space; the map widget
/// scales this to fit the screen width on load.
const mapCanvasSize = Size(800, 1200);

final List<DistrictZone> districtZones = [
  const DistrictZone('Watson', Rect.fromLTWH(100, 40, 480, 220)),
  const DistrictZone('Other / Special', Rect.fromLTWH(600, 40, 180, 200)),
  const DistrictZone('Westbrook', Rect.fromLTWH(40, 280, 320, 220)),
  const DistrictZone('City Center', Rect.fromLTWH(380, 280, 300, 200)),
  const DistrictZone('Heywood', Rect.fromLTWH(280, 520, 340, 200)),
  const DistrictZone('Pacifica', Rect.fromLTWH(40, 520, 220, 260)),
  const DistrictZone('Santo Domingo', Rect.fromLTWH(460, 740, 300, 260)),
  const DistrictZone('Dogtown', Rect.fromLTWH(40, 800, 220, 140)),
  const DistrictZone('Badlands', Rect.fromLTWH(40, 1020, 720, 140)),
];

/// Maps a free-form district string from the data (which may say things
/// like "Pacifica / Heywood border" or "N/A (delivered to storage)")
/// onto one of our schematic zones.
DistrictZone zoneFor(String district) {
  final d = district.toLowerCase();
  const order = [
    'dogtown',
    'santo domingo',
    'pacifica',
    'westbrook',
    'heywood',
    'watson',
    'city center',
    'badlands',
    'outskirts',
  ];
  for (final key in order) {
    if (d.contains(key)) {
      final matchLabel = key == 'outskirts' ? 'badlands' : key;
      return districtZones.firstWhere(
        (z) => z.label.toLowerCase().contains(matchLabel),
      );
    }
  }
  return districtZones.firstWhere((z) => z.label == 'Other / Special');
}

/// Deterministic pseudo-random position within a zone, stable across
/// rebuilds since it's seeded from the item's own id.
Offset pinPosition(String itemId, Rect zone) {
  final rand = Random(itemId.hashCode);
  const pad = 26.0;
  final w = (zone.width - pad * 2).clamp(1, double.infinity);
  final h = (zone.height - pad * 2).clamp(1, double.infinity);
  final dx = zone.left + pad + rand.nextDouble() * w;
  // keep top area clear for the label
  final dy = zone.top + 36 + rand.nextDouble() * (h - 20).clamp(1, double.infinity);
  return Offset(dx, dy);
}
