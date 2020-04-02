import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../pip_services3_components.dart';

/// Aggregates all counters from component references under a single component.
///
/// It allows to capture metrics and conveniently send them to multiple destinations.
///
/// ### References ###
///
/// - \*:counters:\*:\*:1.0     (optional) [ICounters] components to pass collected measurements
///
/// See [ICounters]
///
/// ### Example ###
///
///     class MyComponent implements IReferenceable {
///         var _counters = new CompositeCounters();
///
///          void setReferences(IReferences references) {
///             _counters.setReferences(references);
///             ...
///         }
///
///         void myMethod() {
///            _counters.increment('mycomponent.mymethod.calls');
///             var timing =_counters.beginTiming('mycomponent.mymethod.exec_time');
///             try {
///                 ...
///             } finally {
///                 timing.endTiming();
///             }
///         }
///     }
///

class CompositeCounters implements ICounters, ITimingCallback, IReferenceable {
  final _counters = List<ICounters>();

  /// Creates a new instance of the counters.
  ///
  /// - [references] 	references to locate the component dependencies.
  CompositeCounters([IReferences references]) {
    if (references != null) {
      setReferences(references);
    }
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    var counters = references.getOptional<ICounters>(
        Descriptor(null, 'counters', null, null, null));
    for (var i = 0; i < counters.length; i++) {
      var counter = counters[i];

      if (counter != this) { // as ICounters
        _counters.add(counter);
      }
    }
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

  /// Ends measurement of execution elapsed time and updates specified counter.
  ///
  /// - [name]      a counter name
  /// - [elapsed]   execution elapsed time in milliseconds to update the counter.
  ///
  /// See [Timing.endTiming]
  @override
  void endTiming(String name, int elapsed) {
    for (var i = 0; i <_counters.length; i++) {
      var counter =_counters[i];
      var callback = counter as ITimingCallback;
      if (callback != null) {
        callback.endTiming(name, elapsed);
      }
    }
  }

  /// Calculates min/average/max statistics based on the current and previous values.
  ///
  /// - [name] 		a counter name of Statistics type
  /// - [value]		a value to update statistics
  @override
  void stats(String name, int value) {
    for (var i = 0; i <_counters.length; i++) {
      _counters[i].stats(name, value);
    }
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
    for (var i = 0; i <_counters.length; i++) {
      _counters[i].last(name, value);
    }
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
    for (var i = 0; i <_counters.length; i++) {
      _counters[i].timestamp(name, value);
    }
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
  /// - [name] 		a counter name of Increment type.
  /// - [value]		a value to add to the counter.
  @override
  void increment(String name, int value) {
    if (name == null || name == '') {
      throw Exception('Name cannot be null');
    }
    for (var i = 0; i <_counters.length; i++) {
      _counters[i].increment(name, value);
    }
  }
}
