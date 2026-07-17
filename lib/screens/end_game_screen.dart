import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';
import '../widgets/frosted_card.dart';
import '../widgets/player_avatar.dart';
import '../widgets/role_badge.dart';

/// End game screen: full role reveal + winner announcement.
class EndGameScreen extends StatefulWidget {
  const EndGameScreen({super.key});

  @override
  State<EndGameScreen> createState() => _EndGameScreenState();
}

class _EndGameScreenState extends State<EndGameScreen>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 4),
    );
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    // Fire confetti after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _confettiController.play();
      HapticFeedback.heavyImpact();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBg,
        body: Stack(
          children: [
            SafeArea(
              child: Consumer<GameState>(
                builder: (context, game, _) {
                  final winnerColor = _colorForWinner(game.winner!);

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spaceM,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppTheme.spaceXL),
                          // Winner announcement
                          AnimatedBuilder(
                            animation: _animController,
                            builder: (context, child) {
                              final t = CurvedAnimation(
                                parent: _animController,
                                curve: const Interval(
                                  0.0,
                                  0.5,
                                  curve: Curves.easeOutBack,
                                ),
                              ).value.clamp(0.0, 1.0);
                              return Opacity(
                                opacity: t,
                                child: Transform.scale(
                                  scale: 0.5 + 0.5 * t,
                                  child: child,
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.emoji_events_rounded,
                                  color: winnerColor,
                                  size: 64,
                                ),
                                const SizedBox(height: AppTheme.spaceM),
                                Text(
                                  _winnerTitle(game.winner!).toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.bungee(
                                    color: winnerColor,
                                    fontSize: 30,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spaceS),
                                Text(
                                  _winnerSubtitle(game.winner!),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceL),
                          // The words
                          if (game.currentWordPair != null)
                            FrostedCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spaceM,
                                vertical: AppTheme.spaceM,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          'INNOCENT WORD',
                                          style: TextStyle(
                                            color: AppTheme.accentBlue,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          game.currentWordPair!.civilianWord,
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 40,
                                    color: AppTheme.surfaceBorder,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          'IMPOSTER HINTS',
                                          style: TextStyle(
                                            color: AppTheme.accentRed,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          game.currentWordPair!.imposterHints.join(', '),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: AppTheme.textPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: AppTheme.spaceL),
                          
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'PLAYER SUMMARY',
                                style: TextStyle(
                                  color: Color(0xFF8E8E93),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceS),
                          // Player reveal list
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: game.players.length,
                            itemBuilder: (context, index) {
                              final player = game.players[index];
                              final delay = 0.3 + index * 0.08;

                              return AnimatedBuilder(
                                animation: _animController,
                                builder: (context, child) {
                                  final t = ((_animController.value - delay) /
                                          0.15)
                                      .clamp(0.0, 1.0);
                                  return Opacity(
                                    opacity: t,
                                    child: Transform.translate(
                                      offset: Offset(0, 20 * (1 - t)),
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildPlayerRevealCard(player),
                              );
                            },
                          ),
                          const SizedBox(height: AppTheme.spaceL),
                          // Action buttons
                          SizedBox(
                            width: double.infinity,
                            child: CapsuleButton(
                              label: 'PLAY AGAIN',
                              icon: Icons.replay_rounded,
                              onPressed: () {
                                game.playAgain();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/setup',
                                  (route) => false,
                                );
                              },
                              large: true,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceS),
                          SizedBox(
                            width: double.infinity,
                            child: CapsuleButton(
                              label: 'NEW GAME',
                              icon: Icons.home_rounded,
                              onPressed: () {
                                game.resetToSetup();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/',
                                  (route) => false,
                                );
                              },
                              outlined: true,
                              large: true,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceXL),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Confetti overlay
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 30,
                maxBlastForce: 20,
                minBlastForce: 8,
                gravity: 0.2,
                colors: const [
                  AppTheme.accentBlue,
                  AppTheme.accentRed,
                  AppTheme.accentGold,
                  Colors.white,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRevealCard(Player player) {
    final roleColor = AppTheme.colorForRole(player.role);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceS),
      child: FrostedCard(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceM,
          vertical: AppTheme.spaceM,
        ),
        borderColor: player.isAlive ? roleColor : null,
        child: Row(
          children: [
            PlayerAvatar(
              name: player.name,
              size: 44,
              eliminated: !player.isAlive,
            ),
            const SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      decoration: player.isAlive
                          ? null
                          : TextDecoration.lineThrough,
                    ),
                  ),
                  Text(
                    player.secretWord ?? '',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            RoleBadge(role: player.role),
          ],
        ),
      ),
    );
  }

  String _winnerTitle(GameWinner winner) {
    switch (winner) {
      case GameWinner.innocents:
        return 'Innocents Win!';
      case GameWinner.imposter:
        return 'Imposter Wins!';
    }
  }

  String _winnerSubtitle(GameWinner winner) {
    switch (winner) {
      case GameWinner.innocents:
        return 'All imposters have been found.';
      case GameWinner.imposter:
        return 'The imposter survived long enough.';
    }
  }

  Color _colorForWinner(GameWinner winner) {
    switch (winner) {
      case GameWinner.innocents:
        return AppTheme.accentBlue;
      case GameWinner.imposter:
        return AppTheme.accentRed;
    }
  }
}
