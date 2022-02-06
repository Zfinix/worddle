import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pedantic/pedantic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worddle/core/models/worddle.dart';

class Storage {
  static Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  static FlutterSecureStorage get securePref => const FlutterSecureStorage();

  static Future saveItem({required item, required key}) async {
    unawaited(securePref.write(key: key.toString(), value: item));
  }

  static Future saveTime(DateTime time) async {
    unawaited(securePref.write(key: 'time', value: time.toIso8601String()));
  }

  static Future<DateTime?> getTime() async {
    final time = await securePref.read(key: 'time');
    return DateTime.tryParse(time ?? '');
  }

  static void eraseTime() async {
    await securePref.delete(key: 'time');
  }

  static Future saveGameDayIndex(int index) async {
    unawaited(securePref.write(key: 'currentGameDayIndex', value: '$index'));
  }

  static Future<int> getGameDayIndex() async {
    final time = await securePref.read(key: 'currentGameDayIndex');
    return int.parse(time ?? '0') ;
  }

  static void eraseGameDayIndex() async {
    await securePref.delete(key: 'currentGameDayIndex');
  }

  static Future saveWordList(List<List<Worddle>> emptyWordList) async {
    final joinWordle = emptyWordList
        .map(
          (it) => it.map((that) => that.toJson()).join('|'),
        )
        .join('-');
    unawaited(securePref.write(key: 'wordList', value: joinWordle));
  }

  static Future<List<List<Worddle>>?> getWordList() async {
    final joinedWordle = await securePref.read(key: 'wordList');

    if (joinedWordle == null) {
      return null;
    }

    final list = joinedWordle
        .split('-')
        .map(
          (it) => it
              .split('|')
              .map(
                (that) => Worddle.fromJson(that),
              )
              .toList(),
        )
        .toList();
    return list;
  }

  static void eraseWordList() async {
    await securePref.delete(key: 'wordList');
  }

  static Future saveIsLoggedIn(bool val) async {
    unawaited((await prefs).setBool('isLoggedIn', val));
  }

  static Future eraseItem({required key}) async {
    unawaited(securePref.delete(key: '$key'));
  }

  static Future<bool> keyExists({required String key}) async {
    return securePref.containsKey(key: key);
  }

  static void eraseAll() async {
    unawaited(securePref.deleteAll());
    unawaited((await prefs).clear());
    return;
  }

  static Future<dynamic>? getItemData({required key}) async {
    return await securePref.containsKey(key: '$key')
        ? securePref.read(key: '$key')
        : null;
  }
}
