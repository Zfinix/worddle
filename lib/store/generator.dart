import 'package:dartz/dartz.dart';
import 'package:jiffy/jiffy.dart';
import 'package:worddle/core/models/worddle.dart';
import 'package:worddle/store/word_list_store.dart';

class WorddleGenerator {
  var list = {...globalWordList, ...globalHardWordList}.toList();

  static int getLaunchDate = Jiffy().diff(Jiffy('2021/06/21'), Units.DAY).toInt();

  bool contains(String val) => list.contains(val.toLowerCase());

  List<Worddle> generate([int lastIndex = 0]) {
    var currentIndex = getLaunchDate + lastIndex;

    if (currentIndex > list.length) {
      getLaunchDate = Jiffy().diff(Jiffy('2022/01/26'), Units.HOUR).toInt();
    }

    return list[currentIndex]
        .split('')
        .map((it) => Worddle(letter: it.toUpperCase()))
        .toList();
  }

  List<List<Worddle>> generateEmpty() {
    return List.generate(
      6,
      (_) => List.generate(
        5,
        (index) => const Worddle(letter: ''),
      ),
    );
  }
}
