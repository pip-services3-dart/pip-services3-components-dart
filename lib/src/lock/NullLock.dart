import 'dart:async';
import '../../pip_services3_components.dart';

/// Dummy lock implementation that doesn't do anything.
///
/// It can be used in testing or in situations when lock is required
/// but shall be disabled.
///
/// See [ILock]
class NullLock implements ILock {
  /// Makes a single attempt to acquire a lock by its key.
  /// It returns immediately a positive or negative result.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// Return          Future  that receives a lock result or error.
  @override
  Future<bool> tryAcquireLock(
      String? correlationId, String key, int ttl) async {
    return true;
  }

  /// Makes multiple attempts to acquire a lock by its key within give time interval.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// - [timeout]           a lock acquisition timeout.
  /// Return          Future  that receives error or null for success.
  @override
  Future acquireLock(
      String? correlationId, String key, int ttl, int timeout) async {
    // Do nothing...
  }

  /// Releases prevously acquired lock by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to release.
  /// Return          Future  that receives error or null for success.
  @override
  Future releaseLock(String? correlationId, String key) async {
    // Do nothing...
  }
}
