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
///     var lock = MemoryLock();
///             try {
///             lock.acquire("123", "key1")
///                 // Processing...
///             } finally {
///                 lock.releaseLock("123", "key1", 
///                     // Continue...
///    
///             }
///         }
///     });

class MemoryLock extends Lock {
  final Map<String, int> _locks = {};

  /// Makes a single attempt to acquire a lock by its key.
  /// It returns immediately a positive or negative result.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// Return                Future  that receives a lock result
  /// Throws error.
  @override
  Future<bool> tryAcquireLock(String correlationId, String key, int ttl) async {
    var expireTime = _locks[key];
    var now = DateTime.now().millisecondsSinceEpoch;

    if (expireTime == null || expireTime < now) {
      _locks[key] = now + ttl;
      return true;
    } else {
      return false;
    }
  }

  /// Releases the lock with the given key.
  ///
  /// - [correlationId]     not used.
  /// - [key]               the key of the lock that is to be released.
  /// Return                Future the lock has been released. Will be called
  ///                          with null.
  /// Throw error
  @override
  Future releaseLock(String correlationId, String key) async {
    _locks.remove(key);
  }
}
