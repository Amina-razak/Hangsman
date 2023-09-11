import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hangsman/screens/score_screen.dart';
import 'package:hangsman/utilites/score_database.dart' as score_database;

class HighScoreScreen extends StatefulWidget {
  const HighScoreScreen({super.key});

  @override
  State<HighScoreScreen> createState() => _HighScoreScreenState();
}

class _HighScoreScreenState extends State<HighScoreScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      queryDB();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  queryDB() async {
    final database = score_database.openDB();
    final queryResult = await score_database.scores(database);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ScoreScreen(
        scoreDetails: queryResult,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: SpinKitDoubleBounce(
        color: Colors.white,
        size: 100,
      )),
    );
  }
}
