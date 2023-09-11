import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hangsman/screens/hangsman_screen.dart';
import 'package:hangsman/screens/high_score_screen.dart';
import 'package:hangsman/utilites/hangsman_words.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  final HangsmanWords hangsman = HangsmanWords();
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    widget.hangsman.readWord();
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.fromLTRB(8.0, 55.0, 8.0, 0),
              child: const Text(
                "HANGSMAN",
                style: TextStyle(
                    fontFamily: "FrederickatheGreat",
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0),
              ),
            ),
          ),
          const Divider(color: Colors.white, thickness: 1),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0),
              child: const Text(
                "CHALLENGE",
                style: TextStyle(
                    fontFamily: "FrederickatheGreat",
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0),
              ),
            ),
          ),
          Center(
            child: Image.asset(
              "images/gallow.png",
              height: height * 0.49,
            ),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => HangsmanScreen(
                                    hangsmanObject: widget.hangsman,
                                  )));
                    },
                    child: Text(
                      "Start Game",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          letterSpacing: 1,
                          fontSize: 26,
                          fontFamily: "OoohBaby",
                          fontWeight: FontWeight.w900,
                          color: Colors.indigo.shade200),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const HighScoreScreen()));
                    },
                    child: Text(
                      "High Score",
                      style: TextStyle(
                          fontSize: 26,
                          decoration: TextDecoration.underline,
                          letterSpacing: 1,
                          fontFamily: "OoohBaby",
                          fontWeight: FontWeight.w900,
                          color: Colors.indigo.shade200),
                    )),
              ],
            ),
          )
        ],
      )),
    );
  }
}
