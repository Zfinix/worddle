import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:worddle/core/models/worddle.dart';
import 'package:worddle/store/generator.dart';
import 'package:worddle/utils/colors.dart';
import 'package:worddle/utils/extensions/extensions.dart';
import 'package:worddle/utils/storage.dart';
import 'package:worddle/views/stats/stats_page.dart';
import 'package:worddle/widgets/shake.dart';

class GameVM extends ChangeNotifier {
  GameVM(this.read);

  final Reader read;
  final worddleGen = WorddleGenerator();
  CountdownTimerController? controller;
  final screenshotController = ScreenshotController();

  final confettiRight = ConfettiController(
    duration: const Duration(
      seconds: 2,
    ),
  );

  final confetti = ConfettiController(
    duration: const Duration(
      seconds: 2,
    ),
  );

  List<Worddle> _wordList = [];
  List<Worddle> get wordList => _wordList;
  set wordList(List<Worddle> val) {
    _wordList = val;
    notifyListeners();
  }

  int _currentGameDayIndex = 0;
  int get currentGameDayIndex => _currentGameDayIndex;
  set currentGameDayIndex(int val) {
    _currentGameDayIndex = val;
    notifyListeners();
  }

  List<List<Worddle>> _emptyWordList = [];
  List<List<Worddle>> get emptyWordList => _emptyWordList;
  set emptyWordList(List<List<Worddle>> val) {
    _emptyWordList = val;
    notifyListeners();
  }

  List<GlobalKey<ShakeWidgetState>> _shakeKeys = [];
  List<GlobalKey<ShakeWidgetState>> get shakeKeys => _shakeKeys;
  set shakeKeys(List<GlobalKey<ShakeWidgetState>> val) {
    _shakeKeys = val;
    notifyListeners();
  }

  List<Worddle> get currentEmptyWorddle => emptyWordList[currentIndex];

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  set currentIndex(int val) {
    _currentIndex = val;
    notifyListeners();
  }

  bool _locked = false;
  bool get locked => _locked;
  set locked(bool val) {
    _locked = val;
    notifyListeners();
  }

  DateTime? _endTime;
  DateTime? get endTime => _endTime;
  set endTime(DateTime? val) {
    _endTime = val;
    notifyListeners();
  }

  void initialize() async {
    currentGameDayIndex = await Storage.getGameDayIndex();

    wordList = worddleGen.generate(currentGameDayIndex);
    emptyWordList = worddleGen.generateEmpty();

    shakeKeys = List.generate(
      emptyWordList.length,
      (index) => GlobalKey<ShakeWidgetState>(),
    );

    onEnd();
    endTime = await Storage.getTime();

    if (endTime != null) {
      final val = await Storage.getWordList();

      if (val != null) {
        emptyWordList = val;
      }

      locked = true;
      controller = CountdownTimerController(
        endTime: endTime!.millisecondsSinceEpoch + 1000 * 30,
        onEnd: onEnd,
      );

      await Future.delayed(const Duration(seconds: 3));

      await StatsPage.show();
    }
    print(wordList);
  }

  void onType(String val) {
    final list = val.padRight(5, ' ').split('');

    for (var i = 0; i < list.length; i++) {
      emptyWordList[currentIndex] = emptyWordList[currentIndex].update(
        i,
        Worddle(
          letter: list[i],
        ),
      );
    }

    notifyListeners();
  }

  void handleEnter(String val, BuildContext context) {
    print(val);
    if (val.length <= 4) {
      showAppToast('Not enough letters');
      shake();
    } else if (worddleGen.contains(val) == false) {
      showAppToast('Not in word list');
      shake();
    } else {
      final enteredWord = val.split('');

      for (var i = 0; i < wordList.length; i++) {
        final _worddle = wordList[i];
        final enteredWorddle = enteredWord[i];

        print('_worddle: $_worddle');
        print('enteredWorddle: $enteredWorddle');

        if (_worddle.letter == enteredWorddle) {
          emptyWordList[currentIndex] = emptyWordList[currentIndex].update(
            i,
            _worddle.copyWith(
              letter: enteredWorddle,
              state: WorddleState.correct,
            ),
          );
        } else if (wordList.map((e) => e.letter).contains(enteredWorddle)) {
          emptyWordList[currentIndex] = emptyWordList[currentIndex].update(
            i,
            _worddle.copyWith(
              letter: enteredWorddle,
              state: WorddleState.wrongSpot,
            ),
          );
        } else {
          emptyWordList[currentIndex] = emptyWordList[currentIndex].update(
            i,
            _worddle.copyWith(
              letter: enteredWorddle,
              state: WorddleState.wrong,
            ),
          );
        }
      }

      final listOfCorrect = emptyWordList[currentIndex]
          .where((it) => it.state == WorddleState.correct)
          .toList();

      if (listOfCorrect.length == 5) {
        confetti.play();
        currentGameDayIndex++;
        lockGame();
      } else if (currentIndex == 5) {
        lockGame();
      }

      currentIndex++;
      notifyListeners();
    }
  }

  ToastFuture showAppToast(String text) {
    return showToastWidget(
      Padding(
        padding: const EdgeInsets.only(top: 60),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Material(
            color: black,
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                    fontSize: 18, color: white, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
      position: ToastPosition.top,
    );
  }

  void shake() => shakeKeys[currentIndex].currentState?.shake();

  Future lockGame() async {
    locked = true;
    endTime = DateTime.now().add(const Duration(seconds: 3600));

    await Storage.saveTime(endTime!);
    await Storage.saveGameDayIndex(currentGameDayIndex);
    await Storage.saveWordList(emptyWordList);

    controller = CountdownTimerController(
      endTime: endTime!.millisecondsSinceEpoch + 1000 * 30,
      onEnd: onEnd,
    );

    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));

    await StatsPage.show();
  }

  void onShare() async {
    final val = emptyWordList
        .map<String>(
          (e) => e.map<String>(
            (e) {
              switch (e.state) {
                case WorddleState.correct:
                  return '🟩';
                case WorddleState.wrongSpot:
                  return '🟨';
                case WorddleState.wrong:
                  return '⬛';
                default:
                  return '⬜';
              }
            },
          ).join(''),
        )
        .toList()
      ..removeWhere((e) => e == '⬜⬜⬜⬜⬜');

    var shareText =
        'Wordle ${WorddleGenerator.getLaunchDate + 2} ${val.length}/6\n${val.join('\n')}';
    await Clipboard.setData(
      ClipboardData(text: shareText),
    );
    await Share.share(shareText);
  }

  void onEnd() {
    locked = false;
    endTime = null;
    currentIndex = 0;
    Storage.eraseAll();
    Storage.eraseWordList();
  }

  @override
  void dispose() {
    controller?.dispose();
    confetti.dispose();
    super.dispose();
  }
}
