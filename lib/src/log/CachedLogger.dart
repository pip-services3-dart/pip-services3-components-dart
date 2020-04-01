import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Abstract logger that caches captured log messages in memory and periodically dumps them.
/// Child classes implement saving cached messages to their specified destinations.
///
/// ### Configuration parameters ###
///
/// - level:             maximum log level to capture
/// - source:            source (context) name
/// - options:
///     - interval:        interval in milliseconds to save log messages (default: 10 seconds)
///     - max_cache_size:  maximum number of messages stored in this cache (default: 100)
///
/// ### References ###
///
/// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
///
/// See [ILogger]
/// See [Logger]
/// See [LogMessage]

abstract class CachedLogger extends Logger {
  List<LogMessage> _cache = List<LogMessage>();
  bool _updated = false;
  int _lastDumpTime = new DateTime.now().millisecondsSinceEpoch;
  int _maxCacheSize = 100;
  int _interval = 10000;

  /// Creates a new instance of the logger.
  CachedLogger() : super() {}

  /// Writes a log message to the logger destination.
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  void _write(LogLevel level, String correlationId, ApplicationException error,
      String message) {
    ErrorDescription errorDesc =
        error != null ? ErrorDescriptionFactory.create(error) : null;
    LogMessage logMessage = LogMessage();
    logMessage.time = new DateTime.now();
    logMessage.level = LogLevelConverter.toString2(level);
    logMessage.source = this.source;
    logMessage.correlation_id = correlationId;
    logMessage.error = errorDesc;
    logMessage.message = message;

    this._cache.add(logMessage);

    this._update();
  }

  /// Saves log messages from the cache.
  ///
  /// - messages  a list with log messages
  /// - callback  callback function that receives error or null for success.
  void _save(List<LogMessage> messages, callback(err));

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    super.configure(config);

    this._interval =
        config.getAsLongWithDefault("options.interval", this._interval);
    this._maxCacheSize = config.getAsIntegerWithDefault(
        "options.max_cache_size", this._maxCacheSize);
  }

  /// Clears (removes) all cached log messages.
  void clear() {
    this._cache = [];
    this._updated = false;
  }

  /// Dumps (writes) the currently cached log messages.
  ///
  /// See [write]
  void dump() {
    if (this._updated) {
      if (!this._updated) return;

      var messages = this._cache;
      this._cache = [];

      this._save(messages, (err) {
        if (err) {
          // Adds messages back to the cache
          messages.addAll(this._cache);
          this._cache = messages;

          // Truncate cache
          var deleteCount = this._cache.length - this._maxCacheSize;
          if (deleteCount > 0) this._cache.removeRange(0, deleteCount);
        }
      });

      this._updated = false;
      this._lastDumpTime = new DateTime.now().millisecondsSinceEpoch;
    }
  }

  /// Makes message cache as updated
  /// and dumps it when timeout expires.
  ///
  /// See [dump]

  void _update() {
    this._updated = true;
    var now = new DateTime.now().millisecondsSinceEpoch;

    if (now > this._lastDumpTime + this._interval) {
      try {
        this.dump();
      } catch (ex) {
        // Todo: decide what to do
      }
    }
  }
}
