import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Night City Tracker's visual identity.
///
/// Palette pulled from Cyberpunk 2077's own HUD language rather than
/// generic Material defaults: near-black panels, signature yellow for
/// primary actions/selection, cyan reserved for "found/complete" states.
class NCColors {
  static const bg = Color(0xFF0D0D0F);
  static const panel = Color(0xFF17171B);
  static const panelAlt = Color(0xFF1F1F24);
  static const yellow = Color(0xFFFCEE0A);
  static const cyan = Color(0xFF00F0FF);
  static const magenta = Color(0xFFFF003C);
  static const textPrimary = Color(0xFFF2F2F0);
  static const textSecondary = Color(0xFF9A9A9E);
  static const divider = Color(0xFF2A2A2F);
}

class NCTheme {
  static ThemeData get dark {
    final base = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NCColors.bg,
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        surface: NCColors.panel,
        primary: NCColors.yellow,
        secondary: NCColors.cyan,
        error: NCColors.magenta,
        onPrimary: Colors.black,
        onSurface: NCColors.textPrimary,
      ),
      dividerColor: NCColors.divider,
    );

    final display = GoogleFonts.rajdhaniTextTheme(base.textTheme);
    final body = GoogleFonts.chakraPetchTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: body.copyWith(
        headlineSmall: display.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: NCColors.textPrimary,
        ),
        titleLarge: display.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: NCColors.textPrimary,
        ),
        titleMedium: display.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: NCColors.textPrimary,
        ),
        labelLarge: display.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: NCColors.textPrimary,
        ),
        bodyMedium: body.bodyMedium?.copyWith(color: NCColors.textPrimary),
        bodySmall: body.bodySmall?.copyWith(color: NCColors.textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: NCColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: display.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: NCColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: NCColors.yellow),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: NCColors.panel,
        indicatorColor: NCColors.yellow.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.rajdhani(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            color: selected ? NCColors.yellow : NCColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? NCColors.yellow : NCColors.textSecondary,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NCColors.panel,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: NCColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: NCColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: const BorderSide(color: NCColors.yellow, width: 1.5),
        ),
        hintStyle: body.bodyMedium?.copyWith(color: NCColors.textSecondary),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: NCColors.yellow,
        linearTrackColor: NCColors.panelAlt,
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: NCColors.panel,
        selectedColor: NCColors.yellow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: NCColors.divider),
        ),
        labelStyle: GoogleFonts.rajdhani(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: NCColors.textPrimary,
        ),
        secondaryLabelStyle: GoogleFonts.rajdhani(
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Colors.black,
        ),
      ),
      cardTheme: const CardThemeData(
        color: NCColors.panel,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: NCColors.yellow,
          foregroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.rajdhani(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NCColors.textPrimary,
          side: const BorderSide(color: NCColors.divider),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero),
          textStyle: GoogleFonts.rajdhani(
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
