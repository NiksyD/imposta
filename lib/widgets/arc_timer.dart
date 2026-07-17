import 'dart:math';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// A circular countdown timer drawn with CustomPainter.
class ArcTimer extends StatelessWidget {
  /// Value from 0.0 (empty) to 1.0 (full).
  final double progress;
  final int secondsRemaining;
  final double size;
  final Color? color;

  const ArcTimer({
    super.key,
    required this.progress,
    required this.secondsRemaining,
    this.size = 120,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final timerColor = color ?? AppTheme.accentBlue;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arc painter
          CustomPaint(
            size: Size(size, size),
            painter: _ArcPainter(
              progress: progress,
              color: timerColor,
              trackColor: AppTheme.surfaceBorder,
            ),
          ),
          // Time text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$secondsRemaining',
                style: TextStyle(
                  color: timerColor,
                  fontSize: size * 0.3,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1,
                ),
              ),
              Text(
                'SEC',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: size * 0.09,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _ArcPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8) / 2;
    const strokeWidth = 5.0;
    const startAngle = -pi / 2; // 12 o'clock

    // Track (background ring)
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc
    final sweepAngle = 2 * pi * progress;
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth + 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Glow layer
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..strokeWidth = strokeWidth + 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, glowPaint);
    canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
