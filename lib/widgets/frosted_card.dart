import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A reusable frosted glass card with backdrop blur.
class FrostedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final double borderRadius;
  final List<BoxShadow>? boxShadow;

  const FrostedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppTheme.spaceL),
    this.borderColor,
    this.borderRadius = AppTheme.radiusL,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppTheme.surfaceGlass,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppTheme.surfaceBorder,
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
