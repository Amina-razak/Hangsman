import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

class HangsmanWords {
  int wordCount = 0;
  List<String> _word = [];
  var word;
  String firstword = "";
  String secondWord = "";
  List<int> usersNumber = [];
  Future readWord() async {
    word = generateWordPairs();
    firstword = word.toString().toLowerCase();
    print(firstword);
    secondWord = firstword.replaceAll(" ", "");
    _word = secondWord.toString().split(".").first.split("(").last.split(",");

    _word.removeLast();

    print(_word);
  }

  String getWord() {
    wordCount += 1;
    var random = Random();
    int wordlength = _word.length;

    int randNumber = random.nextInt(wordlength);
    bool notUnique = true;
    if (wordCount - 1 == wordlength) {
      notUnique = false;
      return "";
    }
    while (notUnique) {
      if (!usersNumber.contains(randNumber)) {
        notUnique = false;
        usersNumber.add(randNumber);
        return _word[randNumber];
      } else {
        randNumber = random.nextInt(wordlength);
      }
    }
    return "";
    // return word;
  }

  void resetWord() {
    wordCount = 0;
    usersNumber = [];
  }

  String getHiddenWord(int wordlength) {
    String hiddenWord = "";
    for (int i = 0; i < wordlength; i++) {
      hiddenWord += "_";
    }
    return hiddenWord;
  }
}
