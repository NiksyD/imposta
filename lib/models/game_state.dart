import 'dart:math';

import 'package:flutter/foundation.dart';

import 'player.dart';
import 'word_bank.dart';

/// The phases the game moves through.
enum GamePhase {
  setup,
  secretReveal,
  turnOrder,
  discussion,
  voting,
  elimination,
  endGame,
}

/// Who won the game.
enum GameWinner {
  innocents,
  imposter,
}

/// Core game state – a single ChangeNotifier for the entire game.
class GameState extends ChangeNotifier {
  final _random = Random();

  // ── Setup config ────────────────────────────────────────────────
  // ── Setup config ────────────────────────────────────────────────
  List<String> playerNames = ['Player 1', 'Player 2', 'Player 3'];
  List<WordCategory> selectedCategories = [WordCategory.random];
  int imposterCount = 1;
  bool useTimer = false;
  int discussionSeconds = 60;
  bool giveImposterHint = true;
  int discussionRotations = 2; // 1, 2, or 3 rounds of clues per player
  bool oneRoundOnly = false;

  // ── Live game state ─────────────────────────────────────────────
  GamePhase phase = GamePhase.setup;
  List<Player> players = [];
  List<Player> turnOrder = [];
  int currentRevealIndex = 0;
  int currentSpeakerIndex = 0;
  int currentRotation = 1; // current clue rotation loop
  int currentVoterIndex = 0;
  int roundNumber = 1;
  WordPair? currentWordPair;
  Player? lastEliminated;
  GameWinner? winner;

  // Map to store clues: player name -> list of clues entered
  Map<String, List<String>> playerClues = {};

  // Track who the current voter voted for, for the results display.
  Map<String, String> voteLog = {}; // voterName -> votedForName

  // ── Setup helpers ───────────────────────────────────────────────

  /// Update the number of players and auto-generate default names.
  void setPlayerCount(int count) {
    count = count.clamp(3, 12);
    while (playerNames.length < count) {
      playerNames.add('Player ${playerNames.length + 1}');
    }
    while (playerNames.length > count) {
      playerNames.removeLast();
    }
    // Ensure imposter count is valid
    final maxImposter = (count / 2).floor() - 1;
    final upperLimit = maxImposter.clamp(1, 99);
    if (imposterCount > upperLimit) {
      imposterCount = upperLimit;
    }
    notifyListeners();
  }

  void setPlayerName(int index, String name) {
    if (index < playerNames.length) {
      playerNames[index] = name;
      notifyListeners();
    }
  }

  void toggleCategory(WordCategory category) {
    if (category == WordCategory.random) {
      selectedCategories = [WordCategory.random];
    } else {
      selectedCategories.remove(WordCategory.random);
      if (selectedCategories.contains(category)) {
        // Keep at least one category selected
        if (selectedCategories.length > 1) {
          selectedCategories.remove(category);
        }
      } else {
        selectedCategories.add(category);
      }
    }
    notifyListeners();
  }

  void setImposterCount(int count) {
    final maxImposter = (playerNames.length / 2).floor() - 1;
    imposterCount = count.clamp(1, maxImposter.clamp(1, 99));
    notifyListeners();
  }

  void setUseTimer(bool use) {
    useTimer = use;
    notifyListeners();
  }

  void setDiscussionSeconds(int seconds) {
    discussionSeconds = seconds;
    notifyListeners();
  }

  void setDiscussionRotations(int rotations) {
    discussionRotations = rotations.clamp(1, 3);
    notifyListeners();
  }

  void setGiveImposterHint(bool give) {
    giveImposterHint = give;
    notifyListeners();
  }

  void setOneRoundOnly(bool val) {
    oneRoundOnly = val;
    notifyListeners();
  }

  /// Calculated innocent count.
  int get innocentCount =>
      playerNames.length - imposterCount;

  /// The effective number of discussion rotations for the current round.
  /// Round 1 uses the configured discussionRotations; subsequent rounds use 1.
  int get effectiveDiscussionRotations => roundNumber == 1 ? discussionRotations : 1;

