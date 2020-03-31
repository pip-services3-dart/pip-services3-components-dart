/// Standard log levels.
///
/// Logs at debug and trace levels are usually captured
/// only locally for troubleshooting
/// and never sent to consolidated log services.

enum LogLevel {
  /// Nothing to log
  None,

  /// Log only fatal errors that cause processes to crash
  Fatal,

  /// Log all errors.
  Error,

  /// Log errors and warnings
  Warn,

  /// Log errors and important information messages
  Info,

  /// Log everything except traces
  Debug,

  /// Log everything.
  Trace
}
