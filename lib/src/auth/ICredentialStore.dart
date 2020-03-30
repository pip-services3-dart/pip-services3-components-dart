// /** @module auth */
// import { CredentialParams } from './CredentialParams';

// /**
//  * Interface for credential stores which are used to store and lookup credentials
//  * to authenticate against external services.
//  * 
//  * See [CredentialParams]
//  * See [ConnectionParams]
//  */
// export interface ICredentialStore {
//     /**
//      * Stores credential parameters into the store.
//      *
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the credential.
//      * - credential        a credential to be stored.
//      * - callback 			callback function that receives an error or null for success.
//      */
//     store(correlationId: string, key: String, credential: CredentialParams, callback: (err: any) => void): void;

//     /**
//      * Lookups credential parameters by its key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the credential.
//      * - callback          callback function that receives found credential or error.
//      */
//     lookup(correlationId: string, key: string, callback: (err: any, result: CredentialParams) => void): void;
// }