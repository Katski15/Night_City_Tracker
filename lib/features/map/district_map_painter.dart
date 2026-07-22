import 'package:flutter/material.dart';
import '../../app/nc_theme.dart';
import 'district_layout.dart';

class DistrictMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = NCColors.panel;
    final border = Paint()
      ..color = NCColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final zone in districtZones) {
      final rrect = RRect.fromRectAndCorners(
        zone.rect,
        topRight: const Radius.circular(28),
      );
      canvas.drawRRect(rrect, fill);
      canvas.drawRRect(rrect, border);

      final tp = TextPainter(
        text: TextSpan(
          text: zone.label.toUpperCase(),
          style: const TextStyle(
            color: NCColors.textSecondary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: zone.rect.width - 16);
      tp.paint(canvas, Offset(zone.rect.left + 12, zone.rect.top + 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
