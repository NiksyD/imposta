import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';

/// Landing and Splash screen with a premium abstract architectural design.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  // Abstract architectural geometric animations
  late Animation<double> _circleScale;
  late Animation<double> _barHeight;
  late Animation<double> _angleRotation;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _circleScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutBack),
      ),
    );

    _barHeight = Tween<double>(begin: 0.0, end: 120.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.6, curve: Curves.easeInOutQuart),
      ),
    );

    _angleRotation = Tween<double>(begin: 0.0, end: 0.785).animate( // 45 degrees
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.8, curve: Curves.elasticOut),
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
            child: Column(
              children: [
                const SizedBox(height: 60),
                
                // Premium detective mystery badge logo
                Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SizedBox(
                        width: 200,
                        height: 200,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // 1. Solid flat off-white background circle
                            Transform.scale(
                              scale: _circleScale.value,
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: AppTheme.surfaceBorder,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                            
                            // 2. Detective Hat Brim & Crown (Stylized Vector)
                            Positioned(
                              top: 50 + (10 * (1.0 - _circleScale.value)),
                              child: Opacity(
                                opacity: _circleScale.value.clamp(0.0, 1.0),
                                child: Column(
                                  children: [
                                    // Crown of the hat
                                    Container(
                                      width: 60,
                                      height: 38,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.textPrimary,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                        ),
                                      ),
                                    ),
                                    // Hat ribbon band
                                    Container(
                                      width: 60,
                                      height: 8,
                                      color: AppTheme.accentBlue,
                                    ),
                                    // Hat brim curve
                                    Container(
                                      width: 96,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: AppTheme.textPrimary,
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // 3. Glowing Spy Glasses / Mask Eyes (Floating below hat)
                            Positioned(
                              top: 104,
                              child: Transform.rotate(
                                angle: _angleRotation.value * 0.1, // subtle tilt
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Left eye
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 28,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(14),
                                          bottomRight: Radius.circular(14),
                                        ),
                                        border: Border.all(
                                          color: AppTheme.accentBlue,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Right eye
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      width: 28,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(14),
                                          bottomRight: Radius.circular(14),
                                        ),
                                        border: Border.all(
                                          color: AppTheme.accentBlue,
                                          width: 3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // Fade-in landing elements
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentFade.value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "WHO'S THE",
                        style: const TextStyle(
                          fontFamily: 'Bungee',
                          color: AppTheme.textSecondary,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'IMPOSTA?',
                        style: const TextStyle(
                          fontFamily: 'Bungee',
                          color: AppTheme.accentBlue,
                          fontSize: 40,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceM),
                      Text(
                        'A Minimal Social Deduction Game',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceXXL),
                      
                      // Start Button
                      SizedBox(
                        width: double.infinity,
                        child: CapsuleButton(
                          label: 'START GAME',
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {
                            Navigator.pushNamed(context, '/setup');
                          },
                          large: true,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceM),
                      
                      // How to Play
                      TextButton(
                        onPressed: () => _showHowToPlay(context),
                        child: const Text(
                          'How to Play',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXL)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceL),
                const Text(
                  'How to Play',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppTheme.spaceM),
                _ruleItem('1', 'Players secretly reveal their word. Most get the same word — but the Imposter gets a similar, different one.'),
                _ruleItem('2', 'Players take turns writing a one-word clue describing their secret word.'),
                _ruleItem('3', 'Discuss, deliberate, and vote to eliminate who you believe is the Imposter.'),
                _ruleItem('4', 'Innocents win by voting out the Imposter. Imposters win by staying alive.'),
                const SizedBox(height: AppTheme.spaceL),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ruleItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accentBlue.withValues(alpha: 0.15),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: AppTheme.accentBlue,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
