import 'package:flutter/material.dart';
import '../../app/nc_theme.dart';

/// Assigns a consistent accent color per category so the list reads
/// at a glance (weapons vs vehicles vs secrets) without needing icons
/// for every single category string the user adds.
Color categoryColor(String category) {
  final key = category.toLowerCase();
  if (key.contains('weapon')) return NCColors.magenta;
  if (key.contains('vehicle')) return NCColors.cyan;
  if (key.contains('secret') || key.contains('easter')) return NCColors.yellow;
  if (key.contains('companion') || key.contains('npc')) return const Color(0xFF7CFF6B);
  if (key.contains('cyberware')) return const Color(0xFFB98CFF);
  if (key.contains('tarot') || key.contains('collectible')) return const Color(0xFFFF8A3D);
  return NCColors.yellow;
}
