class QuizResult {
  String playerName;
  int score;

  QuizResult({required this.playerName, required this.score});

  Map<String, dynamic> toMap() {
    return {
      'playerName': playerName,
      'score': score,
    };
  }

  factory QuizResult.fromMap(Map<String, dynamic> map) {
    return QuizResult(
      playerName: map['playerName'] ?? '',
      score: map['score'] ?? 0,
    );
  }
}
