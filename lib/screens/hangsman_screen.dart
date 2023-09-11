import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hangsman/screens/home_screen.dart';
import 'package:hangsman/utilites/alphabets.dart';
import 'package:hangsman/utilites/custom_dialogue_box.dart';
import 'package:hangsman/utilites/hangsman_words.dart';
import 'package:hangsman/utilites/score_class.dart';
import 'package:hangsman/utilites/score_database.dart' as score_database;

class HangsmanScreen extends StatefulWidget {
  const HangsmanScreen({super.key, required this.hangsmanObject});
  final HangsmanWords hangsmanObject;
  @override
  State<HangsmanScreen> createState() => _HangsmanScreenState();
}

class _HangsmanScreenState extends State<HangsmanScreen> {
  final database = score_database.openDB();
  int lives = 5;
  int wordCout = 0;
  late String hiddenWord;
  List<bool> buttonStatus = [];
  Alphabets alphabets = Alphabets();
  int hangState = 0;
  bool hintStatus = false;
  List<int> hintLetters = [];
  String word = '';
  List<String> wordlist = [];
  bool finishedGame = false;
  bool resetGame = false;
  int hintCount = 5;
  Widget keyboardbutton(index) {
    return Container(
      padding: const EdgeInsets.all(0),
      child: Center(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(4.0),
                  backgroundColor: buttonStatus[index]
                      ? Colors.indigo.shade400
                      : Colors.blueGrey.shade700),
              onPressed: () {
                buttonStatus[index] ? wordpress(index) : null;
              },
              child: Text(
                alphabets.alphabets[index].toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ))),
    );
  }

  void startGame() {
    widget.hangsmanObject.resetWord();
    wordCout = 0;
    finishedGame = false;
    alphabets = Alphabets();
    hangState = 0;
    resetGame = false;
    initialcall();
  }

  gethint() {
    if (hintCount > 0) {
      for (int i = 0; i < wordlist.length; i++) {
        if (wordlist[i] != "") {
          hintCount -= 1;
          setState(() {
            String firstletter = wordlist[i];
            for (int j = 0; j < wordlist.length; j++) {
              if (wordlist[j] == firstletter) {
                hiddenWord = hiddenWord.replaceFirst(RegExp("_"), word[j], j);
                wordlist[j] = "";
                if (wordlist.every((element) => element == "")) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async {
                            return false;
                          },
                          child: AlertDialog(
                            elevation: 1,
                            backgroundColor: Colors.blueGrey.shade900,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            actions: [
                              IconButton(
                                  onPressed: () async {
                                    wordCout += 1;
                                    Navigator.of(context).pop();
                                    initialcall();
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.arrow_right_circle,
                                    size: 30,
                                  ))
                            ],
                            title: Center(
                              child: Text(word,
                                  style: const TextStyle(
                                      fontFamily: "BricolageGrotesque",
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1)),
                            ),
                          ),
                        );
                      });
                }
              }

              for (int index = 0; index < alphabets.alphabets.length; index++) {
                if (firstletter == alphabets.alphabets[index]) {
                  buttonStatus[index] = false;
                }
              }
            }
          });

          return;
        }
      }
    } else if (hintCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content:
            const Text("no more hint", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey.shade900,
      ));
    }
  }

  initialcall() {
    wordlist = [];
    hiddenWord = "";
    hintStatus = true;
    hintLetters = [];
    buttonStatus = List.generate(26, (index) {
      return true;
    });
    word = widget.hangsmanObject.getWord();
    // word = widget.hangsmanObject.word.first;
    if (word.isNotEmpty) {
      hiddenWord = widget.hangsmanObject.getHiddenWord(word.length);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
          (route) => false);
    }
    for (int i = 0; i < word.length; i++) {
      setState(() {
        wordlist.add(word[i]);
        print(wordlist);
        hintLetters.add(i);
      });
    }
  }

  void wordpress(int index) {
    if (lives == 0) {
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
                    borderRadius: BorderRadius.circular(20)),
                // buttonPadding: const EdgeInsets.only(left: 50, right: 10),
                backgroundColor: Colors.blueGrey.shade900,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    HomeScreen()),
                            (route) => false);
                      },
                      icon: const Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 30,
                      )),
                  Visibility(
                    visible: lives != 0,
                    child: IconButton(
                        onPressed: () {
                          startGame();
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 30,
                        )),
                  )
                ],
                title: const Center(
                  child: Text("Game Over",
                      style: TextStyle(
                          fontFamily: "Creepster",
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.w400)),
                ),
                content: Text("your score : $wordCout",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300)),
              ),
            );
          });
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
      //     (route) => false);
    }
    if (finishedGame) {
      setState(() {
        resetGame = true;
      });
      return;
    }
    bool check = false;
    setState(() {
      for (int i = 0; i < wordlist.length; i++) {
        if (wordlist[i] == alphabets.alphabets[index]) {
          check = true;
          wordlist[i] = "";
          hiddenWord = hiddenWord.replaceFirst(RegExp("_"), word[i], i);
        }
      }
      for (int i = 0; i < wordlist.length; i++) {
        if (wordlist[i] == "") {
          hintLetters.remove(i);
        }
      }
      if (!check) {
        hangState += 1;
      }
      if (hangState == 6) {
        lives -= 1;
        finishedGame = true;
        if (lives > 0) {
          if (wordCout > 0) {
            Score score = Score(
                id: 1,
                scoreDate: DateTime.now().toString(),
                userScore: wordCout);
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
                        borderRadius: BorderRadius.circular(20)),
                    // buttonPadding: const EdgeInsets.only(left: 50, right: 10),
                    backgroundColor: Colors.blueGrey.shade900,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomeScreen()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 30,
                          )),
                      Visibility(
                        visible: lives != 0,
                        child: IconButton(
                            onPressed: () {
                              startGame();
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 30,
                            )),
                      )
                    ],
                    title: const Center(
                      child: Text("Game Over",
                          style: TextStyle(
                              fontFamily: "Creepster",
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.w400)),
                    ),
                    content: Text("your score : $wordCout",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300)),
                  ),
                );
              });
        }
      }
      buttonStatus[index] = false;
      if (hiddenWord == word) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: AlertDialog(
                  elevation: 1,
                  backgroundColor: Colors.blueGrey.shade900,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          wordCout += 1;
                          Navigator.of(context).pop();
                          initialcall();
                        },
                        icon: const Icon(
                          CupertinoIcons.arrow_right_circle,
                          size: 30,
                        ))
                  ],
                  title: Center(
                    child: Text(word,
                        style: const TextStyle(
                            fontFamily: "BricolageGrotesque",
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1)),
                  ),
                ),
              );
            });
      }
    });
  }

  exitFunction() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogueBox(
            heading: "Game Exit",
            contentText: 'Do you want to exit?',
            wordCout: wordCout.toString(),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    initialcall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exitFunction();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 8, right: 8, top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            CupertinoIcons.heart_fill,
                                            color: Colors.white,
                                            size: 36,
                                          ))),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        top: 19, left: 18),
                                    child: Text(
                                      lives.toString(),
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade800,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'PatrickHand',
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(wordCout.toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PatrickHand",
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            height: 50,
                            width: 70,
                            decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      gethint();
                                    },
                                    icon: const Icon(Icons.lightbulb, size: 34),
                                    tooltip: "hint"),
                                Text(
                                  hintCount.toString(),
                                  style: const TextStyle(fontSize: 20),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.only(top: 10),
                        alignment: Alignment.bottomCenter,
                        child: Image.asset("images/$hangState.png"),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Center(
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  hiddenWord,
                                  style: const TextStyle(
                                      letterSpacing: 8,
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w400),
                                )),
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 20, top: 10, left: 8, right: 8),
                      child: Table(children: [
                        TableRow(children: [
                          TableCell(child: keyboardbutton(0)),
                          TableCell(child: keyboardbutton(1)),
                          TableCell(child: keyboardbutton(2)),
                          TableCell(child: keyboardbutton(3)),
                        ]),
                        TableRow(children: [
                          TableCell(child: keyboardbutton(4)),
                          TableCell(child: keyboardbutton(5)),
                          TableCell(child: keyboardbutton(6)),
                          TableCell(child: keyboardbutton(7)),
                        ]),
                        TableRow(children: [
                          TableCell(child: keyboardbutton(8)),
                          TableCell(child: keyboardbutton(9)),
                          TableCell(child: keyboardbutton(10)),
                          TableCell(child: keyboardbutton(11)),
                        ]),
                        TableRow(children: [
                          TableCell(child: keyboardbutton(12)),
                          TableCell(child: keyboardbutton(13)),
                          TableCell(child: keyboardbutton(14)),
                          TableCell(child: keyboardbutton(15)),
                        ]),
                        TableRow(children: [
                          TableCell(child: keyboardbutton(16)),
                          TableCell(child: keyboardbutton(17)),
                          TableCell(child: keyboardbutton(18)),
                          TableCell(child: keyboardbutton(19)),
                        ]),
                        TableRow(children: [
                          TableCell(child: keyboardbutton(20)),
                          TableCell(child: keyboardbutton(21)),
                          TableCell(child: keyboardbutton(22)),
                          TableCell(child: keyboardbutton(23)),
                        ]),
                        TableRow(children: [
                          TableCell(child: keyboardbutton(24)),
                          TableCell(child: keyboardbutton(25)),
                          const TableCell(child: Text("")),
                          const TableCell(child: Text(""))
                        ])
                      ]),
                    )
                  ],
                ))
          ],
        )),
      ),
    );
  }
}
