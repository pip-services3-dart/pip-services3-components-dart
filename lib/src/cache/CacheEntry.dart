// /** @module cache */

// /**
//  * Data object to store cached values with their keys used by [[MemoryCache]]
//  */
// export class CacheEntry {
//     private _key: string;
//     private _value: any;
//     private _expiration: number;

//     /**
//      * Creates a new instance of the cache entry and assigns its values.
//      * 
//      * @param key       a unique key to locate the value.
//      * @param value     a value to be stored.
//      * @param timeout   expiration timeout in milliseconds.
//      */
//     public constructor(key: string, value: any, timeout: number) {
//         this._key = key;
//         this._value = value;
//         this._expiration = new Date().getTime() + timeout;
//     }

//     /**
//      * Gets the key to locate the cached value.
//      * 
//      * @returns the value key.
//      */
//     public getKey(): string {
//         return this._key;
//     }

//     /**
//      * Gets the cached value.
//      * 
//      * @returns the value object.
//      */
//     public getValue(): any {
//         return this._value;
//     }

//     /**
//      * Gets the expiration timeout.
//      * 
//      * @returns the expiration timeout in milliseconds.
//      */
//     public getExpiration(): number {
//         return this._expiration;
//     }

//     /**
//      * Sets a new value and extends its expiration.
//      * 
//      * @param value     a new cached value.
//      * @param timeout   a expiration timeout in milliseconds.
//      */
//     public setValue(value: any, timeout: number): void {
//         this._value = value;
//         this._expiration = new Date().getTime() + timeout;
//     }

//     /**
//      * Checks if this value already expired.
//      * 
//      * @returns true if the value already expires and false otherwise.
//      */
//     public isExpired(): boolean {
//         return this._expiration < new Date().getTime();
//     }

// }
