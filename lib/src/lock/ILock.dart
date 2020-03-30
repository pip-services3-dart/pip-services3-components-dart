// /** @module lock */

// /**
//  * Interface for locks to synchronize work or parallel processes and to prevent collisions.
//  * 
//  * The lock allows to manage multiple locks identified by unique keys.
//  */
// export interface ILock {
//     /**
//      * Makes a single attempt to acquire a lock by its key.
//      * It returns immediately a positive or negative result.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique lock key to acquire.
//      * @param ttl               a lock timeout (time to live) in milliseconds.
//      * @param callback          callback function that receives a lock result or error.
//      */
//     tryAcquireLock(correlationId: string, key: string, ttl: number,
//         callback: (err: any, result: boolean) => void): void;
    
//     /**
//      * Makes multiple attempts to acquire a lock by its key within give time interval.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain. 
//      * @param key               a unique lock key to acquire.
//      * @param ttl               a lock timeout (time to live) in milliseconds.
//      * @param timeout           a lock acquisition timeout.
//      * @param callback          callback function that receives error or null for success.
//      */
//     acquireLock(correlationId: string, key: string, ttl: number, timeout: number,
//         callback: (err: any) => void): void;
    
//     /**
//      * Releases prevously acquired lock by its key.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique lock key to release.
//      * @param callback          callback function that receives error or null for success.
//      */
//     releaseLock(correlationId: string, key: string,
//         callback?: (err: any) => void): void;
// }