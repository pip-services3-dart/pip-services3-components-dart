import '../../pip_services3_components.dart';

/// Interface for performance counters that measure execution metrics.
///
/// The performance counters measure how code is performing:
/// how fast or slow, how many transactions performed, how many objects
/// are stored, what was the latest transaction time and so on.
///
/// They are critical to monitor and improve performance, scalability
/// and reliability of code in production.

abstract class ICounters {
  /// Begins measurement of execution time interval.
  /// It returns [CounterTiming] object which has to be called at
  /// [CounterTiming.endTiming] to end the measurement and update the counter.
  ///
  /// - [name] 	a counter name of Interval type.
  /// Return a [CounterTiming] callback object to end timing.
  CounterTiming beginTiming(String name);

  /// Calculates min/average/max statistics based on the current and previous values.
  ///
  /// - [name] 		a counter name of Statistics type
  /// - [value]		a value to update statistics
  void stats(String name, int value);

  /// Records the last calculated measurement value.
  ///
  /// Usually this method is used by metrics calculated
  /// externally.
  ///
  /// - [name] 		a counter name of Last type.
  /// - [value]		a last value to record.
  void last(String name, int value);

  /// Records the current time as a timestamp.
  ///
  /// - [name] 		a counter name of Timestamp type.
  void timestampNow(String name);

  /// Records the given timestamp.
  ///
  /// - [name] 		a counter name of Timestamp type.
  /// - [value]		a timestamp to record.
  void timestamp(String name, DateTime value);

  /// Increments counter by 1.
  ///
  /// - [name] 		a counter name of Increment type.
  void incrementOne(String name);

  /// Increments counter by given value.
  ///
  /// - [name] 		a counter name of Increment type.
  /// - [value]		a value to add to the counter.
  void increment(String name, int value);
}
