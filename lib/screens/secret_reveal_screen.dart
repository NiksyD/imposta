import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';
import '../widgets/exit_confirmation.dart';
import '../widgets/flip_card.dart';

/// Pass-and-play secret word reveal screen.
/// Each player sees their role and word privately with interactive card stack throw animations.
class SecretRevealScreen extends StatefulWidget {
  const SecretRevealScreen({super.key});

  @override
  State<SecretRevealScreen> createState() => _SecretRevealScreenState();
}

class _SecretRevealScreenState extends State<SecretRevealScreen>
    with SingleTickerProviderStateMixin {
  bool _isFlipped = false;
  bool _revealedOnce = false;

  // Throw animation controllers
  late AnimationController _throwController;
  late Animation<Offset> _throwOffset;
  late Animation<double> _throwRotation;
  late Animation<double> _throwOpacity;

  @override
  void initState() {
    super.initState();
    _throwController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _throwOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(2.0, -0.5), // Throw to top right
    ).animate(
      CurvedAnimation(parent: _throwController, curve: Curves.easeOutBack),
    );

    _throwRotation = Tween<double>(begin: 0.0, end: 0.8).animate( // Rotate as it flies away
      CurvedAnimation(parent: _throwController, curve: Curves.easeOut),
    );

    _throwOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _throwController, curve: const Interval(0.2, 1.0)),
    );
  }

  @override
  void dispose() {
    _throwController.dispose();
    super.dispose();
  }

  void _handlePressStart() {
    if (_throwController.isAnimating) return;
    HapticFeedback.heavyImpact();
    setState(() {
      _isFlipped = true;
    });
    // Require the user to hold/flip the card for at least 250ms to activate the NEXT button
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted && _isFlipped) {
        setState(() {
          _revealedOnce = true;
        });
      }
    });
  }

  void _handlePressEnd() {
    if (_throwController.isAnimating) return;
    HapticFeedback.lightImpact();
    setState(() {
      _isFlipped = false;
    });
  }

  void _handleConfirm() {
    if (_throwController.isAnimating) return;
    HapticFeedback.lightImpact();
    
    // Trigger throw animation
    _throwController.forward().then((_) {
      final game = context.read<GameState>();
      
      if (game.currentRevealIndex < game.players.length - 1) {
        // Increment index locally within the same route
        game.confirmReveal();
        setState(() {
          _isFlipped = false;
          _revealedOnce = false;
        });
        _throwController.reset();
      } else {
        // Game has finished revealing all roles, proceed to sequence screen
        game.confirmReveal();
        Navigator.pushReplacementNamed(context, '/turn-order');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent accidental back during reveal
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBg,
        body: SafeArea(
          child: Consumer<GameState>(
            builder: (context, game, _) {
              final player = game.currentRevealPlayer;
              final playerIndex = game.currentRevealIndex;
              final totalPlayers = game.players.length;
              final remainingPlayers = totalPlayers - playerIndex;
              final accentColor = AppTheme.colorForRole(player.role);

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceL,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ExitGameConfirmation.show(context, onConfirm: () {
                              game.resetToSetup();
                              Navigator.pushNamedAndRemoveUntil(context, '/setup', (route) => false);
                            });
                          },
                          icon: const Icon(Icons.close_rounded, color: AppTheme.textSecondary),
                        ),
                        Expanded(
                          child: _buildProgress(playerIndex, totalPlayers),
                        ),
                        const SizedBox(width: 48), // Spacer to balance close button size
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    // Player name prompt
                    Text(
                      'PASS THE PHONE TO',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceS),
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceS),
                    Text(
                      _revealedOnce
                          ? 'Press and hold to check again.'
                          : 'Press and hold the card to reveal your word.',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    
                    // Card Stack layout
                    Center(
                      child: SizedBox(
                        height: 440,
                        width: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Render up to 3 stacked background cards
                            for (int i = remainingPlayers - 1; i > 0; i--)
                              if (i < 4) // Only stack up to 3 cards for aesthetics
                                Positioned(
                                  top: i * 8.0,
                                  left: i * 4.0,
                                  child: Transform.rotate(
                                    angle: i * 0.02,
                                    child: Opacity(
                                      opacity: (1.0 - (i * 0.25)).clamp(0.1, 1.0),
                                      child: SizedBox(
                                        height: 420, // Match active card height exactly
                                        width: 280,  // Match active card width exactly
                                        child: const CardFront(),
                                      ),
                                    ),
                                  ),
                                ),

                            // Top Active Card with Throw Animation
                            AnimatedBuilder(
                              animation: _throwController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: _throwOffset.value * 150.0,
                                  child: Transform.rotate(
                                    angle: _throwRotation.value,
                                    child: Opacity(
                                      opacity: _throwOpacity.value,
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: GestureDetector(
                                onTapDown: (_) => _handlePressStart(),
                                onTapUp: (_) => _handlePressEnd(),
                                onTapCancel: () => _handlePressEnd(),
                                child: SizedBox(
                                  height: 420,
                                  width: 280,
                                  child: FlipCard(
                                    key: ValueKey('reveal_card_$playerIndex'), // Key forces widget reset
                                    front: const CardFront(),
                                    back: CardBack(
                                      key: ValueKey('reveal_back_$playerIndex'), // Key forces widget reset
                                      role: player.roleLabel,
                                      word: player.secretWord,
                                      hintCategory: player.hintCategory,
                                      accentColor: accentColor,
                                    ),
                                    isFlipped: _isFlipped,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    
                    // Action button
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _revealedOnce ? 1.0 : 0.4,
                      child: SizedBox(
                        width: double.infinity,
                        child: CapsuleButton(
                          label: playerIndex < totalPlayers - 1
                              ? 'NEXT PLAYER'
                              : 'START GAME',
                          icon: Icons.done_rounded,
                          onPressed: _revealedOnce ? _handleConfirm : () {},
                          large: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceXL),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(int current, int total) {
    return Column(
      children: [
        Text(
          'Player ${current + 1} of $total',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppTheme.spaceS),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            tween: Tween<double>(begin: 0, end: (current + 1) / total),
            builder: (context, value, child) {
              return LinearProgressIndicator(
                value: value,
                backgroundColor: AppTheme.surfaceBorder,
                valueColor: const AlwaysStoppedAnimation(AppTheme.accentBlue),
                minHeight: 3,
              );
            },
          ),
        ),
      ],
    );
  }
}
