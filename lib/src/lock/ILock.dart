
import 'dart:async';
/// Interface for locks to synchronize work or parallel processes and to prevent collisions.
///
/// The lock allows to manage multiple locks identified by unique keys.

abstract class ILock {
  /// Makes a single attempt to acquire a lock by its key.
  /// It returns immediately a positive or negative result.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique lock key to acquire.
  /// - ttl               a lock timeout (time to live) in milliseconds.
  /// - callback          callback function that receives a lock result or error.

  Future<bool> tryAcquireLock(String correlationId, String key, int ttl);

  /// Makes multiple attempts to acquire a lock by its key within give time interval.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique lock key to acquire.
  /// - ttl               a lock timeout (time to live) in milliseconds.
  /// - timeout           a lock acquisition timeout.
  /// - callback          callback function that receives error or null for success.

  Future acquireLock(String correlationId, String key, int ttl, int timeout);

  /// Releases prevously acquired lock by its key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique lock key to release.
  /// - callback          callback function that receives error or null for success.

  Future releaseLock(String correlationId, String key);
}
