import 'package:pip_services3_components/pip_services3_components.dart';

/// Todo: solve issue with overloaded methods. Look at Python implementation
/// Interface for logger components that capture execution log messages.

abstract class ILogger {
  /// Gets the maximum log level.
  /// Messages with higher log level are filtered out.
  ///
  /// Return the maximum log level.
  LogLevel getLevel();

  /// Set the maximum log level.
  ///
  /// - [value]     a new maximum log level.
  void setLevel(LogLevel value);

  /// Logs a message at specified log level.
  ///
  /// - [level]             a log level.
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void log(
      LogLevel level, String correlationId, Exception error, String message,
      [List args]);

  /// Logs fatal (unrecoverable) message that caused the process to crash.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void fatal(String correlationId, Exception error, String message,
      [List args]);

  // Todo: these overloads are not supported in TS
  //fatal(String correlationId, error: Exception) ;
  //fatal(String correlationId, String message, List args) ;

  /// Logs recoverable application error.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void error(String correlationId, Exception error, String message,
      [List args]);

  // Todo: these overloads are not supported in TS
  //error(String correlationId, error: Exception) ;
  //error(String correlationId, String message, List args) ;

  /// Logs a warning that may or may not have a negative impact.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void warn(String correlationId, String message, [List args]);

  /// Logs an important information message
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void info(String correlationId, String message, [List args]);

  /// Logs a high-level debug information for troubleshooting.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void debug(String correlationId, String message, [List args]);

  /// Logs a low-level debug information for troubleshooting.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  void trace(String correlationId, String message, [List args]);
}
