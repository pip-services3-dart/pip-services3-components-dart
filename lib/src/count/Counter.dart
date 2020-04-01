import '../../pip_services3_components.dart';

/// Data object to store measurement for a performance counter.
/// This object is used by [CachedCounters] to store counters.
class Counter {
  /// The counter unique name
  String name;

  /// The counter type that defines measurement algorithm
  CounterType type;

  /// The last recorded value
  int last;

  /// The total count
  int count;

  /// The minimum value
  int min;

  /// The maximum value
  int max;

  /// The average value
  double average;

  /// The recorded timestamp
  DateTime time;

  /// Creates a instance of the data obejct
  ///
  /// - name      a counter name.
  /// - type      a counter type.
  Counter(String name, CounterType type) {
    this.name = name;
    this.type = type;
  }
}
