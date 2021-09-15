import '../../pip_services3_components.dart';

/// Dummy implementation of logger that doesn't do anything.
///
/// It can be used in testing or in situations when logger is required
/// but shall be disabled.
///
/// See [ILogger]
class NullLogger implements ILogger {
  /// Creates a new instance of the logger.
  ///
  NullLogger();

  /// Gets the maximum log level.
  /// Messages with higher log level are filtered out.
  ///
  /// Return the maximum log level.
  @override
  LogLevel getLevel() {
    return LogLevel.None;
  }

  /// Set the maximum log level.
  ///
  /// - [value]     a new maximum log level.
  @override
  void setLevel(LogLevel value) {}

  /// Logs a message at specified log level.
  ///
  /// - [level]             a log level.
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void log(
      LogLevel level, String? correlationId, Exception? error, String message,
      [List? args]) {}

  /// Logs fatal (unrecoverable) message that caused the process to crash.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void fatal(String? correlationId, Exception? error, String message,
      [List? args]) {}

  /// Logs recoverable application error.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void error(String? correlationId, Exception? error, String message,
      [List? args]) {}

  /// Logs a warning that may or may not have a negative impact.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void warn(String? correlationId, String message, [List? args]) {}

  /// Logs an important information message
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void info(String? correlationId, String message, [List? args]) {}

  /// Logs a high-level debug information for troubleshooting.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void debug(String? correlationId, String message, [List? args]) {}

  /// Logs a low-level debug information for troubleshooting.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [message]           a human-readable message to log.
  /// - [args]              arguments to parameterize the message.
  @override
  void trace(String? correlationId, String message, [List? args]) {}
}
