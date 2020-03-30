// let assert = require('chai').assert;
// let async = require('async');

// import { ICache } from '../../src/cache/ICache';

// let KEY1: string = "key1";
// let KEY2: string = "key2";

// let VALUE1: string = "value1";
// let VALUE2: string = "value2";

// export class CacheFixture {
//     private _cache: ICache = null;

//     public constructor(cache: ICache) {
//         this._cache = cache;
//     }

//     public testStoreAndRetrieve(done: any): void {
//         async.series([
//             (callback) => {
//                 this._cache.store(null, KEY1, VALUE1, 5000, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//             (callback) => {
//                 this._cache.store(null, KEY2, VALUE2, 5000, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//             (callback) => {
//                 setTimeout(() => {
//                     callback();
//                 }, 500);
//             },
//             (callback) => {
//                 this._cache.retrieve(null, KEY1, (err, val) => {
//                     assert.isNull(err || null);
//                     assert.isNotNull(val);
//                     assert.equal(VALUE1, val);

//                     callback();
//                 });
//             },
//             (callback) => {
//                 this._cache.retrieve(null, KEY2, (err, val) => {
//                     assert.isNull(err || null);
//                     assert.isNotNull(val);
//                     assert.equal(VALUE2, val);

//                     callback();
//                 });
//             }
//         ], done);
//     }

//     public testRetrieveExpired(done: any): void {
//         async.series([
//             (callback) => {
//                 this._cache.store(null, KEY1, VALUE1, 1000, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//             (callback) => {
//                 setTimeout(() => {
//                     callback();
//                 }, 1500);
//             },
//             (callback) => {
//                 this._cache.retrieve(null, KEY1, (err, val) => {
//                     assert.isNull(err || null);
//                     assert.isNull(val || null);

//                     callback();
//                 });
//             }
//         ], done);
//     }
    
//     public testRemove(done: any): void {
//         async.series([
//             (callback) => {
//                 this._cache.store(null, KEY1, VALUE1, 1000, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//             (callback) => {
//                 this._cache.remove(null, KEY1, (err) => {
//                     assert.isNull(err || null);
//                     callback();
//                 });
//             },
//             (callback) => {
//                 this._cache.retrieve(null, KEY1, (err, val) => {
//                     assert.isNull(err || null);
//                     assert.isNull(val || null);

//                     callback();
//                 });
//             }
//         ], done);
//     }

// }
