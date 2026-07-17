import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Duolingo-style bouncy 3D button with physical depth.
class CapsuleButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool outlined;
  final bool large;
  final bool glowing;

  const CapsuleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.outlined = false,
    this.large = false,
    this.glowing = false,
  });

  @override
  State<CapsuleButton> createState() => _CapsuleButtonState();
}

class _CapsuleButtonState extends State<CapsuleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? AppTheme.accentBlue;
    final txtColor = widget.textColor ?? (widget.outlined ? baseColor : Colors.white);
    
    // Create dark bottom shadow color for Duolingo 3D effect
    final double depth = widget.large ? 4.0 : 3.0;
    final darkShadowColor = HSLColor.fromColor(baseColor)
        .withLightness((HSLColor.fromColor(baseColor).lightness - 0.15).clamp(0.0, 1.0))
        .toColor();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        transform: Matrix4.translationValues(0, _isPressed ? depth : 0, 0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            color: widget.outlined ? Colors.white : baseColor,
            border: Border.all(
              color: widget.outlined ? AppTheme.surfaceBorder : Colors.transparent,
              width: 2,
            ),
            boxShadow: widget.outlined || _isPressed
                ? []
                : [
                    BoxShadow(
                      color: darkShadowColor,
                      offset: Offset(0, depth),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: widget.large ? 32 : 24,
            vertical: widget.large ? 14 : 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: txtColor, size: widget.large ? 22 : 18),
                const SizedBox(width: AppTheme.spaceS),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: txtColor,
                  fontSize: widget.large ? 16 : 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
