import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hangsman/screens/home_screen.dart';
import 'package:hangsman/utilites/score_class.dart';
import 'package:hangsman/utilites/score_database.dart' as score_database;

class CustomDialogueBox extends StatefulWidget {
  const CustomDialogueBox(
      {super.key,
      required this.heading,
      required this.contentText,
      this.wordCout = ""});
  final String heading;
  final String contentText;
  final String wordCout;
  @override
  State<CustomDialogueBox> createState() => _CustomDialogueBoxState();
}

class _CustomDialogueBoxState extends State<CustomDialogueBox> {
  final database = score_database.openDB();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), side: BorderSide.none),
      child: Stack(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 15),
            Container(
              padding:
                  const EdgeInsets.only(top: 35, bottom: 10, left: 8, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                  color: Colors.blueGrey.shade900),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      widget.contentText,
                      style: const TextStyle(
                          fontFamily: "AbrilFatface", fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {
                            if (int.parse(widget.wordCout) > 0) {
                              Score score = Score(
                                  id: 1,
                                  scoreDate: DateTime.now().toString(),
                                  userScore: int.parse(widget.wordCout));
                              score_database.manipulateData(score, database);
                            }
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return WillPopScope(
                                    onWillPop: () async {
                                      return false;
                                    },
                                    child: AlertDialog(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      // buttonPadding: const EdgeInsets.only(left: 50, right: 10),
                                      backgroundColor: Colors.blueGrey.shade900,
                                      actions: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          HomeScreen()),
                                                  (route) => false);
                                            },
                                            icon: const Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: 30,
                                            )),
                                      ],
                                      title: const Center(
                                        child: Text("Game Over",
                                            style: TextStyle(
                                                fontFamily: "Creepster",
                                                color: Colors.red,
                                                fontSize: 30,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      content: Text(
                                          "your score : ${widget.wordCout}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300)),
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 30,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: -2,
            right: 100,
            child: Text(
              widget.heading,
              style: const TextStyle(
                  fontFamily: "Creepster", fontSize: 30, color: Colors.red),
            ))
      ]),
    );
  }
}
