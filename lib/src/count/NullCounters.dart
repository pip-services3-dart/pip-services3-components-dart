import '../../pip_services3_components.dart';

/// Dummy implementation of performance counters that doesn't do anything.
///
/// It can be used in testing or in situations when counters is required
/// but shall be disabled.
///
/// See [ICounters]

class NullCounters implements ICounters {
  /// Creates a new instance of the counter.
  NullCounters();

  /// Begins measurement of execution time interval.
  /// It returns [Timing] object which has to be called at
  /// [Timing.endTiming] to end the measurement and update the counter.
  ///
  /// - [name] 	a counter name of Interval type.
  /// Return a [Timing] callback object to end timing.
  @override
  Timing beginTiming(String name) {
    return Timing();
  }

  /// Calculates min/average/max statistics based on the current and previous values.
  ///
  /// - [name] 		a counter name of Statistics type
  /// - [value]		a value to update statistics
  @override
  void stats(String name, int value) {}

  /// Records the last calculated measurement value.
  ///
  /// Usually this method is used by metrics calculated
  /// externally.
  ///
  /// - [name] 		a counter name of Last type.
  /// - [value]		a last value to record.
  @override
  void last(String name, int value) {}

  /// Records the current time as a timestamp.
  ///
  /// - [name] 		a counter name of Timestamp type.
  @override
  void timestampNow(String name) {}

  /// Records the given timestamp.
  ///
  /// - [name] 		a counter name of Timestamp type.
  /// - [value]		a timestamp to record.
  @override
  void timestamp(String name, DateTime value) {}

  /// Increments counter by 1.
  ///
  /// - [name] 		a counter name of Increment type.
  @override
  void incrementOne(String name) {}

  /// Increments counter by given value.
  ///
  /// - [name] 		a counter name of Increment type.
  /// - [value]		a value to add to the counter.
  @override
  void increment(String name, int value) {}
}
