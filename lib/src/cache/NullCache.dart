// /** @module cache */
// import { ICache } from './ICache';

// /**
//  * Dummy cache implementation that doesn't do anything.
//  * 
//  * It can be used in testing or in situations when cache is required
//  * but shall be disabled.
//  * 
//  * See [ICache]
//  */
// export class NullCache implements ICache {
//     /**
//      * Retrieves cached value from the cache using its key.
//      * If value is missing in the cache or expired it returns null.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a unique value key.
//      * - callback          callback function that receives cached value or error.
//      */
//     public retrieve(correlationId: string, key: string, callback: (err: any, value: any) => void): void {
//         callback(null, null);
//     }

//     /**
//      * Stores value in the cache with expiration time.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a unique value key.
//      * - value             a value to store.
//      * - timeout           expiration timeout in milliseconds.
//      * - callback          (optional) callback function that receives an error or null for success
// 	 */
//     public store(correlationId: string, key: string, value: any, timeout: number, callback: (err: any, value: any) => void): void {
//         callback(null, value);
//     }

// 	/**
//      * Removes a value from the cache by its key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a unique value key.
//      * - callback          (optional) callback function that receives an error or null for success
// 	 */
//     public remove(correlationId: string, key: string, callback: (err: any) => void): void {
//         callback(null);
//     }

// }
