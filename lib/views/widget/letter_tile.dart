import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worddle/core/models/worddle.dart';
import 'package:worddle/utils/colors.dart';
import 'package:worddle/utils/extensions/extensions.dart';
import 'package:worddle/widgets/shake.dart';
import 'package:worddle/widgets/touchable_opacity.dart';

class LetterTile extends StatelessWidget {
  const LetterTile({
    required this.data,
    required this.shakeKey,
    Key? key,
  }) : super(key: key);

  final Worddle data;
  final GlobalKey<ShakeWidgetState> shakeKey;

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget?.key);

        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: /* _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              :  */
              (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  Color get color {
    switch (data.state) {
      case WorddleState.correct:
        return green;
      case WorddleState.wrong:
        return grey;
      case WorddleState.wrongSpot:
        return lightGreen;
      default:
        return white;
    }
  }

  bool get _showFrontSide {
    switch (data.state) {
      case WorddleState.initial:
        return true;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {},
      child: data.answered
          ? AnsweredWorddleWidget(
              color: color,
              letter: data.letter,
            )
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: __transitionBuilder,
              layoutBuilder: (widget, list) => Stack(
                children: [
                  widget ?? const Offstage(),
                  ...list,
                ],
              ),
              switchInCurve: Curves.easeInBack,
              switchOutCurve: Curves.easeInBack.flipped,
              child: _showFrontSide
                  ? WorddleWidget(
                      letter: data.letter,
                    )
                  : AnsweredWorddleWidget(
                      color: color,
                      letter: data.letter,
                    ),
            ),
    );
  }
}

class WorddleWidget extends StatelessWidget {
  const WorddleWidget({
    Key? key,
    required this.letter,
    this.size,
  }) : super(key: key);

  final String letter;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
      ),
      margin: const EdgeInsets.all(5),
      height: size ?? context.screenWidth(.16),
      width: size ?? context.screenWidth(.16),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class AnsweredWorddleWidget extends StatelessWidget {
  const AnsweredWorddleWidget({
    Key? key,
    required this.color,
    required this.letter,
    this.size,
  }) : super(key: key);

  final Color color;
  final String letter;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
      ),
      margin: const EdgeInsets.all(5),
      height: size ?? context.screenWidth(.16),
      width: size ?? context.screenWidth(.16),
      child: Center(
        child: Text(
          letter,
          style: GoogleFonts.poppins(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
