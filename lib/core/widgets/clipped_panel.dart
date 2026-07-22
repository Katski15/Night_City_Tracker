import 'package:flutter/material.dart';
import '../../app/nc_theme.dart';

/// The app's signature visual motif: a panel with one corner clipped at
/// 45°, echoing Cyberpunk 2077's own angular HUD panels, plus a colored
/// accent bar down the left edge. Used for item cards and section panels
/// so the whole app reads as one consistent "interface", not stock
/// Material cards.
class ClippedPanel extends StatelessWidget {
  final Widget child;
  final Color accentColor;
  final Color? backgroundColor;
  final double clipSize;
  final EdgeInsetsGeometry padding;

  const ClippedPanel({
    super.key,
    required this.child,
    this.accentColor = NCColors.yellow,
    this.backgroundColor,
    this.clipSize = 18,
    this.padding = const EdgeInsets.fromLTRB(14, 12, 14, 12),
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _CornerClipper(clipSize),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? NCColors.panel,
          border: Border(left: BorderSide(color: accentColor, width: 3)),
        ),
        padding: padding,
        child: child,
      ),
    );
  }
}

class _CornerClipper extends CustomClipper<Path> {
  final double size;
  const _CornerClipper(this.size);

  @override
  Path getClip(Size s) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(s.width - size, 0);
    path.lineTo(s.width, size);
    path.lineTo(s.width, s.height);
    path.lineTo(0, s.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
