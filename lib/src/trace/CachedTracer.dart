import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/src/info/ContextInfo.dart';

import 'ITracer.dart';
import 'OperationTrace.dart';
import 'TraceTiming.dart';

/// Abstract tracer that caches recorded traces in memory and periodically dumps them.
/// Child classes implement saving cached traces to their specified destinations.
///
/// ### Configuration parameters ###
///
/// - source:            source (context) name
/// - options:
///     - interval:        interval in milliseconds to save log messages (default: 10 seconds)
///     - max_cache_size:  maximum number of messages stored in this cache (default: 100)
///
/// ### References ###
///
/// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
///
abstract class CachedTracer
    implements ITracer, IReconfigurable, IReferenceable {
  String? _source;
  List<OperationTrace> _cache = [];
  bool _updated = false;
  int _lastDumpTime = DateTime.now().millisecondsSinceEpoch;
  int _maxCacheSize = 100;
  int _interval = 10000;

  /// Creates a new instance of the logger.
  CachedTracer();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _interval = config.getAsLongWithDefault('options.interval', _interval);
    _maxCacheSize =
        config.getAsIntegerWithDefault('options.max_cache_size', _maxCacheSize);
    _source = config.getAsNullableString('source') ?? _source;
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    var contextInfo = references.getOneOptional<ContextInfo>(
        Descriptor('pip-services', 'context-info', '*', '*', '1.0'));
    if (contextInfo != null && _source == null) {
      _source = contextInfo.name;
    }
  }

  /// Writes a log message to the logger destination.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [error] an error object associated with this trace.
  /// - [duration] execution duration in milliseconds.
  void write(String? correlationId, String? component, String? operation,
      Exception? error, int duration) {
    var errorDesc =
        error != null ? ErrorDescriptionFactory.create(error) : null;

    /// Account for cases when component and operation are combined in component.
    if (operation == null || operation == '') {
      if (component != null && component != '') {
        var pos = component.lastIndexOf('.');
        if (pos > 0) {
          operation = component.substring(pos + 1);
          component = component.substring(0, pos);
        }
      }
    }

    var trace = OperationTrace(DateTime.now(), _source, component, operation,
        correlationId, duration, errorDesc);

    _cache.add(trace);
    update();
  }

  /// Records an operation trace with its name and duration
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [duration] execution duration in milliseconds.
  @override
  void trace(
      String? correlationId, String component, String operation, int duration) {
    write(correlationId, component, operation, null, duration);
  }

  /// Records an operation failure with its name, duration and error
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [error] an error object associated with this trace.
  /// - [duration] execution duration in milliseconds.
  @override
  void failure(String? correlationId, String component, String operation,
      Exception error, int duration) {
    write(correlationId, component, operation, error, duration);
  }

  /// Begings recording an operation trace
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  @override
  TraceTiming beginTrace(
      String? correlationId, String component, String operation) {
    return TraceTiming(correlationId, component, operation, this);
  }

  /// Saves log messages from the cache.
  ///
  /// - [messages]  a list with log messages
  /// - [callback]  callback function that receives error or null for success.
  void save(
      List<OperationTrace> messages, void Function(Exception? err) callback);

  /// Clears (removes) all cached log messages.
  void clear() {
    _cache = [];
    _updated = false;
  }

  ///
  /// Dumps (writes) the currently cached log messages.
  ///
  /// See [write]
  void dump() {
    if (_updated) {
      if (!_updated) return;

      var traces = _cache;
      _cache = [];

      save(traces, (err) {
        if (err != null) {
          // Adds traces back to the cache
          traces.addAll(_cache);
          _cache = traces;

          // Truncate cache
          var deleteCount = _cache.length - _maxCacheSize;
          if (deleteCount > 0) _cache = _cache.sublist(0, deleteCount);
        }
      });

      _updated = false;
      _lastDumpTime = DateTime.now().microsecondsSinceEpoch;
    }
  }

  /// Makes trace cache as updated
  /// and dumps it when timeout expires.
  ///
  /// See [dump]
  void update() {
    _updated = true;
    var now = DateTime.now().millisecondsSinceEpoch;

    if (now > _lastDumpTime + _interval) {
      try {
        dump();
      } catch (ex) {
        // Todo: decide what to do
      }
    }
  }
}
