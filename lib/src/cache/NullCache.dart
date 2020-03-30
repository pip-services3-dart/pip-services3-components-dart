
import  './ICache.dart';

/**
 * Dummy cache implementation that doesn't do anything.
 * 
 * It can be used in testing or in situations when cache is required
 * but shall be disabled.
 * 
 * See [ICache]
 */
class NullCache implements ICache {
    /**
     * Retrieves cached value from the cache using its key.
     * If value is missing in the cache or expired it returns null.
     * 
     * - correlationId     (optional) transaction id to trace execution through call chain.
     * - key               a unique value key.
     * - callback          callback function that receives cached value or error.
     */
    void retrieve(String correlationId, String key, callback (dynamic err, dynamic value) ) {
        callback(null, null);
    }

    /**
     * Stores value in the cache with expiration time.
     * 
     * - correlationId     (optional) transaction id to trace execution through call chain.
     * - key               a unique value key.
     * - value             a value to store.
     * - timeout           expiration timeout in milliseconds.
     * - callback          (optional) callback function that receives an error or null for success
	 */
    void store(String correlationId, String key, dynamic value, int timeout, [callback (dynamic err, dynamic value) ]) {
        callback(null, value);
    }

	/**
     * Removes a value from the cache by its key.
     * 
     * - correlationId     (optional) transaction id to trace execution through call chain.
     * - key               a unique value key.
     * - callback          (optional) callback function that receives an error or null for success
	 */
    void remove(String correlationId, String key, [callback (dynamic err)]) {
        callback(null);
    }

}
