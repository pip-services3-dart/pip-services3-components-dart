import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Abstract lock that implements default lock acquisition routine.
///
/// ### Configuration parameters ###
///
/// - __options:__
///     - [retry_timeout]:   timeout in milliseconds to retry lock acquisition. (Default: 100)
///
/// See [ILock]

abstract class Lock implements ILock, IReconfigurable {
  int _retryTimeout = 100;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _retryTimeout =
        config.getAsIntegerWithDefault('options.retry_timeout', _retryTimeout);
  }

  /// Makes a single attempt to acquire a lock by its key.
  /// It returns immediately a positive or negative result.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// Return                Future  that receives a lock result
  /// Throws error.
  @override
  Future<bool> tryAcquireLock(String correlationId, String key, int ttl);

  /// Releases prevously acquired lock by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to release.
  /// Return              Future  that receives null for success.
  /// Throws error
  @override
  Future releaseLock(String correlationId, String key);

  /// Makes multiple attempts to acquire a lock by its key within give time interval.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique lock key to acquire.
  /// - [ttl]               a lock timeout (time to live) in milliseconds.
  /// - [timeout]           a lock acquisition timeout.
  /// Return          Future  that receives null for success.
  /// Throw error
  @override
  Future acquireLock(
      String correlationId, String key, int ttl, int timeout) async {
    var retryTime = DateTime.now()
        .toUtc()
        .add(Duration(milliseconds: timeout))
        .millisecondsSinceEpoch;

    // Try to get lock first
    var result = await tryAcquireLock(correlationId, key, ttl);
    if (result) {
      return null;
    }
    // Start retrying
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    for (; now <= retryTime;) {
      await Future.delayed(Duration(milliseconds: _retryTimeout));
      result = await tryAcquireLock(correlationId, key, ttl);
      if (result) {
        return;
      }
      now = DateTime.now().toUtc().millisecondsSinceEpoch;
    }
    // When timeout expires throw exception
    throw ConflictException(correlationId, 'LOCK_TIMEOUT',
            'Acquiring lock ' + key + ' failed on timeout')
        .withDetails('key', key);
  }
}
