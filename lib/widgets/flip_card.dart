import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// A card that flips from front to back with a 3D rotation animation based on parameter.
class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final bool isFlipped;
  final Duration duration;

  const FlipCard({
    super.key,
    required this.front,
    required this.back,
    required this.isFlipped,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  State<FlipCard> createState() => FlipCardState();
}

class FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.addListener(() {
      if (_animation.value >= 0.5 && _showFront) {
        setState(() => _showFront = false);
      } else if (_animation.value < 0.5 && !_showFront) {
        setState(() => _showFront = true);
      }
    });

    if (widget.isFlipped) {
      _showFront = false;
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        final isBackVisible = _animation.value >= 0.5;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle),
          child: isBackVisible
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: widget.back,
                )
              : widget.front,
        );
      },
    );
  }
}

/// The face-down mystery card front (looks like a premium deck of card back).
class CardFront extends StatelessWidget {
   const CardFront({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.surfaceBorder, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner frame border
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  border: Border.all(
                    color: AppTheme.surfaceBorder,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          // Corners suit symbols
          _cornerSymbol(Icons.star_rounded, Alignment.topLeft),
          _cornerSymbol(Icons.star_rounded, Alignment.topRight),
          _cornerSymbol(Icons.star_rounded, Alignment.bottomLeft),
          _cornerSymbol(Icons.star_rounded, Alignment.bottomRight),

          // Center logo / graphic
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.accentBlue,
                      width: 3,
                    ),
                    color: AppTheme.accentBlue.withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.help_center_rounded,
                    size: 40,
                    color: AppTheme.accentBlue,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceM),
                Text(
                  'WHO IS IT?',
                  style: const TextStyle(
                    fontFamily: 'Bungee',
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'HOLD TO REVEAL',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerSymbol(IconData icon, Alignment alignment) {
    return Positioned(
      left: alignment.x < 0 ? 24 : null,
      right: alignment.x > 0 ? 24 : null,
      top: alignment.y < 0 ? 24 : null,
      bottom: alignment.y > 0 ? 24 : null,
      child: Icon(
        icon,
        size: 18,
        color: AppTheme.surfaceBorder,
      ),
    );
  }
}

/// The revealed card back showing role and word (looks like face card).
class CardBack extends StatelessWidget {
  final String role;
  final String? word;
  final String? hintCategory;
  final Color accentColor;

  const CardBack({
    super.key,
    required this.role,
    this.word,
    this.hintCategory,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isImposter = role == 'Imposter';
    final roleIcon = _iconForRole(role);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: accentColor, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner frame border
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // Suit indicators in corners
          _cornerRoleInfo(roleIcon, role[0].toUpperCase(), Alignment.topLeft),
          _cornerRoleInfo(roleIcon, role[0].toUpperCase(), Alignment.topRight),
          _cornerRoleInfo(roleIcon, role[0].toUpperCase(), Alignment.bottomLeft),
          _cornerRoleInfo(roleIcon, role[0].toUpperCase(), Alignment.bottomRight),

          // Main body content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Role Badge & Emblem
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 3),
                    color: accentColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    roleIcon,
                    size: 38,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceM),
                Text(
                  role.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Bungee',
                    color: accentColor,
                    fontSize: 24,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceL),

                // Secret word reveal
                if (isImposter && hintCategory == null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: AppTheme.surfaceBorder, width: 2),
                    ),
                    child: const Text(
                      'YOU ARE THE IMPOSTER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.accentRed,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ] else if (word != null) ...[
                  const Text(
                    'YOUR SECRET WORD',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F4F7),
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      border: Border.all(color: AppTheme.surfaceBorder, width: 2),
                    ),
                    child: Text(
                      word!,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                 ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerRoleInfo(IconData icon, String letter, Alignment alignment) {
    return Positioned(
      left: alignment.x < 0 ? 24 : null,
      right: alignment.x > 0 ? 24 : null,
      top: alignment.y < 0 ? 24 : null,
      bottom: alignment.y > 0 ? 24 : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            letter,
            style: TextStyle(
              color: accentColor,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          Icon(
            icon,
            size: 14,
            color: accentColor,
          ),
        ],
      ),
    );
  }

  IconData _iconForRole(String role) {
    switch (role) {
      case 'Innocent':
        return Icons.shield_outlined;
      case 'Imposter':
        return Icons.visibility_off_outlined;
      default:
        return Icons.person_outline;
    }
  }
}
