/// Roles a player can be assigned in the game.
enum PlayerRole {
  innocent,
  imposter,
}

/// A single player in the game.
class Player {
  final String name;
  PlayerRole role;
  String? secretWord;
  String? hintCategory; // optional hint for imposter
  bool isAlive;
  int votesReceived;

  Player({
    required this.name,
    this.role = PlayerRole.innocent,
    this.secretWord,
    this.isAlive = true,
    this.votesReceived = 0,
  });

  /// Reset vote tally between rounds.
  void resetVotes() {
    votesReceived = 0;
  }

  /// Human-readable role label (hides identity during gameplay).
  String get roleLabel {
    switch (role) {
      case PlayerRole.innocent:
        return 'Innocent';
      case PlayerRole.imposter:
        return 'Imposter';
    }
  }
}