  /// Max imposters allowed (innocents must always outnumber others).
  int get maxImposterCount {
    final total = playerNames.length;
    // innocents must be > imposters
    // innocents = total - imposters
    // total - ic > ic  =>  total > 2*ic  =>  ic < total / 2
    return ((total) / 2).floor().clamp(1, total - 2);
  }

  /// Whether the current setup is valid.
  bool get isSetupValid {
    return playerNames.length >= 3 && innocentCount > imposterCount && selectedCategories.isNotEmpty;
  }

  // ── Game start ──────────────────────────────────────────────────

  /// Initialize the game: assign roles, pick words, shuffle order.
  void startGame() {
    // Pick word pair from one of selected categories randomly
    WordCategory categoryToUse;
    if (selectedCategories.contains(WordCategory.random)) {
      final allCategories = WordCategory.values
          .where((c) => c != WordCategory.random)
          .toList();
      categoryToUse = allCategories[_random.nextInt(allCategories.length)];
    } else {
      categoryToUse = selectedCategories[_random.nextInt(selectedCategories.length)];
    }
    currentWordPair = WordBank.getRandomPair(categoryToUse);

    // Create players (assigning 'Player X' fallback if user left a name blank)
    players = List.generate(playerNames.length, (i) {
      final name = playerNames[i].trim();
      return Player(name: name.isEmpty ? 'Player ${i + 1}' : name);
    });

    // Assign roles by shuffling indices
    final indices = List<int>.generate(players.length, (i) => i)
      ..shuffle(_random);

    // First N are imposters
    for (int i = 0; i < imposterCount; i++) {
      players[indices[i]].role = PlayerRole.imposter;
      players[indices[i]].secretWord = currentWordPair!.getRandomImposterHint(_random);
      if (giveImposterHint) {
        players[indices[i]].hintCategory = categoryToUse.label;
      }
    }

    // Rest are innocents
    for (int i = imposterCount; i < players.length; i++) {
      players[indices[i]].role = PlayerRole.innocent;
      players[indices[i]].secretWord = currentWordPair!.civilianWord;
    }

    // Pick a random starting player, then preserve the sequential setup order wrapping around.
    // Example: original [1, 2, 3]. If 2 is selected as start, order is [2, 3, 1].
    final startIndex = _random.nextInt(players.length);
    turnOrder = [];
    for (int i = 0; i < players.length; i++) {
      turnOrder.add(players[(startIndex + i) % players.length]);
    }

    // Reset state
    currentRevealIndex = 0;
    currentSpeakerIndex = 0;
    currentRotation = 1;
    currentVoterIndex = 0;
    roundNumber = 1;
    lastEliminated = null;
    winner = null;
    voteLog.clear();
    playerClues.clear();

    phase = GamePhase.secretReveal;
    notifyListeners();
  }

  // ── Secret reveal ───────────────────────────────────────────────

  /// The player whose secret is currently being revealed.
  Player get currentRevealPlayer {
    if (currentRevealIndex >= players.length) {
      return players.last;
    }
    return players[currentRevealIndex];
  }

  /// Advance to the next player's reveal, or move to turn order.
  void confirmReveal() {
    currentRevealIndex++;
    if (currentRevealIndex >= players.length) {
      phase = GamePhase.turnOrder;
    }
    notifyListeners();
  }

  // ── Turn order / Discussion ─────────────────────────────────────

  /// Move from turn order screen into discussion.
  void beginDiscussion() {
    currentSpeakerIndex = 0;
    currentRotation = 1;
    playerClues.clear();
    phase = GamePhase.discussion;
    notifyListeners();
  }

  /// List of alive players in turn order.
  List<Player> get aliveTurnOrder =>
      turnOrder.where((p) => p.isAlive).toList();

  /// The current speaker.
  Player get currentSpeaker => aliveTurnOrder[currentSpeakerIndex];

  /// Record a clue for the current speaker.
  void submitClue(String clue) {
    if (clue.trim().isEmpty) return;
    final name = currentSpeaker.name;
    playerClues.putIfAbsent(name, () => []);
    playerClues[name]!.add(clue.trim());
    notifyListeners();
  }

