/// Data object to store cached values with their keys used by [MemoryCache]

class CacheEntry {
  String _key;
  var _value;
  int _expiration;

  /// Creates a new instance of the cache entry and assigns its values.
  ///
  /// - [key]       a unique key to locate the value.
  /// - [value]     a value to be stored.
  /// - [timeout]   expiration timeout in milliseconds.
  CacheEntry(String key, dynamic value, int timeout) {
    _key = key;
    _value = value;
    _expiration = DateTime.now()
        .toUtc()
        .add(Duration(milliseconds: timeout))
        .millisecondsSinceEpoch;
  }

  /// Gets the key to locate the cached value.
  ///
  /// Return the value key.
  String getKey() {
    return _key;
  }

  /// Gets the cached value.
  ///
  /// Return the value object.
  dynamic getValue() {
    return _value;
  }

  /// Gets the expiration timeout.
  ///
  /// Return the expiration timeout in milliseconds.
  int getExpiration() {
    return _expiration;
  }

  /// Sets a new value and extends its expiration.
  ///
  /// - [value]     a new cached value.
  /// - [timeout]   a expiration timeout in milliseconds.
  void setValue(value, int timeout) {
    _value = value;
    _expiration = DateTime.now()
        .toUtc()
        .add(Duration(milliseconds: timeout))
        .millisecondsSinceEpoch;
  }

  /// Checks if this value already expired.
  ///
  /// Return true if the value already expires and false otherwise.
  bool isExpired() {
    return _expiration < DateTime.now().toUtc().millisecondsSinceEpoch;
  }
}
