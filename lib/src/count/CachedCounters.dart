import 'dart:math';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Abstract implementation of performance counters that measures and stores counters in memory.
/// Child classes implement saving of the counters into various destinations.
///
/// ### Configuration parameters ###
///
/// - [options]:
///     - [interval]:        interval in milliseconds to save current counters measurements
///     (default: 5 mins)
///     - [reset_timeout]:   timeout in milliseconds to reset the counters. 0 disables the reset
///     (default: 0)
abstract class CachedCounters
    implements ICounters, IReconfigurable, ITimingCallback {
  int _interval = 300000;
  int _resetTimeout = 0;
  final _cache = <String, Counter>{};
  bool _updated;
  int _lastDumpTime = DateTime.now().millisecondsSinceEpoch;
  int _lastResetTime = DateTime.now().millisecondsSinceEpoch;

  /// Creates a new CachedCounters object.
  CachedCounters();

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _interval = config.getAsLongWithDefault('interval', _interval);
    _interval = config.getAsLongWithDefault('options.interval', _interval);
    _resetTimeout = config.getAsLongWithDefault('reset_timeout', _resetTimeout);
    _resetTimeout =
        config.getAsLongWithDefault('options.reset_timeout', _resetTimeout);
  }

  /// Gets the counters dump/save interval.
  ///
  /// Return the interval in milliseconds.
  int getInterval() {
    return _interval;
  }

  /// Sets the counters dump/save interval.
  ///
  /// - [value]    a new interval in milliseconds.
  void setInterval(int value) {
    _interval = value;
  }

  /// Saves the current counters measurements.
  ///
  /// - [counters]      current counters measurements to be saves.
  void save(List<Counter> counters);

  /// Clears (resets) a counter specified by its name.
  ///
  /// - [name]  a counter name to clear.
  void clear(String name) {
    _cache.remove(name);
  }

  /// Clears (resets) all counters.
  void clearAll() {
    _cache.clear();
    _updated = false;
  }

  /// Begins measurement of execution time interval.
  /// It returns [Timing] object which has to be called at
  /// [Timing.endTiming] to end the measurement and update the counter.
  ///
  /// - [name] 	a counter name of Interval type.
  /// Return a [Timing] callback object to end timing.
  @override
  Timing beginTiming(String name) {
    return Timing(name, this);
  }

  /// Dumps (saves) the current values of counters.
  ///
  /// See [save]
  void dump() {
    if (!_updated) return;

    var counters = getAll();

    save(counters);

    _updated = false;
    _lastDumpTime = DateTime.now().millisecondsSinceEpoch;
  }

  /// Makes counter measurements as updated
  /// and dumps them when timeout expires.
  ///
  /// See [dump]
  void _update() {
    _updated = true;
    if (DateTime.now().millisecondsSinceEpoch > _lastDumpTime + getInterval()) {
      try {
        dump();
      } catch (ex) {
        // Todo: decide what to do
      }
    }
  }

  void _resetIfNeeded() {
    if (_resetTimeout == 0) return;

    var now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastResetTime > _resetTimeout) {
      _cache.clear();
      _updated = false;
      _lastResetTime = now;
    }
  }

  /// Gets all captured counters.
  ///
  /// Return a list with counters.
  List<Counter> getAll() {
    var result = <Counter>[];

    _resetIfNeeded();

    for (var key in _cache.keys) {
      result.add(_cache[key]);
    }

    return result;
  }

  /// Gets a counter specified by its name.
  /// It counter does not exist or its type doesn't match the specified type
  /// it creates a new one.
  ///
  /// - [name]  a counter name to retrieve.
  /// - [type]  a counter type.
  /// Return an existing or newly created counter of the specified type.
  Counter get(String name, CounterType type) {
    if (name == null || name == '') {
      throw Exception('Name cannot be null');
    }

    _resetIfNeeded();

    var counter = _cache[name];

    if (counter == null || counter.type != type) {
      counter = Counter(name, type);
      _cache[name] = counter;
    }

    return counter;
  }

  void _calculateStats(Counter counter, int value) {
    if (counter == null) {
      throw Exception('Counter cannot be null');
    }

    counter.last = value;
    counter.count = counter.count != null ? counter.count + 1 : 1;
    counter.max = counter.max != null ? max(counter.max, value) : value;
    counter.min = counter.min != null ? min(counter.min, value) : value;
    counter.average = (counter.average != null && counter.count > 1
        ? (counter.average * (counter.count - 1) + value) / counter.count
        : (value + 0.0));
  }

  /// Ends measurement of execution elapsed time and updates specified counter.
  ///
  /// - [name]      a counter name
  /// - [elapsed]   execution elapsed time in milliseconds to update the counter.
  ///
  /// See [Timing.endTiming]
  @override
  void endTiming(String name, int elapsed) {
    var counter = get(name, CounterType.Interval);
    _calculateStats(counter, elapsed);
    _update();
  }

  /// Calculates min/average/max statistics based on the current and previous values.
  ///
  /// - [name] 		a counter name of Statistics type
  /// - [value]		a value to update statistics
  @override
  void stats(String name, int value) {
    var counter = get(name, CounterType.Statistics);
    _calculateStats(counter, value);
    _update();
  }

  /// Records the last calculated measurement value.
  ///
  /// Usually this method is used by metrics calculated
  /// externally.
  ///
  /// - [name] 		a counter name of Last type.
  /// - [value]		a last value to record.
  @override
  void last(String name, int value) {
    var counter = get(name, CounterType.LastValue);
    counter.last = value;
    _update();
  }

  /// Records the current time as a timestamp.
  ///
  /// - [name] 		a counter name of Timestamp type.
  @override
  void timestampNow(String name) {
    timestamp(name, DateTime.now());
  }

  /// Records the given timestamp.
  ///
  /// - [name] 		a counter name of Timestamp type.
  /// - [value]		a timestamp to record.
  @override
  void timestamp(String name, DateTime value) {
    var counter = get(name, CounterType.Timestamp);
    counter.time = value;
    _update();
  }

  /// Increments counter by 1.
  ///
  /// - [name] 		a counter name of Increment type.
  @override
  void incrementOne(String name) {
    increment(name, 1);
  }

  /// Increments counter by given value.
  ///
  /// - name 		a counter name of Increment type.
  /// - value		a value to add to the counter.
  @override
  void increment(String name, int value) {
    var counter = get(name, CounterType.Increment);
    counter.count = counter.count != null ? counter.count + value : value;
    _update();
  }
}
