import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Circular avatar showing player initials with an optional animated glow ring.
class PlayerAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color? glowColor;
  final bool showGlow;
  final bool eliminated;

  const PlayerAvatar({
    super.key,
    required this.name,
    this.size = 56,
    this.glowColor,
    this.showGlow = false,
    this.eliminated = false,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.trim().substring(0, name.trim().length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final glow = glowColor ?? AppTheme.accentBlue;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: eliminated ? 0.3 : 1.0,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.surfaceElevated,
          border: Border.all(
            color: showGlow
                ? glow
                : (eliminated
                    ? AppTheme.accentRed.withValues(alpha: 0.3)
                    : AppTheme.surfaceBorder),
            width: showGlow ? 2.5 : 1.5,
          ),
          boxShadow: showGlow
              ? [
                  BoxShadow(
                    color: glow.withValues(alpha: 0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              color: eliminated ? AppTheme.textTertiary : AppTheme.textPrimary,
              fontSize: size * 0.35,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
