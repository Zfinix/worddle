import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

var logger = Logger(
  printer: SimpleLogPrinter(className: 'Worddle'),
);

class SimpleLogPrinter extends LogPrinter {
  SimpleLogPrinter({
    this.className,
  });

  final String? className;

  @override
  List<String> log(LogEvent event, [dynamic error, StackTrace? stackTrace]) {
    /// Don't log if in release mode
    if (kReleaseMode) return [];

    final emoji = PrettyPrinter.levelEmojis[event.level];
    final color = PrettyPrinter.levelColors[event.level];
    final message = stringifyMessage(event.message);

    /* if (event.level == Level.error) {
      FirebaseCrashlytics.instance.recordError(
        message,
        stackTrace,
        fatal: true,
      );
    }
 */
    return [
      Platform.isIOS ? '$emoji$message\n' : color!('$emoji$message\n'),
    ];
  }

  String? stringifyMessage(dynamic message) {
    const decoder = JsonDecoder();
    const encoder = JsonEncoder.withIndent('  ');
    final color = AnsiColor.fg(15);

    if (message is String) {
      try {
        if (message.contains(':') == false || message.contains('->')) {
          return message;
        }
        final raw = decoder.convert(message);
        return Platform.isAndroid
            ? color(encoder.convert(raw))
            : encoder.convert(raw);
      } catch (e) {
        return message.toString();
      }
    } else if (message is Map || message is Iterable) {
      return Platform.isAndroid
          ? color(encoder.convert(message))
          : encoder.convert(message);
    } else {
      return message.toString();
    }
  }
}
