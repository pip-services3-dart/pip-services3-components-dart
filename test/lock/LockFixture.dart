// let async = require('async');
// let assert = require('chai').assert;

// import { ILock } from '../../src/lock/ILock';

// let LOCK1: string = "lock_1";
// let LOCK2: string = "lock_2";
// let LOCK3: string = "lock_3";

// export class LockFixture {
//     private _lock: ILock;

//     public constructor(lock: ILock) {
//         this._lock = lock;
//     }

//     public testTryAcquireLock(done: (err: any) => void): void {
//         async.series([
//             // Try to acquire lock for the first time
//             (callback) => {
//                 this._lock.tryAcquireLock(null, LOCK1, 3000, (err, result) => {
//                     assert.isNull(err || null);
//                     assert.isTrue(result);
//                     callback();
//                 });
//             },
//             // Try to acquire lock for the second time
//             (callback) => {
//                 this._lock.tryAcquireLock(null, LOCK1, 3000, (err, result) => {
//                     assert.isNull(err || null);
//                     assert.isFalse(result);
//                     callback();
//                 });
//             },
//             // Release the lock
//             (callback) => {
//                 this._lock.releaseLock(null, LOCK1, callback);
//             },
//             // Try to acquire lock for the third time
//             (callback) => {
//                 this._lock.tryAcquireLock(null, LOCK1, 3000, (err, result) => {
//                     assert.isNull(err || null);
//                     assert.isTrue(result);
//                     callback();
//                 });
//             }
//         ], (err) => {
//             this._lock.releaseLock(null, LOCK1);
//             done(err);
//         });
//     }

//     public testAcquireLock(done: (err: any) => void): void {
//         async.series([
//             // Acquire lock for the first time
//             (callback) => {
//                 this._lock.acquireLock(null, LOCK2, 3000, 1000, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//             // Acquire lock for the second time
//             (callback) => {
//                 this._lock.acquireLock(null, LOCK2, 3000, 1000, (err) => {
//                     assert.isNotNull(err || null);
//                     callback();
//                 });
//             },
//             // Release the lock
//             (callback) => {
//                 this._lock.releaseLock(null, LOCK2, callback)
//             },
//             // Acquire lock for the third time
//             (callback) => {
//                 this._lock.acquireLock(null, LOCK2, 3000, 1000, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//         ], (err) => {
//             this._lock.releaseLock(null, LOCK2);
//             done(err);
//         });
//     }

//     public testReleaseLock(done: (err: any) => void): void {
//         async.series([
//             // Acquire lock for the first time
//             (callback) => {
//                 this._lock.tryAcquireLock(null, LOCK3, 3000, (err, result) => {
//                     assert.isNull(err || null);
//                     assert.isTrue(result);
//                     callback();
//                 });
//             },
//             // Release the lock for the first time
//             (callback) => {
//                 this._lock.releaseLock(null, LOCK3, callback)
//             },
//             // Release the lock for the second time
//             (callback) => {
//                 this._lock.releaseLock(null, LOCK3, callback)
//             }
//         ], done);
//     }
    
// }