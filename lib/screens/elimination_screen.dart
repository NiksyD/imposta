import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';
import '../widgets/player_avatar.dart';

/// Shows who was voted out (without revealing their role).
class EliminationScreen extends StatefulWidget {
  const EliminationScreen({super.key});

  @override
  State<EliminationScreen> createState() => _EliminationScreenState();
}

class _EliminationScreenState extends State<EliminationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _slideUp = Tween<double>(begin: 40.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _cornerSymbol(IconData icon, Alignment alignment) {
    return Positioned(
      left: alignment.x < 0 ? 24 : null,
      right: alignment.x > 0 ? 24 : null,
      top: alignment.y < 0 ? 24 : null,
      bottom: alignment.y > 0 ? 24 : null,
      child: Icon(
        icon,
        size: 16,
        color: AppTheme.accentRed.withValues(alpha: 0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBg,
        body: SafeArea(
          child: Consumer<GameState>(
            builder: (context, game, _) {
              final eliminated = game.lastEliminated!;
              final alivePlayers =
                  game.players.where((p) => p.isAlive).toList();
              final hasWinner = game.winner != null;

              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeIn.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, _slideUp.value),
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceM,
                  ),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      // Physical Voted Out Playing Card
                      Center(
                        child: Container(
                          height: 400,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                            border: Border.all(color: AppTheme.accentRed, width: 3),
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
                                        color: AppTheme.accentRed.withValues(alpha: 0.2),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Corners suit symbols
                              _cornerSymbol(Icons.close_rounded, Alignment.topLeft),
                              _cornerSymbol(Icons.close_rounded, Alignment.topRight),
                              _cornerSymbol(Icons.close_rounded, Alignment.bottomLeft),
                              _cornerSymbol(Icons.close_rounded, Alignment.bottomRight),

                              // Central Content
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'ELIMINATED',
                                      style: const TextStyle(
                                        fontFamily: 'Bungee',
                                        color: AppTheme.accentRed,
                                        fontSize: 22,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spaceM),
                                    PlayerAvatar(
                                      name: eliminated.name,
                                      size: 72,
                                      eliminated: true,
                                    ),
                                    const SizedBox(height: AppTheme.spaceM),
                                    Text(
                                      eliminated.name,
                                      style: const TextStyle(
                                        color: AppTheme.textPrimary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: AppTheme.accentRed,
                                        decorationThickness: 3,
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spaceS),
                                    const Text(
                                      'has been voted out',
                                      style: TextStyle(
                                        color: AppTheme.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: AppTheme.spaceL),
                                    // Votes Count Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF2F4F7),
                                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                        border: Border.all(color: AppTheme.surfaceBorder, width: 2),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'VOTES RECEIVED: ',
                                            style: TextStyle(
                                              color: AppTheme.textSecondary,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          Text(
                                            '${eliminated.votesReceived}',
                                            style: const TextStyle(
                                              color: AppTheme.accentRed,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceL),
                      // Role NOT revealed message
                      if (!hasWinner)
                        const Text(
                          'Their role remains hidden...',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      const SizedBox(height: AppTheme.spaceM),
                      // Remaining players
                      Text(
                        '${alivePlayers.length} players remain',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(flex: 2),
                      // Action button
                      SizedBox(
                        width: double.infinity,
                        child: CapsuleButton(
                          label: hasWinner
                              ? 'SEE RESULTS'
                              : 'NEXT ROUND',
                          icon: hasWinner
                              ? Icons.emoji_events_rounded
                              : Icons.arrow_forward_rounded,
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            game.proceedAfterElimination();
                            if (game.phase == GamePhase.endGame) {
                              Navigator.pushReplacementNamed(
                                context,
                                '/end-game',
                              );
                            } else {
                              Navigator.pushReplacementNamed(
                                context,
                                '/discussion',
                              );
                            }
                          },
                          large: true,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spaceM),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
