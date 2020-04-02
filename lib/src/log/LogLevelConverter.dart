import 'package:pip_services3_commons/src/convert/StringConverter.dart';
import '../../pip_services3_components.dart';

/// Helper class to convert log level values.
///
/// See [LogLevel]
class LogLevelConverter {
  /// Converts numbers and strings to standard log level values.
  ///
  /// - [value]         a value to be converted
  /// - [defaultValue]  a default value if conversion is not possible
  /// Return converted log level
  static LogLevel toLogLevel(dynamic value,
      [LogLevel defaultValue = LogLevel.Info]) {
    if (value == null) return LogLevel.Info;

    value = StringConverter.toString2(value).toUpperCase();
    if ('0' == value || 'NOTHING' == value || 'NONE' == value) {
      return LogLevel.None;
    } else if ('1' == value || 'FATAL' == value) {
      return LogLevel.Fatal;
    } else if ('2' == value || 'ERROR' == value) {
      return LogLevel.Error;
    } else if ('3' == value || 'WARN' == value || 'WARNING' == value) {
      return LogLevel.Warn;
    } else if ('4' == value || 'INFO' == value) {
      return LogLevel.Info;
    } else if ('5' == value || 'DEBUG' == value) {
      return LogLevel.Debug;
    } else if ('6' == value || 'TRACE' == value) {
      return LogLevel.Trace;
    } else {
      return defaultValue;
    }
  }

  /// Converts log level to a string.
  ///
  /// - [level]     a log level to convert
  /// Return log level name string.
  ///
  /// See [LogLevel]
  static String toString2(LogLevel level) {
    if (level == LogLevel.Fatal) return 'FATAL';
    if (level == LogLevel.Error) return 'ERROR';
    if (level == LogLevel.Warn) return 'WARN';
    if (level == LogLevel.Info) return 'INFO';
    if (level == LogLevel.Debug) return 'DEBUG';
    if (level == LogLevel.Trace) return 'TRACE';
    return 'UNDEF';
  }

  /// Converts log level to a number.
  ///
  /// - level     a log level to convert.
  /// Return log level number value.
  static int toInteger(LogLevel level) {
    if (level == LogLevel.Fatal) return 1;
    if (level == LogLevel.Error) return 2;
    if (level == LogLevel.Warn) return 3;
    if (level == LogLevel.Info) return 4;
    if (level == LogLevel.Debug) return 5;
    if (level == LogLevel.Trace) return 6;
    return 0;
  }
}
