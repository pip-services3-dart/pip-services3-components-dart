import 'package:pip_services3_commons/pip_services3_commons.dart';
import './LogLevel.dart';

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
  /// - value     a new maximum log level.
  void setLevel(LogLevel value);

  /// Logs a message at specified log level.
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  log(LogLevel level, String correlationId, ApplicationException error, String message,
      List args);

  /// Logs fatal (unrecoverable) message that caused the process to crash.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  fatal(String correlationId, ApplicationException error, String message, List args);

  // Todo: these overloads are not supported in TS
  //fatal(String correlationId, error: ApplicationException) ;
  //fatal(String correlationId, String message, List args) ;

  /// Logs recoverable application error.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  error(String correlationId, ApplicationException error, String message, List args);

  // Todo: these overloads are not supported in TS
  //error(String correlationId, error: ApplicationException) ;
  //error(String correlationId, String message, List args) ;

  /// Logs a warning that may or may not have a negative impact.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  warn(String correlationId, String message, List args);

  /// Logs an important information message
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  info(String correlationId, String message, List args);

  /// Logs a high-level debug information for troubleshooting.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  debug(String correlationId, String message, List args);

  /// Logs a low-level debug information for troubleshooting.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  trace(String correlationId, String message, List args);
}
