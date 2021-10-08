import '../../pip_services3_components.dart';

/// Callback object returned by {@link ICounters.beginTiming} to end timing
/// of execution block and update the associated counter.
///
/// ### Example ###
///
///     var timing = counters.beginTiming("mymethod.exec_time");
///     try {
///         ...
///     } finally {
///         timing.endTiming();
///     }
class CounterTiming {
  final int _start;
  ICounterTimingCallback? _callback;
  String? _counter;

  /// Creates a new instance of the timing callback object.
  ///
  /// - counter 		an associated counter name
  /// - callback 		a callback that shall be called when endTiming is called.
  CounterTiming([String? counter, ICounterTimingCallback? callback])
      : _start = DateTime.now().toUtc().millisecondsSinceEpoch {
    _counter = counter;
    _callback = callback;
  }

  /// Ends timing of an execution block, calculates elapsed time
  /// and updates the associated counter.
  void endTiming() {
    if (_callback != null) {
      var elapsed = DateTime.now().toUtc().millisecondsSinceEpoch - _start;
      _callback!.endTiming(_counter, elapsed);
    }
  }
}
