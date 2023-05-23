import 'TraceTiming.dart';

///
/// Interface for tracer components that capture operation traces.
///
abstract class ITracer {
  /// Records an operation trace with its name and duration
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [duration] execution duration in milliseconds.
  void trace(
      String? correlationId, String component, String operation, int duration);

  /// Records an operation failure with its name, duration and error
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  /// - [error] an error object associated with this trace.
  /// - [duration] execution duration in milliseconds.
  void failure(String? correlationId, String component, String operation,
      Exception error, int duration);

  /// Begings recording an operation trace
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] a name of called component
  /// - [operation] a name of the executed operation.
  ///
  TraceTiming beginTrace(
      String? correlationId, String component, String operation);
}
