import '../../pip_services3_components.dart';

/// Data object to store measurement for a performance counter.
/// This object is used by [CachedCounters] to store counters.
// Todo: Make it JSON serializable
class Counter {
  /// The counter unique name
  String name;

  /// The counter type that defines measurement algorithm
  CounterType type;

  /// The last recorded value
  int? last;

  /// The total count
  int? count;

  /// The minimum value
  int? min;

  /// The maximum value
  int? max;

  /// The average value
  double? average;

  /// The recorded timestamp
  DateTime? time;

  /// Creates a instance of the data obejct
  ///
  /// - [name]      a counter name.
  /// - [type]      a counter type.
  Counter(String name, CounterType type)
      : name = name,
        type = type;

  factory Counter.fromJson(Map<String, dynamic> json) {
    var c = Counter(json['name'], json['type']);
    c.last = json['last'];
    c.count = json['count'];
    c.min = json['min'];
    c.max = json['max'];
    c.average = json['average'];
    c.time = json['time'];
    return c;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type,
      'last': last,
      'count': count,
      'min': min,
      'max': max,
      'average': average,
      'time': time
    };
  }

  void fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    last = json['last'];
    count = json['count'];
    min = json['min'];
    max = json['max'];
    average = json['average'];
    time = json['time'];
  }
}
