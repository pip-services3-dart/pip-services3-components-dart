/// Types of counters that measure different types of metrics

enum CounterType {
  /// Counters that measure execution time intervals
  Interval,

  /// Counters that keeps the latest measured value
  LastValue,

  /// Counters that measure min/average/max statistics
  Statistics,

  /// Counter that record timestamps
  Timestamp,

  /// Counter that increment counters
  Increment
}
