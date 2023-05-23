import 'ITracer.dart';
import 'TraceTiming.dart';

class NullTracer implements ITracer {
  /// Records an operation trace with its name and duration
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [duration] execution duration in milliseconds.
  @override
  void trace(
      String? correlationId, String component, String operation, int duration) {
    // Do nothing...
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
    // Do nothing...
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
