import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Cache that stores values in the process memory.
///
/// Remember: This implementation is not suitable for synchronization of distributed processes.
///
/// ### Configuration parameters ###
///
/// __options:__
/// - timeout:               default caching timeout in milliseconds (default: 1 minute)
/// - max_size:              maximum number of values stored in this cache (default: 1000)
///
/// See [ICache]
///
/// ### Example ###
///
///     var cache = new MemoryCache();
///
///     cache.store('123', 'key1', 'ABC', (err) => {
///         cache.store('123', 'key1', (err, value) => {
///             // Result: 'ABC'
///         });
///     });
///

class MemoryCache implements ICache, IReconfigurable {
  Map _cache = {};
  int _count = 0;

  int _timeout = 60000;
  int _maxSize = 1000;

  /// Creates a new instance of the cache.

  MemoryCache() {}

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.

  void configure(ConfigParams config) {
    this._timeout =
        config.getAsLongWithDefault('options.timeout', this._timeout);
    this._maxSize =
        config.getAsLongWithDefault('options.max_size', this._maxSize);
  }

  /// Clears component state.
  ///
  /// - correlationId 	(optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives error or null no errors occured.

  void _cleanup() {
    CacheEntry oldest = null;
    int now = DateTime.now().millisecondsSinceEpoch;
    this._count = 0;

    // Cleanup obsolete entries and find the oldest
    for (var prop in this._cache.keys) {
      CacheEntry entry = this._cache[prop]; //.cast<CacheEntry>();
      // Remove obsolete entry
      if (entry.isExpired()) {
        this._cache.remove(prop);
      }
      // Count the remaining entry
      else {
        this._count++;
        if (oldest == null || oldest.getExpiration() > entry.getExpiration())
          oldest = entry;
      }
    }

    // Remove the oldest if cache size exceeded maximum
    if (this._count > this._maxSize && oldest != null) {
      this._cache.remove(oldest.getKey());
      this._count--;
    }
  }

  /// Retrieves cached value from the cache using its key.
  /// If value is missing in the cache or expired it returns null.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique value key.
  /// - callback          callback function that receives cached value or error.

  Future<dynamic> retrieve(String correlationId, String key) async {
    if (key == null) {
      var err = Exception('Key cannot be null');
      throw err;
    }

    // Get entry from the cache
    CacheEntry entry = this._cache[key]; //.cast<CacheEntry>();

    // Cache has nothing
    if (entry == null) {
      return null;
    }

    // Remove entry if expiration set and entry is expired
    if (this._timeout > 0 && entry.isExpired()) {
      this._cache.remove(key);
      this._count--;
      return null;
    }

    return entry.getValue();
  }

  /// Stores value in the cache with expiration time.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique value key.
  /// - value             a value to store.
  /// - timeout           expiration timeout in milliseconds.
  /// - callback          (optional) callback function that receives an error or null for success

  Future<dynamic> store(
      String correlationId, String key, value, int timeout) async {
    if (key == null) {
      var err = Exception('Key cannot be null');
      throw err;
    }

    // Get the entry
    CacheEntry entry = this._cache[key]; //.cast<CacheEntry>();

    // Shortcut to remove entry from the cache
    if (value == null) {
      if (entry != null) {
        this._cache.remove(key);
        this._count--;
      }
      return value;
    }

    timeout = timeout != null && timeout > 0 ? timeout : this._timeout;

    // Update the entry
    if (entry != null) {
      entry.setValue(value, timeout);
    }
    // Or create a new entry
    else {
      entry = new CacheEntry(key, value, timeout);
      this._cache[key] = entry;
      this._count++;
    }

    // Clean up the cache
    if (this._maxSize > 0 && this._count > this._maxSize) this._cleanup();

    return value;
  }

  /// Removes a value from the cache by its key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique value key.
  /// - callback          (optional) callback function that receives an error or null for success

  Future<dynamic> remove(String correlationId, String key) async {
    if (key == null) {
      var err = Exception('Key cannot be null');
      throw err;
    }

    // Get the entry
    CacheEntry entry = this._cache[key]; //.cast<CacheEntry>();

    // Remove entry from the cache
    if (entry != null) {
      this._cache.remove(key);
      this._count--;
    }
    return null;
  }
}
