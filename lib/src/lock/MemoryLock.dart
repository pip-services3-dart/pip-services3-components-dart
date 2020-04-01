import 'dart:async';
import '../../pip_services3_components.dart';

/// Lock that is used to synchronize execution within one process using shared memory.
///
/// Remember: This implementation is not suitable for synchronization of distributed processes.
///
/// ### Configuration parameters ###
///
/// - __options:__
///     - retry_timeout:   timeout in milliseconds to retry lock acquisition. (Default: 100)
///
/// See [ILock]
/// See [Lock]
///
/// ### Example ###
///
///     var lock = new MemoryLock();
///
///     lock.acquire("123", "key1", (err) => {
///         if (err == null) {
///             try {
///                 // Processing...
///             } finally {
///                 lock.releaseLock("123", "key1", (err) => {
///                     // Continue...
///                 });
///             }
///         }
///     });

class MemoryLock extends Lock {
  Map<String, int> _locks = {};

  /// Makes a single attempt to acquire a lock by its key.
  /// It returns immediately a positive or negative result.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a unique lock key to acquire.
  /// - ttl               a lock timeout (time to live) in milliseconds.
  /// - callback          callback function that receives a lock result or error.

  Future<bool> tryAcquireLock(String correlationId, String key, int ttl) async {
    var expireTime = this._locks[key];
    var now = new DateTime.now().millisecondsSinceEpoch;

    if (expireTime == null || expireTime < now) {
      this._locks[key] = now + ttl;
      return true;
    } else {
      return false;
    }
  }

  /// Releases the lock with the given key.
  ///
  /// - correlationId     not used.
  /// - key               the key of the lock that is to be released.
  /// - callback          (optional) the function to call once the lock has been released. Will be called
  ///                          with null.

  Future releaseLock(String correlationId, String key) async {
    this._locks.remove(key);
  }
}
