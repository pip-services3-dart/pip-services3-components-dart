import 'package:pip_services3_components/src/trace/ITracer.dart';

/// Timing object returned by [ITracer.beginTrace] to end timing
/// of execution block and record the associated trace.
///
/// ### Example ###
///   var timing = tracer.beginTrace("mymethod.exec_time");
///   try {
///       ...
///       timing.endTrace();
///   } catch (err) {
///       timing.endFailure(err);
///   }
///
class TraceTiming {
  final int _start;
  final ITracer? _tracer;
  final String? _correlationId;
  final String _component;
  final String _operation;

  /// Creates a new instance of the timing tracer object.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [component] an associated component name
  /// - [operation] an associated operation name
  /// - [tracer] a tracer that shall be called when endTiming is called.
  TraceTiming(String? correlationId, String component, String operation,
      ITracer? tracer)
      : _correlationId = correlationId,
        _component = component,
        _operation = operation,
        _tracer = tracer,
        _start = DateTime.now().millisecondsSinceEpoch;

  /// Ends timing of an execution block, calculates elapsed time
  /// and records the associated trace.
  void endTrace() {
    if (_tracer != null) {
      var elapsed = DateTime.now().microsecond - _start;
      _tracer!.trace(_correlationId, _component, _operation, elapsed);
    }
  }

  /// Ends timing of a failed block, calculates elapsed time
  /// and records the associated trace.
  ///
  /// - [error] an error object associated with this trace.
  ///
  void endFailure(Exception error) {
    if (_tracer != null) {
      var elapsed = DateTime.now().microsecond - _start;
      _tracer!.failure(_correlationId, _component, _operation, error, elapsed);
    }
  }
}
