// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'package:worddle/utils/navigator.dart';
import 'package:worddle/views/game_home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        navigatorKey: navigator.key,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xFF13B9FF)),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        home: const GameHome(),
        builder: (BuildContext context, Widget? widget) {
          return OKToast(
            child: widget!,
          );
        },
      ),
    );
  }
}
