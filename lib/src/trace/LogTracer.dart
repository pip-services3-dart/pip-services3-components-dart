import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/src/log/log.dart';
import 'package:pip_services3_components/src/trace/ITracer.dart';
import 'package:pip_services3_components/src/trace/TraceTiming.dart';

class LogTracer implements IConfigurable, IReferenceable, ITracer {
  final _logger = CompositeLogger();
  var _logLevel = LogLevel.Debug;

  /// Creates a new instance of the tracer.
  LogTracer();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config] configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _logLevel = LogLevelConverter.toLogLevel(
        config.getAsObject('options.log_level'), _logLevel);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _logger.setReferences(references);
  }

  void _logTrace(String? correlationId, String component, String? operation,
      Exception? error, int duration) {
    var builder = '';

    if (error != null) {
      builder += 'Failed to execute ';
    } else {
      builder += 'Executed ';
    }

    builder += component;

    if (operation != null || operation != '') {
      builder += '.';
      builder += operation!;
    }

    if (duration > 0) {
      builder += ' in ' + duration.toString() + ' msec';
    }

    if (error != null) {
      _logger.error(correlationId, error, builder);
    } else {
      _logger.log(_logLevel, correlationId, null, builder);
    }
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
    _logTrace(correlationId, component, operation, null, duration);
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
    _logTrace(correlationId, component, operation, error, duration);
  }

  /// Begings recording an operation trace
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  ///
  @override
  TraceTiming beginTrace(
      String? correlationId, String component, String operation) {
    return TraceTiming(correlationId, component, operation, this);
  }
}
