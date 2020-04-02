import 'dart:async';
/// Interface for caches that are used to cache values to improve performance.

abstract class ICache {
  /// Retrieves cached value from the cache using its key.
  /// If value is missing in the cache or expired it returns null.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives cached value 
  /// Throws  error.
  Future<dynamic> retrieve(String correlationId, String key);

  /// Stores value in the cache with expiration time.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique value key.
  /// - [value]             a value to store.
  /// - [timeout]           expiration timeout in milliseconds.
  /// Return                Future that receives an null for success
  /// Throws error
  Future<dynamic> store(String correlationId, String key, value, int timeout);

  /// Removes a value from the cache by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique value key.
  /// Return                Future that receives an null for success
  /// Throws error
  Future<dynamic> remove(String correlationId, String key);
}
