import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../theme/app_theme.dart';
import '../widgets/arc_timer.dart';
import '../widgets/capsule_button.dart';
import '../widgets/exit_confirmation.dart';
import '../widgets/frosted_card.dart';
import '../widgets/player_avatar.dart';

/// Discussion phase: timer + active speaker tracker.
class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  Timer? _timer;
  late int _secondsRemaining;
  late int _totalSeconds;
  bool _timerExpired = false;

  @override
  void initState() {
    super.initState();
    final game = context.read<GameState>();
    if (game.useTimer) {
      _totalSeconds = game.discussionSeconds;
      _secondsRemaining = _totalSeconds;
      _startTimer();
    } else {
      _totalSeconds = 0;
      _secondsRemaining = 0;
    }
    // Listen to text changes to update button active state dynamically
    _clueController.addListener(() {
      setState(() {});
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        HapticFeedback.heavyImpact();
        setState(() => _timerExpired = true);
      }
    });
  }

  final TextEditingController _clueController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _clueController.dispose();
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
              final alivePlayers = game.aliveTurnOrder;
              final activeSpeaker = game.currentSpeaker;
              final totalCluesExpected = alivePlayers.length * game.discussionRotations;
              final totalCluesSubmitted = game.playerClues.values
                  .fold<int>(0, (sum, list) => sum + list.length);
              
              // The last action is "Proceed to Vote" only when everyone has input all clues
              final isLastTurn = totalCluesSubmitted >= totalCluesExpected;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceM,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppTheme.spaceM),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRoundBadge('Round ${game.roundNumber}'),
                              const SizedBox(width: AppTheme.spaceS),
                              _buildRoundBadge('Clue ${game.currentRotation}/${game.discussionRotations}'),
                            ],
                          ),
                        ),
                        const SizedBox(width: 48), // Spacer to balance close button size
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    // Timer (only shown if configured)
                    if (game.useTimer) ...[
                      ArcTimer(
                        progress: _secondsRemaining / _totalSeconds,
                        secondsRemaining: _secondsRemaining,
                        size: 110,
                        color: _timerExpired || _secondsRemaining <= 10
                            ? AppTheme.accentRed
                            : AppTheme.accentBlue,
                      ),
                      const SizedBox(height: AppTheme.spaceS),
                    ],
                    // Active Speaker Prominent Card
                    FrostedCard(
                      borderColor: AppTheme.accentBlue,
                      padding: const EdgeInsets.all(AppTheme.spaceM),
                      child: Row(
                        children: [
                          PlayerAvatar(
                            name: activeSpeaker.name,
                            size: 48,
                          ),
                          const SizedBox(width: AppTheme.spaceM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activeSpeaker.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Bungee',
                                    color: AppTheme.accentBlue,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Type clue & pass device',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                     // Clue Input Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isLastTurn ? const Color(0xFFF2F4F7) : Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(color: AppTheme.surfaceBorder, width: 2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _clueController,
                              enabled: !isLastTurn,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) {
                                if (!isLastTurn && _clueController.text.trim().isNotEmpty) {
                                  submitClue(game);
                                }
                              },
                              style: TextStyle(
                                color: isLastTurn ? AppTheme.textSecondary : AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                              decoration: InputDecoration(
                                hintText: isLastTurn ? 'Clue submission finished' : 'Enter your clue...',
                                hintStyle: const TextStyle(color: Color(0xFF8E8E93), fontWeight: FontWeight.w600),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: isLastTurn
                                ? null
                                : () {
                                    if (_clueController.text.trim().isNotEmpty) {
                                      submitClue(game);
                                    }
                                  },
                            icon: Icon(
                              Icons.send_rounded,
                              color: isLastTurn ? const Color(0xFFC7C7CC) : AppTheme.accentBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    // Player Clue History List
                    Expanded(
                      child: ListView.builder(
                        itemCount: alivePlayers.length,
                        itemBuilder: (context, index) {
                          final player = alivePlayers[index];
                          final isSpeaking = index == game.currentSpeakerIndex && !isLastTurn;
                          final clues = game.playerClues[player.name] ?? [];

                          return Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppTheme.spaceS,
                            ),
                            child: FrostedCard(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spaceM,
                                vertical: AppTheme.spaceM,
                              ),
                              borderColor: isSpeaking ? AppTheme.accentBlue : null,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PlayerAvatar(
                                    name: player.name,
                                    size: 40,
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
                                            fontSize: 15,
                                            fontWeight: isSpeaking
                                                ? FontWeight.w900
                                                : FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (clues.isEmpty)
                                          const Text(
                                            'Waiting for clue...',
                                            style: TextStyle(
                                              color: Color(0xFFC7C7CC),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          )
                                        else
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 4,
                                            children: clues.map((clue) {
                                              return Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppTheme.accentBlue.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: AppTheme.accentBlue.withValues(alpha: 0.2),
                                                    width: 1.5,
                                                  ),
                                                ),
                                                child: Text(
                                                  clue,
                                                  style: const TextStyle(
                                                    color: AppTheme.accentBlue,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    _buildActionButton(game, isLastTurn),
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

  void _showVotingConfirmation(GameState game) {
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
            'Ready to Vote?',
            style: const TextStyle(
              fontFamily: 'Bungee',
              color: AppTheme.textPrimary,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'All players have submitted their clues. Are you ready to pass the phone and start voting?',
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
                HapticFeedback.mediumImpact();
                game.beginVoting();
                Navigator.pushReplacementNamed(context, '/voting');
              },
              child: const Text(
                'Start Voting',
                style: TextStyle(
                  color: AppTheme.accentBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton(GameState game, bool isLastTurn) {
    final hasInput = _clueController.text.trim().isNotEmpty;
    
    return SizedBox(
      width: double.infinity,
      child: CapsuleButton(
        label: isLastTurn ? 'PROCEED TO VOTE' : 'SUBMIT CLUE',
        color: isLastTurn ? AppTheme.accentRed : AppTheme.accentBlue,
        icon: isLastTurn ? Icons.how_to_vote_rounded : Icons.check_circle_outline_rounded,
        onPressed: () {
          if (isLastTurn) {
            _showVotingConfirmation(game);
          } else if (hasInput) {
            submitClue(game);
          } else {
            HapticFeedback.vibrate();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter a clue before proceeding!'),
                backgroundColor: AppTheme.accentRed,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        large: true,
      ),
    );
  }

  void submitClue(GameState game) {
    HapticFeedback.lightImpact();
    game.submitClue(_clueController.text);
    _clueController.clear();
    
    // Check if discussion is complete
    final isMore = game.nextSpeaker();
    if (!isMore) {
      // Close the keyboard
      FocusScope.of(context).unfocus();
    }
  }

  Widget _buildRoundBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusCapsule),
        border: Border.all(color: AppTheme.surfaceBorder, width: 2),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
