import 'dart:math';
import 'dart:ui';

/// A simplified, hand-drawn schematic layout of Night City's districts —
/// NOT a reproduction of the game's actual map art, just rough relative
/// positioning so items can be plotted somewhere sensible and tapped.
class DistrictZone {
  final String label;
  final Rect rect;
  const DistrictZone(this.label, this.rect);
}

/// Canvas is a fixed 1000x900 coordinate space; the map widget scales
/// this to fit the screen.
const mapCanvasSize = Size(1000, 900);

final List<DistrictZone> districtZones = [
  const DistrictZone('Watson', Rect.fromLTWH(260, 40, 480, 220)),
  const DistrictZone('Westbrook', Rect.fromLTWH(100, 280, 280, 220)),
  const DistrictZone('City Center', Rect.fromLTWH(400, 280, 260, 160)),
  const DistrictZone('Heywood', Rect.fromLTWH(360, 460, 340, 180)),
  const DistrictZone('Santo Domingo', Rect.fromLTWH(620, 460, 320, 240)),
  const DistrictZone('Pacifica', Rect.fromLTWH(40, 520, 280, 220)),
  const DistrictZone('Dogtown', Rect.fromLTWH(40, 760, 220, 100)),
  const DistrictZone('Badlands', Rect.fromLTWH(700, 720, 260, 140)),
  const DistrictZone('Other / Special', Rect.fromLTWH(760, 40, 200, 200)),
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
      return districtZones.firstWhere(
        (z) => z.label.toLowerCase().contains(
              key == 'outskirts' ? 'badlands' : key,
            ),
      );
    }
  }
  return districtZones.last; // "Other / Special"
}

/// Deterministic pseudo-random position within a zone, stable across
/// rebuilds since it's seeded from the item's own id.
Offset pinPosition(String itemId, Rect zone) {
  final rand = Random(itemId.hashCode);
  const pad = 22.0;
  final w = (zone.width - pad * 2).clamp(1, double.infinity);
  final h = (zone.height - pad * 2).clamp(1, double.infinity);
  final dx = zone.left + pad + rand.nextDouble() * w;
  final dy = zone.top + pad + rand.nextDouble() * h;
  return Offset(dx, dy);
}
