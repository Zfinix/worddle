import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:worddle/core/provider.dart';
import 'package:worddle/utils/colors.dart';
import 'package:worddle/utils/extensions/extensions.dart';
import 'package:worddle/views/help/help_page.dart';
import 'package:worddle/views/stats/stats_page.dart';
import 'package:worddle/views/widget/letter_tile.dart';
import 'package:worddle/widgets/keyboard.dart';
import 'package:worddle/widgets/shake.dart';

class GameHome extends StatefulHookConsumerWidget {
  const GameHome({Key? key}) : super(key: key);

  @override
  ConsumerState<GameHome> createState() => _GameHomeState();
}

class _GameHomeState extends ConsumerState<GameHome> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(gameVM).initialize();
    controller.addListener(() {
      ref.read(gameVM).onType(controller.text);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final worddles = ref.watch(
      gameVM.select(
        (it) => it.wordList,
      ),
    );

    final emptyWorddles = ref.watch(
      gameVM.select(
        (it) => it.emptyWordList,
      ),
    );
    final shakeKeys = ref.watch(
      gameVM.select(
        (it) => it.shakeKeys,
      ),
    );

    final locked = ref.watch(
      gameVM.select(
        (it) => it.locked,
      ),
    );

    final confetti = ref.watch(
      gameVM.select(
        (it) => it.confetti,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: [
                Center(
                  child: Row(
                    children: [
                      IconButton(
                        color: Colors.black45,
                        icon:
                            const Icon(FluentIcons.question_circle_28_regular),
                        onPressed: () async {
                          await HelpPage.show();
                        },
                      ),
                      Gap(context.screenWidth(.11)),
                      const Spacer(),
                      Text(
                        'WORDDLE',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        color: Colors.black45,
                        icon: const Icon(
                            FluentIcons.data_bar_vertical_24_regular),
                        onPressed: () async {
                          await StatsPage.show();
                        },
                      ),
                      IconButton(
                        color: Colors.black45,
                        icon: const Icon(FluentIcons.settings_24_filled),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                AbsorbPointer(
                  absorbing: locked,
                  child: Column(
                    children: [
                      const Divider(color: Colors.black12),
                      const Gap(30),
                      for (var i = 0; i < emptyWorddles.length; i++)
                        ShakeWidget(
                          key: shakeKeys[i],
                          shakeCount: 3,
                          shakeOffset: 10,
                          shakeDuration: const Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var w = 0; w < emptyWorddles[i].length; w++)
                                LetterTile(
                                  shakeKey: shakeKeys[i],
                                  data: emptyWorddles[i][w],
                                ),
                            ],
                          ).scale(.9),
                        ),
                      const Gap(30),
                      BuiltInKeyboard(
                        controller: controller,
                        layoutType: 'EN',
                        borderRadius: BorderRadius.circular(8.0),
                        letterStyle: const TextStyle(
                          fontSize: 25,
                          color: black,
                        ),
                        onEnterTap: (val) {
                          ref.read(gameVM).handleEnter(val, context);
                          setState(() {});
                          if (val.length > 4 &&
                              ref.read(gameVM).worddleGen.contains(val) !=
                                  false) {
                            controller.clear();
                          }
                        },
                      ).scale(.9),
                    ],
                  ),
                )
              ],
            ),

            /// Bottom right confetti
            Positioned.fill(
              child: Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: confetti,

                  blastDirection: -pi, // radial value - LEFT
                  particleDrag: 0.03, // apply drag to the confetti
                  emissionFrequency: 0.2, // how often it should emit
                  numberOfParticles: 10, // number of particles to emit
                  gravity: 0.4, // gravity - or fall speed
                  shouldLoop: false,
                  // manually specify the colors to be used
                ),
              ),
            ),

            /// Bottom right confetti
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: confetti,
                  blastDirection: -pi * 2, // radial value - LEFT
                  particleDrag: 0.03, // apply drag to the confetti
                  emissionFrequency: 0.2, // how often it should emit
                  numberOfParticles: 10, // number of particles to emit
                  gravity: 0.4, // gravity - or fall speed
                  shouldLoop: false,
                  // manually specify the colors to be used
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
