import '../../pip_services3_components.dart';

/// Callback object returned by {@link ICounters.beginTiming} to end timing
/// of execution block and update the associated counter.
///
/// ### Example ###
///
///     let timing = counters.beginTiming("mymethod.exec_time");
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
  Timing([String counter = null, ITimingCallback callback = null]) {
    this._counter = counter;
    this._callback = callback;
    this._start = new DateTime.now().millisecondsSinceEpoch;
  }

  /// Ends timing of an execution block, calculates elapsed time
  /// and updates the associated counter.
  void endTiming() {
    if (this._callback != null) {
      int elapsed = new DateTime.now().millisecondsSinceEpoch - this._start;
      this._callback.endTiming(this._counter, elapsed);
    }
  }
}
