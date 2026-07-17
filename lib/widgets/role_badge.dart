import 'package:flutter/material.dart';

import '../models/player.dart';
import '../theme/app_theme.dart';

/// A small pill badge displaying a player's role with color coding.
class RoleBadge extends StatelessWidget {
  final PlayerRole role;
  final bool large;

  const RoleBadge({
    super.key,
    required this.role,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.colorForRole(role);
    final label = _labelForRole(role);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 10,
        vertical: large ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppTheme.radiusCapsule),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: large ? 14 : 11,
          fontWeight: FontWeight.w700,
          letterSpacing: large ? 1.2 : 0.8,
        ),
      ),
    );
  }

  String _labelForRole(PlayerRole role) {
    switch (role) {
      case PlayerRole.innocent:
        return 'INNOCENT';
      case PlayerRole.imposter:
        return 'IMPOSTER';
    }
  }
}
