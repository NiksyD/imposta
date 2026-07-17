import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';
import '../widgets/frosted_card.dart';
import '../widgets/player_avatar.dart';

/// Shows the randomized turn order with the first speaker spotlighted.
class TurnOrderScreen extends StatefulWidget {
  const TurnOrderScreen({super.key});

  @override
  State<TurnOrderScreen> createState() => _TurnOrderScreenState();
}

class _TurnOrderScreenState extends State<TurnOrderScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              final order = game.turnOrder;
              final firstSpeaker = order.first;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceM,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spaceL),
                    // Header
                    Text(
                      'THE SEQUENCE',
                      style: GoogleFonts.bungee(
                        color: AppTheme.textPrimary,
                        fontSize: 26,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    // First speaker card
                    FrostedCard(
                      borderColor: AppTheme.accentBlue,
                      padding: const EdgeInsets.all(AppTheme.spaceM),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusCapsule,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.record_voice_over_rounded,
                                  color: AppTheme.accentBlue,
                                  size: 14,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'FIRST SPEAKER',
                                  style: TextStyle(
                                    color: AppTheme.accentBlue,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceM),
                          PlayerAvatar(
                            name: firstSpeaker.name,
                            size: 72,
                          ),
                          const SizedBox(height: AppTheme.spaceM),
                          Text(
                            firstSpeaker.name,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: AppTheme.spaceXS),
                          const Text(
                            'starts the conversation',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    // Turn sequence label
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          'DISCUSSION SEQUENCE',
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
                    // Turn list
                    Expanded(
                      child: ListView.builder(
                        itemCount: order.length,
                        itemBuilder: (context, index) {
                          final player = order[index];
                          final isFirst = index == 0;
                          final delay = index * 0.1;

                          return AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              final progress = (_controller.value - delay)
                                  .clamp(0.0, 1.0);
                              return Opacity(
                                opacity: progress,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - progress)),
                                  child: child,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppTheme.spaceS,
                              ),
                              child: FrostedCard(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spaceM,
                                  vertical: AppTheme.spaceM,
                                ),
                                borderColor: isFirst
                                    ? AppTheme.accentBlue
                                    : null,
                                child: Row(
                                  children: [
                                    PlayerAvatar(
                                      name: player.name,
                                      size: 40,
                                    ),
                                    const SizedBox(width: AppTheme.spaceM),
                                    Expanded(
                                      child: Text(
                                        player.name,
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 16,
                                          fontWeight: isFirst
                                              ? FontWeight.w800
                                              : FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${index + 1}'.padLeft(2, '0'),
                                      style: TextStyle(
                                        color: isFirst
                                            ? AppTheme.accentBlue
                                            : AppTheme.textSecondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    // Begin discussion
                    SizedBox(
                      width: double.infinity,
                      child: CapsuleButton(
                        label: 'BEGIN DISCUSSION',
                        icon: Icons.forum_rounded,
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          game.beginDiscussion();
                          Navigator.pushReplacementNamed(
                            context,
                            '/discussion',
                          );
                        },
                        large: true,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
