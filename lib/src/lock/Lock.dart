import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_commons/src/config/IReconfigurable.dart';
import 'package:pip_services3_commons/src/errors/ConflictException.dart';

import './ILock.dart';
import 'dart:async';


/// Abstract lock that implements default lock acquisition routine.
/// 
/// ### Configuration parameters ###
/// 
/// - __options:__
///     - retry_timeout:   timeout in milliseconds to retry lock acquisition. (Default: 100)
/// 
/// See [ILock]
 
abstract class Lock implements ILock, IReconfigurable {
    int _retryTimeout = 100;

    
    /// Configures component by passing configuration parameters.
    /// 
    /// - config    configuration parameters to be set.
     
    void configure(ConfigParams config) {
        this._retryTimeout = config.getAsIntegerWithDefault("options.retry_timeout", this._retryTimeout);
    }

    
    /// Makes a single attempt to acquire a lock by its key.
    /// It returns immediately a positive or negative result.
    /// 
    /// - correlationId     (optional) transaction id to trace execution through call chain.
    /// - key               a unique lock key to acquire.
    /// - ttl               a lock timeout (time to live) in milliseconds.
    /// - callback          callback function that receives a lock result or error.
     
    tryAcquireLock(String correlationId, String key, int ttl,
        callback (dynamic err, bool result));


    
    /// Releases prevously acquired lock by its key.
    /// 
    /// - correlationId     (optional) transaction id to trace execution through call chain.
    /// - key               a unique lock key to release.
    /// - callback          callback function that receives error or null for success.
     
    void releaseLock(String correlationId, String key,
        [callback (dynamic err)]);
        
    
    /// Makes multiple attempts to acquire a lock by its key within give time interval.
    /// 
    /// - correlationId     (optional) transaction id to trace execution through call chain. 
    /// - key               a unique lock key to acquire.
    /// - ttl               a lock timeout (time to live) in milliseconds.
    /// - timeout           a lock acquisition timeout.
    /// - callback          callback function that receives error or null for success.
     
    acquireLock(String correlationId, String key, int ttl, int timeout,
        callback (dynamic err)) {
        var retryTime = new DateTime.now().add(Duration(milliseconds: timeout)).millisecondsSinceEpoch;

        // Try to get lock first
        this.tryAcquireLock(correlationId, key, ttl, (err, result)  {
            if (err != null || result == null ) {
                callback(err);
                return;
            }

            // Start retrying
             Timer.periodic(Duration(milliseconds: this._retryTimeout), (Timer tm ) {
                // When timeout expires return false
                var now = new DateTime.now().millisecondsSinceEpoch;
                if (now > retryTime) {
                    tm.cancel();
                    var err = new ConflictException(
                        correlationId,
                        "LOCK_TIMEOUT",
                        "Acquiring lock " + key + " failed on timeout"
                    ).withDetails("key", key);
                    callback(err);
                    return;
                }

                this.tryAcquireLock(correlationId, key, ttl, (err, result)  {
                    if (err || result) {
                        tm.cancel();
                        callback(err);
                    }
                });
            });
        });
    }
}