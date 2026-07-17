import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

/// Common modal pop confirmation to go back to Setup / Home
class ExitGameConfirmation {
  static void show(BuildContext context, {required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            side: const BorderSide(color: AppTheme.surfaceBorder, width: 2),
          ),
          title: Text(
            'Exit Game?',
            style: GoogleFonts.bungee(
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Are you sure you want to end the current game session and return to the setup screen? Your current game progress will be lost.',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                onConfirm();
              },
              child: const Text(
                'Exit',
                style: TextStyle(
                  color: AppTheme.accentRed,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
