import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imposta/models/player.dart';

/// Apple × Duolingo Light theme for Imposta.
class AppTheme {
  AppTheme._();

  // ── Core palette ────────────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFFF2F4F7); // Warm iOS light grey
  static const Color surfaceGlass = Color(0xFFFFFFFF); // Pure white card surfaces
  static const Color surfaceBorder = Color(0xFFE4E7EC); // Soft gray borders
  static const Color surfaceElevated = Color(0xFFF9FAFB);

  // ── Role accent colors ──────────────────────────────────────────
  static const Color accentBlue = Color(0xFF3ECF8E); // Supabase emerald green as primary
  static const Color accentRed = Color(0xFFFF453A); // iOS system red
  static const Color accentGold = Color(0xFFFFD60A); // iOS system yellow

  // ── Text ────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1D2939); // Deep dark gray/black text
  static const Color textSecondary = Color(0xFF667085); // Slate gray
  static const Color textTertiary = Color(0xFF98A2B3); // Light gray

  // ── Functional ──────────────────────────────────────────────────
  static const Color success = Color(0xFF30D158); // iOS green
  static const Color warning = Color(0xFFFF9F0A); // iOS orange

  // ── Radius ──────────────────────────────────────────────────────
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXL = 24;
  static const double radiusCapsule = 100;

  // ── Spacing ─────────────────────────────────────────────────────
  static const double spaceXS = 4;
  static const double spaceS = 8;
  static const double spaceM = 16;
  static const double spaceL = 24;
  static const double spaceXL = 32;
  static const double spaceXXL = 48;

  /// Returns the accent color for a given player role.
  static Color colorForRole(PlayerRole role) {
    switch (role) {
      case PlayerRole.innocent:
        return accentBlue;
      case PlayerRole.imposter:
        return accentRed;
    }
  }

  /// No-op clean shadow style for Apple minimal design (no neon glow).
  static List<BoxShadow> glowShadow(Color color, {double blur = 12}) {
    return [];
  }

  /// Frosted glass decoration for cards and panels.
  static BoxDecoration get frostedDecoration => BoxDecoration(
        color: surfaceGlass,
        borderRadius: BorderRadius.circular(radiusL),
        border: Border.all(color: surfaceBorder),
      );

  /// Frosted glass decoration with an accent glow border.
  static BoxDecoration frostedGlowDecoration(Color accentColor) =>
      BoxDecoration(
        color: surfaceGlass,
        borderRadius: BorderRadius.circular(radiusL),
        border: Border.all(color: accentColor.withValues(alpha: 0.5)),
      );

  /// Build the full MaterialApp [ThemeData].
  static ThemeData get lightTheme {
    final baseText = GoogleFonts.outfitTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: scaffoldBg,
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        secondary: accentRed,
        tertiary: accentGold,
        surface: surfaceGlass,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
        outline: surfaceBorder,
      ),
      textTheme: baseText.copyWith(
        displayLarge: baseText.displayLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -1.0,
          color: textPrimary,
        ),
        headlineLarge: baseText.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: textPrimary,
        ),
        headlineMedium: baseText.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: baseText.bodyMedium?.copyWith(color: textSecondary),
        labelLarge: baseText.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: textSecondary,
        ),
        labelSmall: baseText.labelSmall?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.0,
          color: textTertiary,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      splashFactory: InkSparkle.splashFactory,
      useMaterial3: true,
    );
  }
}
