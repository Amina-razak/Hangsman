class Score {
  final int id;
  final String scoreDate;
  final int userScore;

  Score({required this.id, required this.scoreDate, required this.userScore});
  Map<String, dynamic> toMap() {
    return {"scoreDate": scoreDate, "userScore": userScore};
  }

  @override
  String toString() {
    return "$userScore,$scoreDate,$id";
  }
}
