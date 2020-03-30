// /** @module auth */
// /** @hidden */ 
// let async = require('async');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReferences } from 'pip-services3-commons-node';
// import { ReferenceException } from 'pip-services3-commons-node';
// import { Descriptor } from 'pip-services3-commons-node';

// import { CredentialParams } from './CredentialParams';
// import { ICredentialStore } from './ICredentialStore';

// /**
//  * Helper class to retrieve component credentials.
//  * 
//  * If credentials are configured to be retrieved from [ICredentialStore],
//  * it automatically locates [ICredentialStore] in component references
//  * and retrieve credentials from there using store_key parameter.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * __credential:__ 
//  * - store_key:                   (optional) a key to retrieve the credentials from [ICredentialStore]
//  * - ...                          other credential parameters
//  * 
//  * __credentials:__                   alternative to credential
//  * - [credential params 1]:       first credential parameters
//  *     - ...                      credential parameters for key 1
//  * - ...
//  * - [credential params N]:       Nth credential parameters
//  *     - ...                      credential parameters for key N
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:credential-store:\*:\*:1.0</code>  (optional) Credential stores to resolve credentials
//  * 
//  * See [CredentialParams]
//  * See [ICredentialStore]
//  * 
//  * ### Example ###
//  * 
//  *     let config = ConfigParams.fromTuples(
//  *         "credential.user", "jdoe",
//  *         "credential.pass",  "pass123"
//  *     );
//  *     
//  *     let credentialResolver = new CredentialResolver();
//  *     credentialResolver.configure(config);
//  *     credentialResolver.setReferences(references);
//  *     
//  *     credentialResolver.lookup("123", (err, credential) => {
//  *         // Now use credential...
//  *     });
//  * 
//  */
// export class CredentialResolver {
//     private readonly _credentials: CredentialParams[] = [];
//     private _references: IReferences = null;

//     /**
//      * Creates a new instance of credentials resolver.
//      * 
//      * - config        (optional) component configuration parameters
//      * - references    (optional) component references
//      */
//     public constructor(config: ConfigParams = null, references: IReferences = null) {
//         if (config != null) this.configure(config);
//         if (references != null) this.setReferences(references);
//     }

//     /**
//      * Configures component by passing configuration parameters.
//      * 
//      * - config    configuration parameters to be set.
//      */
//     public configure(config: ConfigParams): void {
//         let credentials: CredentialParams[] = CredentialParams.manyFromConfig(config);
//         this._credentials.push(...credentials);
//     }

//     /**
// 	 * Sets references to dependent components.
// 	 * 
// 	 * - references 	references to locate the component dependencies. 
//      */
//     public setReferences(references: IReferences): void {
//         this._references = references;
//     }

//     /**
//      * Gets all credentials configured in component configuration.
//      * 
//      * Redirect to CredentialStores is not done at this point.
//      * If you need fully fleshed credential use [lookup] method instead.
//      * 
//      * Return a list with credential parameters
//      */
//     public getAll(): CredentialParams[] {
//         return this._credentials;
//     }

//     /**
//      * Adds a new credential to component credentials
//      * 
//      * - credential    new credential parameters to be added
//      */
//     public add(credential: CredentialParams): void {
//         this._credentials.push(credential);
//     }

//     private lookupInStores(correlationId: string, credential: CredentialParams, 
//         callback: (err: any, result: CredentialParams) => void): void {

//         if (!credential.useCredentialStore()) {
//             callback(null, null);
//             return;
//         }

//         let key: string = credential.getStoreKey();
//         if (this._references == null) {
//             callback(null, null);
//             return;
//         }

//         let storeDescriptor = new Descriptor("*", "credential-store", "*", "*", "*")
//         let components: any[] = this._references.getOptional<any>(storeDescriptor)
//         if (components.length == 0) {
//             let err = new ReferenceException(correlationId, storeDescriptor);
//             callback(err, null);
//             return;
//         }

//         let firstResult: CredentialParams = null;

//         async.any(
//             components,
//             (component, callback) => {
//                 let store: ICredentialStore = component;
//                 store.lookup(correlationId, key, (err, result) => {
//                     if (err || result == null) {
//                         callback(err, false);
//                     } else {
//                         firstResult = result;
//                         callback(err, true);
//                     }

//                 });
//             },
//             (err) => {
//                 if (callback) callback(err, firstResult);
//             }
//         );
//     }

//     /**
//      * Looks up component credential parameters. If credentials are configured to be retrieved
//      * from Credential store it finds a [ICredentialStore] and lookups credentials there.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - callback 			callback function that receives resolved credential or error.
//      */
//     public lookup(correlationId: string, callback: (err: any, result: CredentialParams) => void): void {

//         if (this._credentials.length == 0) {
//             if (callback) callback(null, null);
//             return;
//         }

//         let lookupCredentials: CredentialParams[] = [];

//         for (let index = 0; index < this._credentials.length; index++) {
//             if (!this._credentials[index].useCredentialStore()) {
//                 if (callback) callback(null, this._credentials[index]);
//                 return;
//             } else {
//                 lookupCredentials.push(this._credentials[index]);
//             }
//         }

//         let firstResult: CredentialParams = null;
//         async.any(
//             lookupCredentials,
//             (credential, callback) => {
//                 this.lookupInStores(correlationId, credential, (err, result) => {
//                     if (err || result == null) {
//                         callback(err, false);
//                     } else {
//                         firstResult = result;
//                         callback(err, true);
//                     }
//                 });
//             },
//             (err) => {
//                 if (callback) callback(err, firstResult);
//             }
//         );
//     }
// }