import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:worddle/core/models/worddle.dart';
import 'package:worddle/utils/colors.dart';
import 'package:worddle/utils/extensions/extensions.dart';
import 'package:worddle/utils/navigator.dart';
import 'package:worddle/views/widget/letter_tile.dart';
import 'package:worddle/widgets/shake.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  static Future<C?> show<C>() => showCupertinoModalBottomSheet<C>(
        context: navigator.context,
        builder: (context) => SizedBox(
          height: context.screenHeight(.85),
          child: const HelpPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(24),
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'HOW TO PLAY',
                        style: GoogleFonts.poppins(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          context.popView();
                        },
                      ),
                    ).nudge(y: -10)
                  ],
                ),
                const Gap(24),
                Text.rich(
                  TextSpan(
                    text: 'Guess the ',
                    children: [
                      TextSpan(
                        text: 'WORDDLE ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: 'in 6 tries.')
                    ],
                  ),
                ),
                const Gap(20),
                const Text(
                  'Each guess must be a valid 5 letter word. '
                  'Hit the enter button to submit.'
                  '\n\nAfter each guess, the color of the tiles '
                  'will change to show how close your guess was to the word.',
                ),
                const Gap(16),
                const Divider(
                  color: grey,
                  height: 2,
                ),
                const Gap(16),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'Examples',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LetterTile(
                data: const Worddle(
                  letter: 'W',
                  answered: true,
                  state: WorddleState.correct,
                ),
                shakeKey: GlobalKey<ShakeWidgetState>(),
              ),
              for (var l in 'EARY'.split(''))
                WorddleWidget(
                  letter: l,
                ),
            ],
          ).scale(.95),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text.rich(
              TextSpan(
                text: 'The letter ',
                children: [
                  TextSpan(
                    text: 'W ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                      text: 'is in the word and in the correct spot.')
                ],
              ),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const WorddleWidget(
                letter: 'P',
              ),
              LetterTile(
                shakeKey: GlobalKey<ShakeWidgetState>(),
                data: const Worddle(
                  letter: 'O',
                  answered: true,
                  state: WorddleState.wrongSpot,
                ),
              ),
              for (var l in 'LLS'.split(''))
                WorddleWidget(
                  letter: l,
                ),
            ],
          ).scale(.95),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text.rich(
              TextSpan(
                text: 'The letter ',
                children: [
                  TextSpan(
                    text: 'O ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: 'is in the word but in the wrong spot.',
                  )
                ],
              ),
            ),
          ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (var l in 'TOW'.split(''))
                WorddleWidget(
                  letter: l,
                ),
              LetterTile(
                shakeKey: GlobalKey<ShakeWidgetState>(),
                data: const Worddle(
                  letter: 'E',
                  answered: true,
                  state: WorddleState.wrong,
                ),
              ),
              const WorddleWidget(
                letter: 'R',
              ),
            ],
          ).scale(.95),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text.rich(
              TextSpan(
                text: 'The letter ',
                children: [
                  TextSpan(
                    text: 'E ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: 'is not in the word in any spot.',
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
