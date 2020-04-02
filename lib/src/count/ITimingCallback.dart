/// Interface for a callback to end measurement of execution elapsed time.
///
/// See [Timing]

abstract class ITimingCallback {
  /// Ends measurement of execution elapsed time and updates specified counter.
  ///
  /// - [name]      a counter name
  /// - [elapsed]   execution elapsed time in milliseconds to update the counter.
  ///
  /// See [Timing.endTiming]

  void endTiming(String name, int elapsed);
}
