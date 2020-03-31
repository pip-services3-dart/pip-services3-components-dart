import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:sprintf/sprintf.dart';

import './ILogger.dart';
import './LogLevel.dart';
import './LogLevelConverter.dart';
import '../info/ContextInfo.dart';

/// Abstract logger that captures and formats log messages.
/// Child classes take the captured messages and write them to their specific destinations.
/// ### Configuration parameters ###
///
/// Parameters to pass to the [configure] method for component configuration:
///
/// - level:             maximum log level to capture
/// - source:            source (context) name
///
/// ### References ###
///
/// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
///
/// See [ILogger]
abstract class Logger implements ILogger, IReconfigurable, IReferenceable {
  LogLevel _level = LogLevel.Info;
  String _source = null;

  /// Creates a new instance of the logger.
  Logger() {}

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    this._level =
        LogLevelConverter.toLogLevel(config.getAsObject("level"), this._level);
    this._source = config.getAsStringWithDefault("source", this._source);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  void setReferences(IReferences references) {
    var contextInfo = references.getOneOptional<ContextInfo>(
        new Descriptor("pip-services", "context-info", "*", "*", "1.0"));
    if (contextInfo != null && this._source == null) {
      this._source = contextInfo.name;
    }
  }

  /// Gets the maximum log level.
  /// Messages with higher log level are filtered out.
  ///
  /// Return the maximum log level.
  LogLevel getLevel() {
    return this._level;
  }

  /// Set the maximum log level.
  ///
  /// - value     a new maximum log level.
  void setLevel(LogLevel value) {
    this._level = value;
  }

  /// Gets the source (context) name.
  ///
  /// Return the source (context) name.
  String getSource() {
    return this._source;
  }

  /// Sets the source (context) name.
  ///
  /// - value     a new source (context) name.
  void setSource(String value) {
    this._source = value;
  }

  /// Writes a log message to the logger destination.
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  void _write(LogLevel level, String correlationId, ApplicationException error,
      String message);

  /// Formats the log message and writes it to the logger destination.
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  _formatAndWrite(LogLevel level, String correlationId,
      ApplicationException error, String message, List args) {
    message = message != null ? message : "";
    if (args != null && args.length > 0) {
      // message = message.replace(/{(\d+)}/g, function (match, number) {
      //     return typeof args[number] != 'undefined' ? args[number] : match;
      // });
      message = sprintf(message, args);
    }

    this._write(level, correlationId, error, message);
  }

  /// Logs a message at specified log level.
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void log(LogLevel level, String correlationId, ApplicationException error,
      String message, List args) {
    this._formatAndWrite(level, correlationId, error, message, args);
  }

  /// Logs fatal (unrecoverable) message that caused the process to crash.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void fatal(String correlationId, ApplicationException error, String message,
      List args) {
    this._formatAndWrite(LogLevel.Fatal, correlationId, error, message, args);
  }

  /// Logs recoverable application error.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void error(String correlationId, ApplicationException error, String message,
      List args) {
    this._formatAndWrite(LogLevel.Error, correlationId, error, message, args);
  }

  /// Logs a warning that may or may not have a negative impact.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void warn(String correlationId, String message, List args) {
    this._formatAndWrite(LogLevel.Warn, correlationId, null, message, args);
  }

  /// Logs an important information message
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void info(String correlationId, String message, List args) {
    this._formatAndWrite(LogLevel.Info, correlationId, null, message, args);
  }

  /// Logs a high-level debug information for troubleshooting.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void debug(String correlationId, String message, List args) {
    this._formatAndWrite(LogLevel.Debug, correlationId, null, message, args);
  }

  /// Logs a low-level debug information for troubleshooting.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - message           a human-readable message to log.
  /// - args              arguments to parameterize the message.
  void trace(String correlationId, String message, List args) {
    this._formatAndWrite(LogLevel.Trace, correlationId, null, message, args);
  }

  /// Composes an human-readable error description
  ///
  /// - error     an error to format.
  /// Return a human-reable error description.
  String composeError(ApplicationException error) {
    String builder = "";

    builder += error.message;

    var appError = error;
    if (appError.cause != null) {
      builder += " Caused by: ";
      builder += appError.cause;
    }

    if (error.stack_trace != null) {
      builder += " Stack trace: ";
      builder += error.stack_trace;
    }

    return builder;
  }
}
