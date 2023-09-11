import 'package:hangsman/utilites/score_class.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> openDB() async {
  final database = openDatabase(
    "score.db",
    version: 1,
    onCreate: (db, version) {
      db.execute(
          'CREATE TABLE score (id INTEGER PRIMARY KEY, scoreDate TEXT, userScore INTEGER )');
    },
  );
  return database;
}

Future<List<Score>> scores(final database) async {
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query("score");
  return List.generate(maps.length, (index) {
    return Score(
        id: maps[index]["id"],
        scoreDate: maps[index]["scoreDate"],
        userScore: maps[index]["userScore"]);
  });
}

void manipulateData(Score score, final database) async {
  await insertquery(score, database);
}

Future<void> insertquery(Score score, final database) async {
  final Database db = await database;
  await db.insert("score", score.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore);
}
