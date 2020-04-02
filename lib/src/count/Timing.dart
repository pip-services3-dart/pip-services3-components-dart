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
class Timing {
  int _start;
  ITimingCallback _callback;
  String _counter;

  /// Creates a new instance of the timing callback object.
  ///
  /// - counter 		an associated counter name
  /// - callback 		a callback that shall be called when endTiming is called.
  Timing([String counter, ITimingCallback callback]) {
    _counter = counter;
    _callback = callback;
    _start = DateTime.now().millisecondsSinceEpoch;
  }

  /// Ends timing of an execution block, calculates elapsed time
  /// and updates the associated counter.
  void endTiming() {
    if (_callback != null) {
      var elapsed = DateTime.now().millisecondsSinceEpoch - _start;
      _callback.endTiming(_counter, elapsed);
    }
  }
}
