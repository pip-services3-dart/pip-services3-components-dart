// /** @module connect */
// import { ConnectionParams } from './ConnectionParams';

// /**
//  * Interface for discovery services which are used to store and resolve connection parameters
//  * to connect to external services.
//  * 
//  * See [ConnectionParams]
//  * See [CredentialParams]
//  */
// export interface IDiscovery {
//     /**
//      * Registers connection parameters into the discovery service.
//      *
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the connection parameters.
//      * - credential        a connection to be registered.
//      * - callback 			callback function that receives a registered connection or error.
//      */
//     register(correlationId: string, key: string, connection: ConnectionParams,
//         callback: (err: any, result: ConnectionParams) => void): void;

//     /**
//      * Resolves a single connection parameters by its key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the connection.
//      * - callback          callback function that receives found connection or error.
//      */
//     resolveOne(correlationId: string, key: string,
//         callback: (err: any, result: ConnectionParams) => void): void;

//     /**
//      * Resolves all connection parameters by their key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the connections.
//      * - callback          callback function that receives found connections or error.
//      */
//     resolveAll(correlationId: string, key: string, callback: (err: any, result: ConnectionParams[]) => void): void;
// }