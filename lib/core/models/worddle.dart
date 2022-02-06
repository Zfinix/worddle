// ignore_for_file: sort_constructors_first

import 'dart:convert';

enum WorddleState { initial, correct, wrongSpot, wrong }

class Worddle {
  const Worddle({
    required this.letter,
    this.state = WorddleState.initial,
    this.answered = false,
  });

  final String letter;
  final WorddleState state;
  final bool answered;

  Worddle copyWith({
    String? letter,
    WorddleState? state,
    bool? answered,
  }) {
    return Worddle(
      letter: letter ?? this.letter,
      state: state ?? this.state,
      answered: answered ?? this.answered,
    );
  }

  @override
  String toString() => letter;

  Map<String, dynamic> toMap() {
    return {
      'letter': letter,
      'state': state.index,
      'answered': answered,
    };
  }

  factory Worddle.fromMap(Map<String, dynamic> map) {
    return Worddle(
      letter: map['letter'] ?? '',
      state: WorddleState.values[map['state']],
      answered: map['answered'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Worddle.fromJson(String source) =>
      Worddle.fromMap(json.decode(source));
}
