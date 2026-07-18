import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/game_state.dart';
import '../models/word_bank.dart';
import '../theme/app_theme.dart';
import '../widgets/capsule_button.dart';
import '../widgets/frosted_card.dart';

/// Game setup screen: player names, category, roles, options.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final List<TextEditingController> _nameControllers = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final game = context.read<GameState>();
    _syncControllers(game.playerNames.length);
    for (int i = 0; i < game.playerNames.length; i++) {
      _nameControllers[i].text = game.playerNames[i];
    }
  }

  void _syncControllers(int count) {
    while (_nameControllers.length < count) {
      final controller = TextEditingController();
      _nameControllers.add(controller);
    }
    while (_nameControllers.length > count) {
      _nameControllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers) {
      c.dispose();
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      body: SafeArea(
        child: Consumer<GameState>(
          builder: (context, game, _) {
            _syncControllers(game.playerNames.length);
            for (int i = 0; i < game.playerNames.length; i++) {
              if (_nameControllers[i].text != game.playerNames[i]) {
                _nameControllers[i].text = game.playerNames[i];
              }
            }

            return Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spaceM,
                    ),
                    children: [
                      const SizedBox(height: AppTheme.spaceS),
                      _buildHeaderBlock(),
                      const SizedBox(height: AppTheme.spaceM),
                      _buildPlayerCount(game),
                      const SizedBox(height: AppTheme.spaceM),
                      _buildPlayerNames(game),
                      const SizedBox(height: AppTheme.spaceM),
                      _buildCategoryPicker(game),
                      const SizedBox(height: AppTheme.spaceM),
                      _buildRoleDistribution(game),
                      const SizedBox(height: AppTheme.spaceM),
                      _buildOptions(game),
                      const SizedBox(height: AppTheme.spaceXL),
                      _buildStartButton(game),
                      const SizedBox(height: AppTheme.spaceXXL),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceM,
        vertical: AppTheme.spaceS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: AppTheme.textPrimary,
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 24),
            color: AppTheme.textPrimary,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBlock() {
    return Column(
      children: [
        Text(
          'WHO\'S THE',
          style: const TextStyle(
            fontFamily: 'Bungee',
            color: Color(0xFF4B4B4B),
            fontSize: 20,
            letterSpacing: 1.5,
            height: 1.0,
          ),
        ),
        Text(
          'IMPOSTA?',
          style: const TextStyle(
            fontFamily: 'Bungee',
            color: AppTheme.accentBlue,
            fontSize: 38,
            letterSpacing: 0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppTheme.spaceS),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFFFD60A).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👑 ', style: TextStyle(fontSize: 12)),
              Text(
                'PARTY GAME',
                style: TextStyle(
                  color: Color(0xFFB89600),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Player Count ────────────────────────────────────────────────

  Widget _buildPlayerCount(GameState game) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.surfaceBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('👥 ', style: TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              const Text(
                'PLAYERS',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${game.playerNames.length}',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceS),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppTheme.accentBlue,
              inactiveTrackColor: AppTheme.scaffoldBg,
              thumbColor: Colors.white,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
              trackHeight: 12,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12,
                pressedElevation: 4,
              ),
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Slider(
                value: game.playerNames.length.toDouble(),
                min: 3,
                max: 12,
                onChanged: (v) => game.setPlayerCount(v.round()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Player Names ────────────────────────────────────────────────

  Widget _buildPlayerNames(GameState game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: AppTheme.spaceS),
          child: Row(
            children: [
              Text('✍️ ', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text(
                'PLAYER NAMES',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(game.playerNames.length, (i) {
            final controller = _nameControllers[i];
            final nameText = game.playerNames[i];
            final isFilled = nameText.trim().isNotEmpty;

            return IntrinsicWidth(
              child: Container(
                constraints: const BoxConstraints(minWidth: 100),
                decoration: BoxDecoration(
                  color: isFilled ? const Color(0xFFE3F2FD) : Colors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  border: Border.all(
                    color: isFilled ? const Color(0xFF90CAF9) : AppTheme.surfaceBorder,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${i + 1}. ',
                      style: TextStyle(
                        color: isFilled ? const Color(0xFF1E88E5) : AppTheme.textTertiary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: (val) => game.setPlayerName(i, val),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Player ${i + 1}',
                          hintStyle: const TextStyle(
                            color: AppTheme.textTertiary,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── Category Picker ─────────────────────────────────────────────

  Widget _buildCategoryPicker(GameState game) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: AppTheme.spaceS),
          child: Row(
            children: [
              Text('🍕 ', style: TextStyle(fontSize: 16)),
              SizedBox(width: 6),
              Text(
                'WORD CATEGORY',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _showCategoryBottomSheet(context, game),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(color: AppTheme.surfaceBorder, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: game.selectedCategories.map((cat) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                          border: Border.all(color: AppTheme.accentBlue.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cat.icon, style: const TextStyle(fontSize: 13)),
                            const SizedBox(width: 4),
                            Text(
                              cat.label,
                              style: const TextStyle(
                                color: AppTheme.accentBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.textSecondary, size: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCategoryBottomSheet(BuildContext context, GameState game) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXL)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceM),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Word Categories',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Imposters and Innocents words will be chosen from these categories.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: WordCategory.values.map((cat) {
                          final isSelected = game.selectedCategories.contains(cat);
                          return ListTile(
                            leading: Text(cat.icon, style: const TextStyle(fontSize: 22)),
                            title: Text(
                              cat.label,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(Icons.check_circle_rounded, color: AppTheme.accentBlue)
                                : const Icon(Icons.circle_outlined, color: AppTheme.surfaceBorder),
                            onTap: () {
                              setModalState(() {
                                game.toggleCategory(cat);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceM),
                    SizedBox(
                      width: double.infinity,
                      child: CapsuleButton(
                        label: 'DONE',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Role Distribution ───────────────────────────────────────────

  Widget _buildRoleDistribution(GameState game) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.surfaceBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🥷 ', style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                'ROLE DISTRIBUTION',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          // Innocents (auto-calculated)
          _roleRow(
            icon: '🛡️',
            color: AppTheme.accentBlue,
            label: 'Innocents',
            value: '${game.innocentCount}',
          ),
          const SizedBox(height: AppTheme.spaceM),
          // Imposters (stepper)
          _roleRowStepper(
            icon: '🔎',
            color: AppTheme.accentRed,
            label: 'Imposters',
            value: game.imposterCount,
            onDecrement: game.imposterCount > 1
                ? () => game.setImposterCount(game.imposterCount - 1)
                : null,
            onIncrement: game.imposterCount < game.maxImposterCount
                ? () => game.setImposterCount(game.imposterCount + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _roleRow({
    required String icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AppTheme.spaceS),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _roleRowStepper({
    required String icon,
    required Color color,
    required String label,
    required int value,
    VoidCallback? onDecrement,
    VoidCallback? onIncrement,
  }) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AppTheme.spaceS),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        // Stepper
        Row(
          children: [
            _stepperButton(Icons.remove, onDecrement),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '$value',
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            _stepperButton(Icons.add, onIncrement),
          ],
        ),
      ],
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback? onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onPressed != null ? const Color(0xFFF2F4F7) : Colors.transparent,
          border: Border.all(
            color: onPressed != null ? AppTheme.surfaceBorder : AppTheme.surfaceBorder.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onPressed != null ? AppTheme.textPrimary : AppTheme.textTertiary,
        ),
      ),
    );
  }

  // ── Options ─────────────────────────────────────────────────────

  Widget _buildOptions(GameState game) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: AppTheme.surfaceBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('⚙️ ', style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                'GAME CONFIG',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          // Imposter hint toggle
          Row(
            children: [
              const Text('💡 ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: AppTheme.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Imposter Secret Word',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Show related secret word to imposter',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: game.giveImposterHint,
                activeColor: AppTheme.accentBlue,
                onChanged: (v) => game.setGiveImposterHint(v),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          // 1 Round Only toggle
          Row(
            children: [
              const Text('🏁 ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: AppTheme.spaceS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '1 Round Only',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'Game ends after one voting round',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: game.oneRoundOnly,
                activeColor: AppTheme.accentBlue,
                onChanged: (v) => game.setOneRoundOnly(v),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spaceM),
          // Discussion rotations configuration picker
          const Text(
            '🔄 CLUE ROTATIONS',
            style: TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [1, 2, 3].map((rotations) {
              final isSelected = game.discussionRotations == rotations;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => game.setDiscussionRotations(rotations),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accentBlue.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accentBlue
                              : AppTheme.surfaceBorder,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$rotations ${rotations == 1 ? 'Clue' : 'Clues'}',
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.accentBlue
                                : AppTheme.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppTheme.spaceM),
          // Discussion timer toggle
          Row(
            children: [
              const Text('⏱️ ', style: TextStyle(fontSize: 16)),
              const SizedBox(width: AppTheme.spaceS),
              const Expanded(
                child: Text(
                  'Discussion Timer',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Switch.adaptive(
                value: game.useTimer,
                activeColor: AppTheme.accentBlue,
                onChanged: (v) => game.setUseTimer(v),
              ),
            ],
          ),
          // Timer duration picker (only if timer enabled)
          if (game.useTimer) ...[
            const SizedBox(height: AppTheme.spaceM),
            Row(
              children: [30, 60, 90].map((seconds) {
                final isSelected = game.discussionSeconds == seconds;
                return Expanded(
                  child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 4),
                     child: GestureDetector(
                       onTap: () => game.setDiscussionSeconds(seconds),
                       child: AnimatedContainer(
                         duration: const Duration(milliseconds: 200),
                         padding: const EdgeInsets.symmetric(vertical: 10),
                         decoration: BoxDecoration(
                           color: isSelected
                               ? AppTheme.accentBlue.withValues(alpha: 0.15)
                               : Colors.white,
                           borderRadius: BorderRadius.circular(AppTheme.radiusM),
                           border: Border.all(
                             color: isSelected
                                 ? AppTheme.accentBlue
                                 : AppTheme.surfaceBorder,
                             width: 2,
                           ),
                         ),
                         child: Column(
                           children: [
                             Text(
                               '$seconds',
                               style: TextStyle(
                                 color: isSelected
                                     ? AppTheme.accentBlue
                                     : AppTheme.textPrimary,
                                 fontSize: 16,
                                 fontWeight: FontWeight.w900,
                               ),
                             ),
                             Text(
                               'sec',
                               style: TextStyle(
                                 color: isSelected ? AppTheme.accentBlue : AppTheme.textSecondary,
                                 fontSize: 11,
                                 fontWeight: FontWeight.w700,
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 );
               }).toList(),
             ),
           ],
         ],
       ),
     );
   }

  // ── Start Button ────────────────────────────────────────────────

  Widget _buildStartButton(GameState game) {
    return SizedBox(
      width: double.infinity,
      child: CapsuleButton(
        label: 'START GAME',
        icon: Icons.play_arrow_rounded,
        onPressed: game.isSetupValid
            ? () {
                game.startGame();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/secret-reveal',
                  (route) => false,
                );
              }
            : () {},
        large: true,
        glowing: game.isSetupValid,
        color: game.isSetupValid
            ? AppTheme.accentBlue
            : AppTheme.textTertiary,
      ),
    );
  }
}