  /// Advance to next speaker or rotation. Returns true if there are more speakers/rotations.
  bool nextSpeaker() {
    if (currentSpeakerIndex < aliveTurnOrder.length - 1) {
      currentSpeakerIndex++;
      notifyListeners();
      return true;
    } else if (currentRotation < effectiveDiscussionRotations) {
      currentSpeakerIndex = 0;
      currentRotation++;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Move from discussion to voting.
  void beginVoting() {
    // Reset votes for this round
    for (final p in players) {
      p.resetVotes();
    }
    voteLog.clear();
    currentVoterIndex = 0;
    phase = GamePhase.voting;
    notifyListeners();
  }

  // ── Voting ──────────────────────────────────────────────────────

  /// List of alive players who still need to vote.
  List<Player> get alivePlayersForVoting =>
      turnOrder.where((p) => p.isAlive).toList();

  /// The player who is currently casting a vote.
  Player get currentVoter {
    final list = alivePlayersForVoting;
    if (currentVoterIndex >= list.length) {
      return list.last;
    }
    return list[currentVoterIndex];
  }

  /// Players the current voter can vote for (everyone alive except themselves).
  List<Player> get votablePlayers =>
      alivePlayersForVoting.where((p) => p.name != currentVoter.name).toList();

  /// Cast a vote. Advances to next voter or triggers elimination.
  void castVote(Player target) {
    target.votesReceived++;
    voteLog[currentVoter.name] = target.name;
    currentVoterIndex++;

    if (currentVoterIndex >= alivePlayersForVoting.length) {
      // All votes in — resolve elimination
      _resolveElimination();
    } else {
      notifyListeners();
    }
  }

  void _resolveElimination() {
    // Find the player(s) with the most votes
    final alivePlayers = alivePlayersForVoting;
    int maxVotes = 0;
    for (final p in alivePlayers) {
      if (p.votesReceived > maxVotes) maxVotes = p.votesReceived;
    }

    final topVoted =
        alivePlayers.where((p) => p.votesReceived == maxVotes).toList();

    // Tie-break: random pick from tied players
    final eliminated = topVoted[_random.nextInt(topVoted.length)];
    eliminated.isAlive = false;
    lastEliminated = eliminated;

    // Check win conditions
    _checkWinConditions();

    phase = GamePhase.elimination;
    notifyListeners();
  }

  void _checkWinConditions() {
    final aliveImposters =
        players.where((p) => p.isAlive && p.role == PlayerRole.imposter);
    final aliveInnocents =
        players.where((p) => p.isAlive && p.role == PlayerRole.innocent);

    // Innocents win: all imposters are eliminated
    if (aliveImposters.isEmpty) {
      winner = GameWinner.innocents;
      return;
    }

    // If configured to run for 1 round only, and any imposter survives, they win.
    if (oneRoundOnly) {
      winner = GameWinner.imposter;
      return;
    }

    // Imposter wins: they equal or outnumber innocents
    if (aliveImposters.length >= aliveInnocents.length) {
      winner = GameWinner.imposter;
      return;
    }

    // Game continues
    winner = null;
  }

  // ── Post-elimination ────────────────────────────────────────────

  /// Move to end game or start next round.
  void proceedAfterElimination() {
    if (winner != null) {
      phase = GamePhase.endGame;
    } else {
      // Next round
      roundNumber++;
      currentSpeakerIndex = 0;
      currentRotation = 1;
      playerClues.clear();
      phase = GamePhase.discussion;
    }
    notifyListeners();
  }

  // ── End game / Reset ────────────────────────────────────────────

  /// Reset everything for a brand new game.
  void resetToSetup() {
    phase = GamePhase.setup;
    players.clear();
    turnOrder.clear();
    currentRevealIndex = 0;
    currentSpeakerIndex = 0;
    currentVoterIndex = 0;
    roundNumber = 1;
    currentWordPair = null;
    lastEliminated = null;
    winner = null;
    voteLog.clear();
    notifyListeners();
  }

  /// Play again with the same player names.
  void playAgain() {
    phase = GamePhase.setup;
    players.clear();
    turnOrder.clear();
    currentRevealIndex = 0;
    currentSpeakerIndex = 0;
    currentVoterIndex = 0;
    roundNumber = 1;
    currentWordPair = null;
    lastEliminated = null;
    winner = null;
    voteLog.clear();
    notifyListeners();
    // Keep playerNames and settings — user can press Start right away
  }
}
