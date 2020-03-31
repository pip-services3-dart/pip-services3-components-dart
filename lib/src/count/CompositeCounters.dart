import 'package:pip_services3_commons/src/refer/IReferenceable.dart';
import 'package:pip_services3_commons/src/refer/IReferences.dart';
import 'package:pip_services3_commons/src/refer/Descriptor.dart';

import './ICounters.dart';
import './Timing.dart';
import './ITimingCallback.dart';

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
///         private _counters: CompositeCounters = new CompositeCounters();
///
///         public setReferences(references: IReferences): void {
///             this._counters.setReferences(references);
///             ...
///         }
///
///         public myMethod(): void {
///             this._counters.increment("mycomponent.mymethod.calls");
///             var timing = this._counters.beginTiming("mycomponent.mymethod.exec_time");
///             try {
///                 ...
///             } finally {
///                 timing.endTiming();
///             }
///         }
///     }
///

class CompositeCounters implements ICounters, ITimingCallback, IReferenceable {
  final List<ICounters> _counters = List<ICounters>();

  /// Creates a new instance of the counters.
  ///
  /// - references 	references to locate the component dependencies.
  CompositeCounters([IReferences references = null]) {
    if (references != null) this.setReferences(references);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  void setReferences(IReferences references) {
    var counters = references.getOptional<ICounters>(
        new Descriptor(null, "counters", null, null, null));
    for (var i = 0; i < counters.length; i++) {
      ICounters counter = counters[i];

      if (counter != this as ICounters) this._counters.add(counter);
    }
  }

  /// Begins measurement of execution time interval.
  /// It returns [Timing] object which has to be called at
  /// [Timing.endTiming] to end the measurement and update the counter.
  ///
  /// - name 	a counter name of Interval type.
  /// Return a [Timing] callback object to end timing.
  Timing beginTiming(String name) {
    return new Timing(name, this);
  }

  /// Ends measurement of execution elapsed time and updates specified counter.
  ///
  /// - name      a counter name
  /// - elapsed   execution elapsed time in milliseconds to update the counter.
  ///
  /// See [Timing.endTiming]
  void endTiming(String name, int elapsed) {
    for (var i = 0; i < this._counters.length; i++) {
      var counter = this._counters[i];
      var callback = counter as ITimingCallback;
      if (callback != null) callback.endTiming(name, elapsed);
    }
  }

  /// Calculates min/average/max statistics based on the current and previous values.
  ///
  /// - name 		a counter name of Statistics type
  /// - value		a value to update statistics
  void stats(String name, int value) {
    for (var i = 0; i < this._counters.length; i++)
      this._counters[i].stats(name, value);
  }

  /// Records the last calculated measurement value.
  ///
  /// Usually this method is used by metrics calculated
  /// externally.
  ///
  /// - name 		a counter name of Last type.
  /// - value		a last value to record.
  void last(String name, int value) {
    for (var i = 0; i < this._counters.length; i++)
      this._counters[i].last(name, value);
  }

  /// Records the current time as a timestamp.
  ///
  /// - name 		a counter name of Timestamp type.
  void timestampNow(String name) {
    this.timestamp(name, new DateTime.now());
  }

  /// Records the given timestamp.
  ///
  /// - name 		a counter name of Timestamp type.
  /// - value		a timestamp to record.
  void timestamp(String name, DateTime value) {
    for (var i = 0; i < this._counters.length; i++)
      this._counters[i].timestamp(name, value);
  }

  /// Increments counter by 1.
  ///
  /// - name 		a counter name of Increment type.
  void incrementOne(String name) {
    this.increment(name, 1);
  }

  /// Increments counter by given value.
  ///
  /// - name 		a counter name of Increment type.
  /// - value		a value to add to the counter.
  void increment(String name, int value) {
    if (name == null || name == "") throw "Name cannot be null";
    for (var i = 0; i < this._counters.length; i++)
      this._counters[i].increment(name, value);
  }
}
