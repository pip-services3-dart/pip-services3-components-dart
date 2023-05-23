/// Data object to store state values with their keys used by [MemoryStateStore]
class StateEntry {
  String _key;
  dynamic _value;
  int _lastUpdateTime;

  /// Creates a new instance of the state entry and assigns its values.
  ///
  /// - [key] a unique key to locate the value.
  /// - [value] a value to be stored.
  StateEntry(String key, value)
      : _key = key,
        _value = value,
        _lastUpdateTime = DateTime.now().millisecondsSinceEpoch;

  /// Gets the key to locate the state value.
  ///
  /// Returns the value key.
  String getKey() => _key;

  /// Gets the sstate value.
  ///
  /// Returns the value object.
  dynamic getValue() => _value;

  /// Gets the last update time.
  ///
  /// Returns the timestamp when the value ware stored.
  int getLastUpdateTime() => _lastUpdateTime;

  /// Sets a new state value.
  ///
  /// - [value] a new cached value.
  void setValue(value) {
    _value = value;
    _lastUpdateTime = DateTime.now().millisecondsSinceEpoch;
  }
}
