import "package:pip_services3_commons/pip_services3_commons.dart";

import '../../pip_services3_components.dart';

/// Performance counters that periodically dumps counters measurements to logger.
///
/// ### Configuration parameters ###
///
/// - __options:__
///     - interval:          interval in milliseconds to save current counters measurements (default: 5 mins)
///     - reset_timeout:     timeout in milliseconds to reset the counters. 0 disables the reset (default: 0)
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0           [ILogger] components to dump the captured counters
/// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
///
/// See [Counter]
/// See [CachedCounters]
/// See [CompositeLogger]
///
/// ### Example ###
///
///     let counters = new LogCounters();
///     counters.setReferences(References.fromTuples(
///         new Descriptor("pip-services", "logger", "console", "default", "1.0"), new ConsoleLogger()
///     ));
///
///     counters.increment("mycomponent.mymethod.calls");
///     let timing = counters.beginTiming("mycomponent.mymethod.exec_time");
///     try {
///         ...
///     } finally {
///         timing.endTiming();
///     }
///
///     counters.dump();

class LogCounters extends CachedCounters implements IReferenceable {
  final CompositeLogger _logger = CompositeLogger();

  /// Creates a new instance of the counters.
  LogCounters() {}

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  ///
  void setReferences(IReferences references) {
    this._logger.setReferences(references);
  }

  String _counterToString(Counter counter) {
    var result = "Counter " + counter.name + " { ";
    result += "\"type\": " + counter.type.toString();
    if (counter.last != null)
      result += ", \"last\": " + StringConverter.toString2(counter.last);
    if (counter.count != null)
      result += ", \"count\": " + StringConverter.toString2(counter.count);
    if (counter.min != null)
      result += ", \"min\": " + StringConverter.toString2(counter.min);
    if (counter.max != null)
      result += ", \"max\": " + StringConverter.toString2(counter.max);
    if (counter.average != null)
      result += ", \"avg\": " + StringConverter.toString2(counter.average);
    if (counter.time != null)
      result += ", \"time\": " + StringConverter.toString2(counter.time);
    result += " }";
    return result;
  }

  /// Saves the current counters measurements.
  ///
  /// - counters      current counters measurements to be saves.
  @override
  void save(List<Counter> counters) {
    if (this._logger == null || counters == null) return;

    if (counters.length == 0) return;

    counters.sort((c1, c2) {
      if (c1.name.compareTo(c2.name) < 0) return -1;
      if (c1.name.compareTo(c2.name) > 0) return 1;
      return 0;
    });

    for (var i = 0; i < counters.length; i++) {
      this._logger.info(null, this._counterToString(counters[i]), []);
    }
  }
}
