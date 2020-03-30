// /** @module lock */
// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReconfigurable } from 'pip-services3-commons-node';
// import { ConflictException } from 'pip-services3-commons-node';

// import { ILock } from './ILock';

// /**
//  * Abstract lock that implements default lock acquisition routine.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - __options:__
//  *     - retry_timeout:   timeout in milliseconds to retry lock acquisition. (Default: 100)
//  * 
//  * @see [[ILock]]
//  */
// export abstract class Lock implements ILock, IReconfigurable {
//     private _retryTimeout: number = 100;

//     /**
//      * Configures component by passing configuration parameters.
//      * 
//      * @param config    configuration parameters to be set.
//      */
//     public configure(config: ConfigParams): void {
//         this._retryTimeout = config.getAsIntegerWithDefault("options.retry_timeout", this._retryTimeout);
//     }

//     /**
//      * Makes a single attempt to acquire a lock by its key.
//      * It returns immediately a positive or negative result.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique lock key to acquire.
//      * @param ttl               a lock timeout (time to live) in milliseconds.
//      * @param callback          callback function that receives a lock result or error.
//      */
//     public abstract tryAcquireLock(correlationId: string, key: string, ttl: number,
//         callback: (err: any, result: boolean) => void): void;


//     /**
//      * Releases prevously acquired lock by its key.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a unique lock key to release.
//      * @param callback          callback function that receives error or null for success.
//      */
//     public abstract releaseLock(correlationId: string, key: string,
//         callback?: (err: any) => void): void;
        
//     /**
//      * Makes multiple attempts to acquire a lock by its key within give time interval.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain. 
//      * @param key               a unique lock key to acquire.
//      * @param ttl               a lock timeout (time to live) in milliseconds.
//      * @param timeout           a lock acquisition timeout.
//      * @param callback          callback function that receives error or null for success.
//      */
//     public acquireLock(correlationId: string, key: string, ttl: number, timeout: number,
//         callback: (err: any) => void): void {
//         let retryTime = new Date().getTime() + timeout;

//         // Try to get lock first
//         this.tryAcquireLock(correlationId, key, ttl, (err, result) => {
//             if (err || result) {
//                 callback(err);
//                 return;
//             }

//             // Start retrying
//             let interval = setInterval(() => {
//                 // When timeout expires return false
//                 let now = new Date().getTime();
//                 if (now > retryTime) {
//                     clearInterval(interval);
//                     let err = new ConflictException(
//                         correlationId,
//                         "LOCK_TIMEOUT",
//                         "Acquiring lock " + key + " failed on timeout"
//                     ).withDetails("key", key);
//                     callback(err);
//                     return;
//                 }

//                 this.tryAcquireLock(correlationId, key, ttl, (err, result) => {
//                     if (err || result) {
//                         clearInterval(interval);
//                         callback(err);
//                     }
//                 });
//             }, this._retryTimeout);
//         });
//     }
// }