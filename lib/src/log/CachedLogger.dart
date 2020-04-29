import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Abstract logger that caches captured log messages in memory and periodically dumps them.
/// Child classes implement saving cached messages to their specified destinations.
///
/// ### Configuration parameters ###
///
/// - [level]:             maximum log level to capture
/// - [source]:            source (context) name
/// - [options]:
///     - [interval]:        interval in milliseconds to save log messages (default: 10 seconds)
///     - [max_cache_size]:  maximum number of messages stored in this cache (default: 100)
///
/// ### References ###
///
/// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
///
/// See [ILogger]
/// See [Logger]
/// See [LogMessage]

abstract class CachedLogger extends Logger {
  List<LogMessage> cache = <LogMessage>[];
  bool updated = false;
  int lastDumpTime = DateTime.now().millisecondsSinceEpoch;
  int maxCacheSize = 100;
  int interval = 10000;

  /// Creates a new instance of the logger.
  CachedLogger() : super();

  /// Writes a log message to the logger destination.
  ///
  /// - [level]             a log level.
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [error]             an error object associated with this message.
  /// - [message]           a human-readable message to log.
  @override
  void write(
      LogLevel level, String correlationId, Exception error, String message) {
    var errorDesc =
        error != null ? ErrorDescriptionFactory.create(error) : null;
    var logMessage = LogMessage();
    logMessage.time = DateTime.now();
    logMessage.level = LogLevelConverter.toString2(level);
    logMessage.source = source;
    logMessage.correlation_id = correlationId;
    logMessage.error = errorDesc;
    logMessage.message = message;

    cache.add(logMessage);
    update();
  }

  /// Saves log messages from the cache.
  ///
  /// - [messages]  a list with log messages
  /// Retruns     Future that receives null for success.
  /// Throws error
  Future save(List<LogMessage> messages);

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    super.configure(config);

    interval = config.getAsLongWithDefault('options.interval', interval);
    maxCacheSize =
        config.getAsIntegerWithDefault('options.max_cache_size', maxCacheSize);
  }

  /// Clears (removes) all cached log messages.
  void clear() {
    cache = [];
    updated = false;
  }

  /// Dumps (writes) the currently cached log messages.
  ///
  /// See [write]
  void dump() async {
    if (updated) {
      if (!updated) return;

      var messages = cache;
      cache = [];
      try {
        await save(messages);
      } catch (err) {
        // Adds messages back to the cache
        messages.addAll(cache);
        cache = messages;

        // Truncate cache
        var deleteCount = cache.length - maxCacheSize;
        if (deleteCount > 0) cache.removeRange(0, deleteCount);
      }

      updated = false;
      lastDumpTime = DateTime.now().millisecondsSinceEpoch;
    }
  }

  /// Makes message cache as updated
  /// and dumps it when timeout expires.
  ///
  /// See [dump]
  void update() {
    updated = true;
    var now = DateTime.now().millisecondsSinceEpoch;

    if (now > lastDumpTime + interval) {
      try {
        dump();
      } catch (ex) {
        // TODO: decide what to do
      }
    }
  }
}
