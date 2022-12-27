import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/src/trace/TraceTiming.dart';

import 'ITracer.dart';

/// Aggregates all tracers from component references under a single component.
///
/// It allows to record traces and conveniently send them to multiple destinations.
///
/// ### References ###
///
/// - \*:tracer:\*:\*:1.0     (optional) [ITracer] components to pass operation traces
///
/// See [ITracer]
///
/// ### Example ###
///
/// class MyComponent implements IReferenceable {
///     var _tracer = CompositeTracer();
///
///     void setReferences(IReferences references) {
///         _tracer.setReferences(references);
///         ...
///     }
///
///     void myMethod(String correlatonId) {
///         var timing = _tracer.beginTrace(correlationId, "mycomponent", "mymethod");
///         try {
///             ...
///             timing.endTrace();
///         } catch (err) {
///             timing.endFailure(err);
///         }
///     }
/// }
///
class CompositeTracer implements ITracer, IReferenceable {
  final List<ITracer> _tracers = [];

  /// Creates a new instance of the tracer.
  ///
  /// - [references] references to locate the component dependencies.
  CompositeTracer([IReferences? references]) {
    if (references != null) setReferences(references);
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
    for (var tracer in _tracers) {
      tracer.failure(correlationId, component, operation, error, duration);
    }
  }

  /// Sets references to dependent components.
  ///
  /// - [references] references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    var tracers = references
        .getOptional<ITracer>(Descriptor(null, 'tracer', null, null, null));
    for (var i = 0; i < tracers.length; i++) {
      var tracer = tracers[i];

      if (tracer != this) _tracers.add(tracer);
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
    for (var tracer in _tracers) {
      tracer.trace(correlationId, component, operation, duration);
    }
  }
}
