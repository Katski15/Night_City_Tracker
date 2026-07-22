import 'dart:math';
import 'package:flutter/material.dart';
import '../../app/nc_theme.dart';
import 'district_layout.dart';

/// Distinct tint per district so the map reads like a real zoned city map
/// rather than identical gray boxes — purely my own color scheme, not
/// derived from any game asset.
const Map<String, Color> _districtTint = {
  'Watson': Color(0xFF3A2E12),
  'Westbrook': Color(0xFF0F2E33),
  'City Center': Color(0xFF231A33),
  'Heywood': Color(0xFF3A1F14),
  'Pacifica': Color(0xFF0E2036),
  'Santo Domingo': Color(0xFF1D2A1A),
  'Dogtown': Color(0xFF33141A),
  'Badlands': Color(0xFF2B2412),
  'Other / Special': Color(0xFF241830),
};

class DistrictMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base "asphalt" backdrop
    final base = Paint()..color = const Color(0xFF0A0A0C);
    canvas.drawRect(Offset.zero & size, base);

    // City block grid lines across the whole canvas
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1.5;
    const step = 42.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    // A few thicker "arterial road" lines for visual interest
    final roadPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..strokeWidth = 10;
    canvas.drawLine(Offset(0, 500), Offset(size.width, 500), roadPaint);
    canvas.drawLine(Offset(380, 0), Offset(380, size.height), roadPaint);

    final border = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (final zone in districtZones) {
      final tint = _districtTint[zone.label] ?? NCColors.panel;
      final fill = Paint()..color = tint;

      // Slightly irregular polygon (one notched corner, deterministic
      // per district) instead of a plain rectangle, for a less
      // "boxes-in-a-form" feel.
      final r = zone.rect;
      final notch = 24.0 + (zone.label.hashCode % 20).abs();
      final path = Path()
        ..moveTo(r.left, r.top)
        ..lineTo(r.right - notch, r.top)
        ..lineTo(r.right, r.top + notch)
        ..lineTo(r.right, r.bottom)
        ..lineTo(r.left + notch * 0.6, r.bottom)
        ..lineTo(r.left, r.bottom - notch * 0.6)
        ..close();

      canvas.drawShadow(path, Colors.black, 4, false);
      canvas.drawPath(path, fill);
      canvas.drawPath(path, border);

      final tp = TextPainter(
        text: TextSpan(
          text: zone.label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFE8E8E4),
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: r.width - 20);
      tp.paint(canvas, Offset(r.left + 14, r.top + 12));
    }

    _drawCompass(canvas, Offset(size.width - 70, 70));
  }

  void _drawCompass(Canvas canvas, Offset center) {
    final ring = Paint()
      ..color = NCColors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, 34, ring);
    final needle = Path()
      ..moveTo(center.dx, center.dy - 30)
      ..lineTo(center.dx - 9, center.dy + 6)
      ..lineTo(center.dx + 9, center.dy + 6)
      ..close();
    canvas.drawPath(needle, Paint()..color = NCColors.yellow);
    final tp = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(
            color: NCColors.yellow,
            fontSize: 18,
            fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy + 12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
