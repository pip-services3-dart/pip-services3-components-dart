/// Data object to store cached values with their keys used by [MemoryCache]

class CacheEntry {
  String _key;
  var _value;
  int _expiration;

  /// Creates a new instance of the cache entry and assigns its values.
  ///
  /// - key       a unique key to locate the value.
  /// - value     a value to be stored.
  /// - timeout   expiration timeout in milliseconds.

  CacheEntry(String key, dynamic value, int timeout) {
    this._key = key;
    this._value = value;
    this._expiration = DateTime.now()
        .add(Duration(milliseconds: timeout))
        .millisecondsSinceEpoch;
  }

  /// Gets the key to locate the cached value.
  ///
  /// Return the value key.

  String getKey() {
    return this._key;
  }

  /// Gets the cached value.
  ///
  /// Return the value object.

  getValue() {
    return this._value;
  }

  /// Gets the expiration timeout.
  ///
  /// Return the expiration timeout in milliseconds.

  int getExpiration() {
    return this._expiration;
  }

  /// Sets a new value and extends its expiration.
  ///
  /// - value     a new cached value.
  /// - timeout   a expiration timeout in milliseconds.
  void setValue(value, int timeout) {
    this._value = value;
    this._expiration = DateTime.now()
        .add(Duration(milliseconds: timeout))
        .millisecondsSinceEpoch;
  }

  /// Checks if this value already expired.
  ///
  /// Return true if the value already expires and false otherwise.

  bool isExpired() {
    return this._expiration < new DateTime.now().millisecondsSinceEpoch;
  }
}
