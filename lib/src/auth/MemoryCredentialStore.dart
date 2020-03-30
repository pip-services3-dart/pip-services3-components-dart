// /** @module auth */
// /** @hidden */ 
// let async = require('async');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReconfigurable } from 'pip-services3-commons-node';
// import { StringValueMap } from 'pip-services3-commons-node';

// import { CredentialParams } from './CredentialParams';
// import { ICredentialStore } from './ICredentialStore';

// /**
//  * Credential store that keeps credentials in memory.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - [credential key 1]:            
//  *     - ...                          credential parameters for key 1
//  * - [credential key 2]:            
//  *     - ...                          credential parameters for key N
//  * - ...
//  *  
//  * @see [[ICredentialStore]]
//  * @see [[CredentialParams]]
//  * 
//  * ### Example ###
//  * 
//  *     let config = ConfigParams.fromTuples(
//  *         "key1.user", "jdoe",
//  *         "key1.pass", "pass123",
//  *         "key2.user", "bsmith",
//  *         "key2.pass", "mypass"
//  *     );
//  *     
//  *     let credentialStore = new MemoryCredentialStore();
//  *     credentialStore.readCredentials(config);
//  *     
//  *     credentialStore.lookup("123", "key1", (err, credential) => {
//  *         // Result: user=jdoe;pass=pass123
//  *     });
//  */
// export class MemoryCredentialStore implements ICredentialStore, IReconfigurable {
//     private _items: any = {};

//     /**
//      * Creates a new instance of the credential store.
//      * 
//      * @param config    (optional) configuration with credential parameters.
//      */
//     public constructor(config: ConfigParams = null) {
//         if (config != null)
//             this.configure(config);
//     }

//     /**
//      * Configures component by passing configuration parameters.
//      * 
//      * @param config    configuration parameters to be set.
//      */
//     public configure(config: ConfigParams): void {
//         this.readCredentials(config);
//     }

//     /**
//      * Reads credentials from configuration parameters.
//      * Each section represents an individual CredentialParams
//      * 
//      * @param config   configuration parameters to be read
//      */
//     public readCredentials(config: ConfigParams) {
//         this._items = {};
//         let keys = config.getKeys();
//         for (let index = 0; index < keys.length; index++) {
//             let key = keys[index];
//             let value = config.getAsString(key);
//             this._items[key] = CredentialParams.fromString(value);
//         }
//     }

//     /**
//      * Stores credential parameters into the store.
//      *
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a key to uniquely identify the credential parameters.
//      * @param credential        a credential parameters to be stored.
//      * @param callback 			callback function that receives an error or null for success.
//      */
//     public store(correlationId: string, key: string, credential: CredentialParams,
//         callback: (err: any) => void): void {
//         if (credential != null)
//             this._items[key] = credential;
//         else
//             delete this._items[key];

//         if (callback) callback(null);
//     }

//     /**
//      * Lookups credential parameters by its key.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param key               a key to uniquely identify the credential parameters.
//      * @param callback          callback function that receives found credential parameters or error.
//      */
//     public lookup(correlationId: string, key: string,
//         callback: (err: any, result: CredentialParams) => void): void {
//         let credential = this._items[key];
//         callback(null, credential);
//     }
// }