
import 'package:pip_services3_commons/src/config/IReconfigurable.dart';
import 'package:pip_services3_commons/src/config/ConfigParams.dart';

import './ICounters.dart';
import  './Timing.dart';
import './ITimingCallback.dart';
import './CounterType.dart';
import './Counter.dart';

import "dart:math";


/// Abstract implementation of performance counters that measures and stores counters in memory.
/// Child classes implement saving of the counters into various destinations.
/// 
/// ### Configuration parameters ###
/// 
/// - options:
///     - interval:        interval in milliseconds to save current counters measurements 
///     (default: 5 mins)
///     - reset_timeout:   timeout in milliseconds to reset the counters. 0 disables the reset 
///     (default: 0)
 
abstract class CachedCounters implements ICounters, IReconfigurable, ITimingCallback {
    int _interval = 300000;
    int _resetTimeout = 0;
    Map<String, Counter>_cache = Map<String, Counter>();
    bool _updated;
    int _lastDumpTime = new DateTime.now().millisecondsSinceEpoch;
    int _lastResetTime = new DateTime.now().millisecondsSinceEpoch;

    
    /// Creates a new CachedCounters object.
    CachedCounters() { }

    
    /// Configures component by passing configuration parameters.
    /// 
    /// - config    configuration parameters to be set.
     
    void configure(ConfigParams config) {
        this._interval = config.getAsLongWithDefault("interval", this._interval);
        this._interval = config.getAsLongWithDefault("options.interval", this._interval);
        this._resetTimeout = config.getAsLongWithDefault("reset_timeout", this._resetTimeout);
        this._resetTimeout = config.getAsLongWithDefault("options.reset_timeout", this._resetTimeout);
    }

    
    /// Gets the counters dump/save interval.
    /// 
    /// Return the interval in milliseconds.
     
    int getInterval() {
        return this._interval;
    }

    
    /// Sets the counters dump/save interval.
    /// 
    /// - value    a new interval in milliseconds.
     
    void setInterval(int value) {
        this._interval = value;
    }
    
    /// Saves the current counters measurements.
    /// 
    /// - counters      current counters measurements to be saves.
    void _save(List<Counter> counters);

    /// Clears (resets) a counter specified by its name.
    /// 
    /// - name  a counter name to clear.
    void clear(String name) {
        this._cache.remove(name);
    }

    /// Clears (resets) all counters. 
    void clearAll() {
        this._cache = {};
        this._updated = false;
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

    
    /// Dumps (saves) the current values of counters.
    /// 
    /// See [save]
    void dump() {
        if (!this._updated) return;

        var counters = this.getAll();

        this._save(counters);

        this._updated = false;
        this._lastDumpTime = new DateTime.now().millisecondsSinceEpoch;
    }

    
    /// Makes counter measurements as updated
    /// and dumps them when timeout expires.
    /// 
    /// See [dump]
     
    void _update() {
        this._updated = true;
        if (new DateTime.now().millisecondsSinceEpoch > this._lastDumpTime + this.getInterval()) {
            try {
                this.dump();
            } catch (ex) {
                // Todo: decide what to do
            }
        }
    }

    void _resetIfNeeded() {
        if (this._resetTimeout == 0) return;

        var now = new DateTime.now().millisecondsSinceEpoch;
        if (now - this._lastResetTime > this._resetTimeout) {
            this._cache = {};
            this._updated = false;
            this._lastResetTime = now;
        }
    }

    
    /// Gets all captured counters.
    /// 
    /// Return a list with counters.
    List<Counter> getAll() {
        var result = List<Counter>();

        this._resetIfNeeded();

        for (var key in this._cache.keys)
            result.add(this._cache[key]);

        return result;
    }

    
    /// Gets a counter specified by its name.
    /// It counter does not exist or its type doesn't match the specified type
    /// it creates a new one.
    /// 
    /// - name  a counter name to retrieve.
    /// - type  a counter type.
    /// Return an existing or newly created counter of the specified type.
     
    Counter get(String name, CounterType type) {
        if (name == null || name == "")
            throw "Name cannot be null";

        this._resetIfNeeded();

        Counter counter = this._cache[name];

        if (counter == null || counter.type != type) {
            counter = new Counter(name, type);
            this._cache[name] = counter;
        }

        return counter;
    }

    void _calculateStats(Counter counter, int value) {
        if (counter == null)
            throw "Counter cannot be null";

        counter.last = value;
        counter.count = counter.count != null ? counter.count + 1 : 1;
        counter.max = counter.max != null ? max(counter.max, value) : value;
        counter.min = counter.min != null ? min(counter.min, value) : value;
        counter.average = (counter.average != null && counter.count > 1
            ? (counter.average * (counter.count - 1) + value) / counter.count : value);
    }

    
    /// Ends measurement of execution elapsed time and updates specified counter.
    /// 
    /// - name      a counter name
    /// - elapsed   execution elapsed time in milliseconds to update the counter.
    /// 
    /// See [Timing.endTiming]
    void endTiming(String name, int elapsed) {
        Counter counter = this.get(name, CounterType.Interval);
        this._calculateStats(counter, elapsed);
        this._update();
    }

    
	/// Calculates min/average/max statistics based on the current and previous values.
	/// 
	/// - name 		a counter name of Statistics type
	/// - value		a value to update statistics
    void stats(String name, int value) {
        Counter counter = this.get(name, CounterType.Statistics);
        this._calculateStats(counter, value);
        this._update();
    }

    
	/// Records the last calculated measurement value.
	/// 
	/// Usually this method is used by metrics calculated
	/// externally.
	/// 
	/// - name 		a counter name of Last type.
	/// - value		a last value to record.
	 
    void last(String name, int value) {
        Counter counter = this.get(name, CounterType.LastValue);
        counter.last = value;
        this._update();
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
        Counter counter = this.get(name, CounterType.Timestamp);
        counter.time = value;
        this._update();
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
        Counter counter = this.get(name, CounterType.Increment);
        counter.count = counter.count != 0 ? counter.count + value : value;
        this._update();
    }

}