import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:worddle/core/provider.dart';
import 'package:worddle/utils/colors.dart';
import 'package:worddle/utils/extensions/extensions.dart';
import 'package:worddle/utils/navigator.dart';
import 'package:worddle/widgets/touchable_opacity.dart';

class StatsPage extends HookConsumerWidget {
  const StatsPage({Key? key}) : super(key: key);

  static Future<C?> show<C>() => showCupertinoModalBottomSheet<C>(
        context: navigator.context,
        builder: (context) => SizedBox(
          height: context.screenHeight(.7),
          child: const StatsPage(),
        ),
      );

  @override
  Widget build(BuildContext context, ref) {
    final controller = ref.watch(
      gameVM.select(
        (it) => it.controller,
      ),
    );
    final endTime = ref.watch(
      gameVM.select(
        (it) => it.endTime,
      ),
    );
    return Material(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(24),
                Stack(
                  children: [
                    Center(
                      child: Text(
                        'STATISTICS',
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
                    text: 'Your ',
                    children: [
                      TextSpan(
                        text: 'WORDDLE ',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: 'game statistics')
                    ],
                  ),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    StatsWidget(
                      title: '2',
                      val: 'Played\n',
                    ),
                    StatsWidget(
                      title: '0',
                      val: 'Win%\n',
                    ),
                    StatsWidget(
                      title: '0',
                      val: 'Current\nStreak',
                    ),
                    StatsWidget(
                      title: '0',
                      val: 'Max\nStreak',
                    ),
                  ],
                ),
                if (controller != null && endTime != null) ...[
                  const Gap(16),
                  const Divider(
                    color: grey,
                    height: 2,
                  ),
                  const Gap(40),
                  Center(
                    child: Text(
                      'NEXT WORDLE',
                      style: GoogleFonts.poppins(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Gap(16),
                  CountdownTimer(
                    controller: controller,
                    textStyle: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(24),
                  TouchableOpacity(
                    onTap: ref.read(gameVM).onShare,
                    child: Container(
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SHARE',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: white,
                            ),
                          ),
                          const Gap(8),
                          const Icon(
                            Icons.share_outlined,
                            color: white,
                          )
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatsWidget extends StatelessWidget {
  const StatsWidget({
    Key? key,
    required this.title,
    required this.val,
  }) : super(key: key);
  final String title, val;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 42,
            ),
          ),
          Text(
            val,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
