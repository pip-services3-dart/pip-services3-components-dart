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
/// - [timeout]:               default caching timeout in milliseconds (default: 1 minute)
/// - [max_size]:              maximum number of values stored in this cache (default: 1000)
///
/// See [ICache]
///
/// ### Example ###
///
///     var cache = new MemoryCache();
///
///     await cache.store('123', 'key1', 'ABC')
///     var value await cache.retrive('123', 'key1') 
///             // Result: 'ABC'
///
class MemoryCache implements ICache, IReconfigurable {
  final Map _cache = {};
  int _count = 0;

  int _timeout = 60000;
  int _maxSize = 1000;

  /// Creates a new instance of the cache.

  MemoryCache();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _timeout =
        config.getAsLongWithDefault('options.timeout', _timeout);
    _maxSize =
        config.getAsLongWithDefault('options.max_size', _maxSize);
  }

  /// Clears component state.
  ///
  /// - [correlationId] 	(optional) transaction id to trace execution through call chain.
  /// - [callback] 			Future that receives error or null no errors occured.
  void _cleanup() {
    CacheEntry oldest;
    //var now = DateTime.now().millisecondsSinceEpoch;
    _count = 0;

    // Cleanup obsolete entries and find the oldest
    for (var prop in _cache.keys) {
      CacheEntry entry = _cache[prop]; //.cast<CacheEntry>();
      // Remove obsolete entry
      if (entry.isExpired()) {
        _cache.remove(prop);
      }
      // Count the remaining entry
      else {
        _count++;
        if (oldest == null || oldest.getExpiration() > entry.getExpiration()) {
          oldest = entry;
        }
      }
    }

    // Remove the oldest if cache size exceeded maximum
    if (_count > _maxSize && oldest != null) {
      _cache.remove(oldest.getKey());
      _count--;
    }
  }

  /// Retrieves cached value from the cache using its key.
  /// If value is missing in the cache or expired it returns null.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives cached value 
  /// Throws error.
  @override
  Future<dynamic> retrieve(String correlationId, String key) async {
    if (key == null) {
      var err = Exception('Key cannot be null');
      throw err;
    }

    // Get entry from the cache
    CacheEntry entry = _cache[key]; //.cast<CacheEntry>();

    // Cache has nothing
    if (entry == null) {
      return null;
    }

    // Remove entry if expiration set and entry is expired
    if (_timeout > 0 && entry.isExpired()) {
      _cache.remove(key);
      _count--;
      return null;
    }

    return entry.getValue();
  }

  /// Stores value in the cache with expiration time.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique value key.
  /// - [value]             a value to store.
  /// - [timeout]           expiration timeout in milliseconds.
  /// Return                Future that receives an null for success
  /// Throws error
  @override
  Future<dynamic> store(
      String correlationId, String key, value, int timeout) async {
    if (key == null) {
      var err = Exception('Key cannot be null');
      throw err;
    }

    // Get the entry
    CacheEntry entry = _cache[key]; //.cast<CacheEntry>();
    // Shortcut to remove entry from the cache
    if (value == null) {
      if (entry != null) {
        _cache.remove(key);
        _count--;
      }
      return value;
    }

    timeout = timeout != null && timeout > 0 ? timeout : _timeout;

    // Update the entry
    if (entry != null) {
      entry.setValue(value, timeout);
    }
    // Or create a new entry
    else {
      entry = CacheEntry(key, value, timeout);
      _cache[key] = entry;
      _count++;
    }

    // Clean up the cache
    if (_maxSize > 0 && _count > _maxSize) _cleanup();

    return value;
  }

  /// Removes a value from the cache by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives an null for success
  /// Throws error
  @override
  Future<dynamic> remove(String correlationId, String key) async {
    if (key == null) {
      var err = Exception('Key cannot be null');
      throw err;
    }

    // Get the entry
    CacheEntry entry = _cache[key]; //.cast<CacheEntry>();

    // Remove entry from the cache
    if (entry != null) {
      _cache.remove(key);
      _count--;
    }
    return null;
  }
}
