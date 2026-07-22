import 'dart:math';
import 'package:flutter/material.dart';
import 'district_layout.dart';

/// Neon outline color per district — a "gang turf map" look inspired
/// generally by that style of tactical city map (glowing zone borders
/// over a dense cityscape), but this is entirely my own color scheme,
/// texture, and shapes — not a reproduction of any game asset, logo,
/// or faction crest.
const Map<String, Color> _districtNeon = {
  'Watson': Color(0xFFFF3B3B),
  'Westbrook': Color(0xFFFF9C3B),
  'City Center': Color(0xFFFCEE0A),
  'Heywood': Color(0xFF3BFF7A),
  'Pacifica': Color(0xFFFF3BE0),
  'Santo Domingo': Color(0xFF3BF0FF),
  'Dogtown': Color(0xFFFF5C3B),
  'Badlands': Color(0xFFFFB23B),
  'Other / Special': Color(0xFFB23BFF),
};

class DistrictMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Dark water backdrop
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF060912));

    _paintCityTexture(canvas, size);
    _paintRoads(canvas, size);

    for (final zone in districtZones) {
      final neon = _districtNeon[zone.label] ?? Colors.white;
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

      // subtle glow
      canvas.drawPath(
        path,
        Paint()
          ..color = neon.withValues(alpha: 0.16)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
      );
      // crisp neon line
      canvas.drawPath(
        path,
        Paint()
          ..color = neon
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );

      _drawLabelPlaque(canvas, zone.label, Offset(r.left + 10, r.top + 8), neon);
    }

    _drawCompass(canvas, Offset(size.width - 70, 70));
  }

  void _paintCityTexture(Canvas canvas, Size size) {
    final rand = Random(7);
    const waterMargin = 50.0;
    const blockW = 16.0, blockH = 12.0;
    for (double y = 10; y < size.height; y += blockH + 3) {
      for (double x = waterMargin; x < size.width; x += blockW + 3) {
        if (rand.nextDouble() < 0.22) continue; // gaps = streets/empty lots
        final jitter = rand.nextDouble();
        final shade = 60 + (jitter * 60).toInt();
        final w = blockW * (0.6 + rand.nextDouble() * 0.4);
        final h = blockH * (0.6 + rand.nextDouble() * 0.4);
        canvas.drawRect(
          Rect.fromLTWH(x, y, w, h),
          Paint()..color = Color.fromARGB(255, shade + 60, shade ~/ 3, shade ~/ 3),
        );
      }
    }
  }

  void _paintRoads(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF3BF0FF).withValues(alpha: 0.22)
      ..strokeWidth = 4;
    const step = 210.0;
    for (double x = 60; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
  }

  void _drawLabelPlaque(Canvas canvas, String label, Offset topLeft, Color neon) {
    final tp = TextPainter(
      text: TextSpan(
        text: label.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFFF2F2F0),
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final plaqueRect = Rect.fromLTWH(
      topLeft.dx, topLeft.dy, tp.width + 20, tp.height + 14,
    );
    canvas.drawRect(plaqueRect, Paint()..color = const Color(0xE60B0E14));
    canvas.drawRect(
      Rect.fromLTWH(plaqueRect.left, plaqueRect.top, plaqueRect.width, 3),
      Paint()..color = neon,
    );
    tp.paint(canvas, Offset(topLeft.dx + 10, topLeft.dy + 8));
  }

  void _drawCompass(Canvas canvas, Offset center) {
    const yellow = Color(0xFFFCEE0A);
    final ring = Paint()
      ..color = yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, 34, ring);
    final needle = Path()
      ..moveTo(center.dx, center.dy - 30)
      ..lineTo(center.dx - 9, center.dy + 6)
      ..lineTo(center.dx + 9, center.dy + 6)
      ..close();
    canvas.drawPath(needle, Paint()..color = yellow);
    final tp = TextPainter(
      text: const TextSpan(
        text: 'N',
        style: TextStyle(color: yellow, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy + 12));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
