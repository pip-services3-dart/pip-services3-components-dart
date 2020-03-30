// /** @module cache */
// import { IReconfigurable } from 'pip-services3-commons-node';
// import { ConfigParams } from 'pip-services3-commons-node';

// import { ICache } from './ICache';
// import { CacheEntry } from './CacheEntry';

// /**
//  * Cache that stores values in the process memory.
//  * 
//  * Remember: This implementation is not suitable for synchronization of distributed processes.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * __options:__
//  * - timeout:               default caching timeout in milliseconds (default: 1 minute)
//  * - max_size:              maximum number of values stored in this cache (default: 1000)        
//  *  
//  * See [ICache]
//  * 
//  * ### Example ###
//  * 
//  *     let cache = new MemoryCache();
//  *     
//  *     cache.store("123", "key1", "ABC", (err) => {
//  *         cache.store("123", "key1", (err, value) => {
//  *             // Result: "ABC"
//  *         });
//  *     });
//  * 
//  */
// export class MemoryCache implements ICache, IReconfigurable {
//     private _cache: any = {};
//     private _count: number = 0;

//     private _timeout: number = 60000;
//     private _maxSize: number = 1000;

// 	/**
// 	 * Creates a new instance of the cache.
// 	 */
//     public constructor() { }

// 	/**
//      * Configures component by passing configuration parameters.
//      * 
//      * - config    configuration parameters to be set.
// 	 */
//     public configure(config: ConfigParams): void {
//         this._timeout = config.getAsLongWithDefault("options.timeout", this._timeout);
//         this._maxSize = config.getAsLongWithDefault("options.max_size", this._maxSize);
//     }

// 	/**
// 	 * Clears component state.
// 	 * 
// 	 * - correlationId 	(optional) transaction id to trace execution through call chain.
//      * - callback 			callback function that receives error or null no errors occured.
// 	 */
//     private cleanup(): void {
//         let oldest: CacheEntry = null;
//         let now: number = new Date().getTime();
//         this._count = 0;

//         // Cleanup obsolete entries and find the oldest
//         for (var prop in this._cache) {
//             let entry: CacheEntry = <CacheEntry>this._cache[prop];
//             // Remove obsolete entry
//             if (entry.isExpired()) {
//                 delete this._cache[prop];
//             }
//             // Count the remaining entry 
//             else {
//                 this._count++;
//                 if (oldest == null || oldest.getExpiration() > entry.getExpiration())
//                     oldest = entry;
//             }
//         }

//         // Remove the oldest if cache size exceeded maximum
//         if (this._count > this._maxSize && oldest != null) {
//             delete this._cache[oldest.getKey()];
//             this._count--;
//         }
//     }

//     /**
//      * Retrieves cached value from the cache using its key.
//      * If value is missing in the cache or expired it returns null.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a unique value key.
//      * - callback          callback function that receives cached value or error.
//      */
//     public retrieve(correlationId: string, key: string, callback: (err: any, value: any) => void): void {
//         if (key == null) {
//             let err = new Error('Key cannot be null');
//             callback(err, null);
//             return;
//         }

//         // Get entry from the cache
//         let entry: CacheEntry = <CacheEntry>this._cache[key];

//         // Cache has nothing
//         if (entry == null) {
//             callback(null, null);
//             return;
//         }

//         // Remove entry if expiration set and entry is expired
//         if (this._timeout > 0 && entry.isExpired()) {
//             delete this._cache[key];
//             this._count--;
//             callback(null, null);
//             return;
//         }

//         callback(null, entry.getValue());
//     }

// 	/**
//      * Stores value in the cache with expiration time.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a unique value key.
//      * - value             a value to store.
//      * - timeout           expiration timeout in milliseconds.
//      * - callback          (optional) callback function that receives an error or null for success
// 	 */
//     public store(correlationId: string, key: string, value: any, timeout: number, callback: (err: any, value: any) => void): void {
//         if (key == null) {
//             let err = new Error('Key cannot be null');
//             if (callback) callback(err, null);
//             return;
//         }

//         // Get the entry
//         let entry: CacheEntry = <CacheEntry>this._cache[key];

//         // Shortcut to remove entry from the cache
//         if (value == null) {
//             if (entry != null) {
//                 delete this._cache[key];
//                 this._count--;
//             }
//             if (callback) callback(null, value);
//             return;
//         }

//         timeout = timeout != null && timeout > 0 ? timeout : this._timeout;

//         // Update the entry
//         if (entry) {
//             entry.setValue(value, timeout);
//         }
//         // Or create a new entry 
//         else {
//             entry = new CacheEntry(key, value, timeout);
//             this._cache[key] = entry;
//             this._count++;
//         }

//         // Clean up the cache
//         if (this._maxSize > 0 && this._count > this._maxSize)
//             this.cleanup();

//         if (callback) callback(null, value);
//     }

// 	/**
//      * Removes a value from the cache by its key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a unique value key.
//      * - callback          (optional) callback function that receives an error or null for success
// 	 */
//     public remove(correlationId: string, key: string, callback: (err: any) => void): void {
//         if (key == null) {
//             let err = new Error('Key cannot be null');
//             if (callback) callback(err);
//             return;
//         }

//         // Get the entry
//         let entry: CacheEntry = <CacheEntry>this._cache[key];

//         // Remove entry from the cache
//         if (entry != null) {
//             delete this._cache[key];
//             this._count--;
//         }

//         if (callback) callback(null);
//     }

// }
