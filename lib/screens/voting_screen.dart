import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/player.dart';
import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';
import '../widgets/exit_confirmation.dart';
import '../widgets/player_avatar.dart';

/// Sequential voting screen — pass the phone to each voter.
class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  Player? _selectedTarget;
  bool _showingHandoff = true;

  void _onReady() {
    HapticFeedback.lightImpact();
    setState(() => _showingHandoff = false);
  }

  void _selectTarget(Player target) {
    HapticFeedback.selectionClick();
    setState(() => _selectedTarget = target);
  }

  void _confirmVote() {
    if (_selectedTarget == null) return;
    HapticFeedback.mediumImpact();

    final game = context.read<GameState>();
    game.castVote(_selectedTarget!);

    if (game.phase == GamePhase.elimination) {
      Navigator.pushReplacementNamed(context, '/elimination');
    } else {
      // Reset for next voter
      setState(() {
        _selectedTarget = null;
        _showingHandoff = true;
      });
    }
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
              final voter = game.currentVoter;
              final votable = game.votablePlayers;

              if (_showingHandoff) {
                return _buildHandoff(game, voter);
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceM,
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
                          child: Center(
                            child: Text(
                              '${voter.name.toUpperCase()}\'S VOTE',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Bungee',
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance close button size
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentRed.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusCapsule,
                        ),
                        border: Border.all(
                          color: AppTheme.accentRed.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Text(
                        'VOTING ROUND',
                        style: TextStyle(
                          color: AppTheme.accentRed,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    const Text(
                      'Who do you think is the impostor?',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceL),
                    // Votable players grid
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.15,
                          crossAxisSpacing: AppTheme.spaceS,
                          mainAxisSpacing: AppTheme.spaceS,
                        ),
                        itemCount: votable.length,
                        itemBuilder: (context, index) {
                          final target = votable[index];
                          final isSelected =
                              _selectedTarget?.name == target.name;

                          return GestureDetector(
                            onTap: () => _selectTarget(target),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.accentRed.withValues(alpha: 0.1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppTheme.radiusL,
                                ),
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.accentRed
                                      : AppTheme.surfaceBorder,
                                  width: 2.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  PlayerAvatar(
                                    name: target.name,
                                    size: 52,
                                  ),
                                  const SizedBox(height: AppTheme.spaceS),
                                  Text(
                                    target.name,
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 15,
                                      fontWeight: isSelected
                                          ? FontWeight.w900
                                          : FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    // Confirm vote
                    SizedBox(
                      width: double.infinity,
                      child: CapsuleButton(
                        label: _selectedTarget != null
                            ? 'VOTE ${_selectedTarget!.name.toUpperCase()}'
                            : 'SELECT A PLAYER',
                        icon: _selectedTarget != null
                            ? Icons.how_to_vote_rounded
                            : null,
                        onPressed:
                            _selectedTarget != null ? _confirmVote : () {},
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

  Widget _buildHandoff(GameState game, Player voter) {
    return Column(
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
          ],
        ),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXL),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PlayerAvatar(
                    name: voter.name,
                    size: 80,
                  ),
                  const SizedBox(height: AppTheme.spaceL),
                  const Text(
                    'PASS THE PHONE TO',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Text(
                    voter.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXXL),
                  SizedBox(
                    width: double.infinity,
                    child: CapsuleButton(
                      label: 'I\'M READY TO VOTE',
                      icon: Icons.how_to_vote_outlined,
                      onPressed: _onReady,
                      large: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
