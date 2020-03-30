// /** @module cache */

// /**
//  * Interface for caches that are used to cache values to improve performance.
//  */
// export interface ICache {
//     /**
//      * Retrieves cached value from the cache using its key.
//      * If value is missing in the cache or expired it returns null.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique value key.
//      * @param callback          callback function that receives cached value or error.
//      */
//     retrieve(correlationId: string, key: string,
//         callback: (err: any, value: any) => void): void;

//     /**
//      * Stores value in the cache with expiration time.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique value key.
//      * @param value             a value to store.
//      * @param timeout           expiration timeout in milliseconds.
//      * @param callback          (optional) callback function that receives an error or null for success
//      */
//     store(correlationId: string, key: string, value: any, timeout: number,
//         callback?: (err: any) => void): void;

//     /**
//      * Removes a value from the cache by its key.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique value key.
//      * @param callback          (optional) callback function that receives an error or null for success
//      */
//     remove(correlationId: string, key: string,
//         callback?: (err: any) => void);
// }
