
import './ILock.dart';

/**
 * Dummy lock implementation that doesn't do anything.
 * 
 * It can be used in testing or in situations when lock is required
 * but shall be disabled.
 * 
 * See [ILock]
 */
class NullLock implements ILock {
    /**
     * Makes a single attempt to acquire a lock by its key.
     * It returns immediately a positive or negative result.
     * 
     * - correlationId     (optional) transaction id to trace execution through call chain.
     * - key               a unique lock key to acquire.
     * - ttl               a lock timeout (time to live) in milliseconds.
     * - callback          callback function that receives a lock result or error.
     */
    void tryAcquireLock(String correlationId,String  key, int ttl,
        callback (dynamic err, bool result)) {
        callback(null, true);
    }

    /**
     * Makes multiple attempts to acquire a lock by its key within give time interval.
     * 
     * - correlationId     (optional) transaction id to trace execution through call chain. 
     * - key               a unique lock key to acquire.
     * - ttl               a lock timeout (time to live) in milliseconds.
     * - timeout           a lock acquisition timeout.
     * - callback          callback function that receives error or null for success.
     */
    acquireLock(String correlationId,String  key, int ttl,int timeout,
        callback (dynamic err) ) {
        callback(null);
    }

    /**
     * Releases prevously acquired lock by its key.
     * 
     * - correlationId     (optional) transaction id to trace execution through call chain.
     * - key               a unique lock key to release.
     * - callback          callback function that receives error or null for success.
     */
    void releaseLock(String correlationId, String key,
        [callback (dynamic err)]) {
        if (callback != null) callback(null);
    }
}