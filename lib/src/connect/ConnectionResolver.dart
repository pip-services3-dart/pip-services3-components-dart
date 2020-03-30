// /** @module connect */
// /** @hidden */ 
// let async = require('async');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReferences } from 'pip-services3-commons-node';
// import { ReferenceException } from 'pip-services3-commons-node';
// import { Descriptor } from 'pip-services3-commons-node';

// import { ConnectionParams } from './ConnectionParams';
// import { IDiscovery } from './IDiscovery';

// /**
//  * Helper class to retrieve component connections.
//  * 
//  * If connections are configured to be retrieved from [IDiscovery],
//  * it automatically locates [IDiscovery] in component references
//  * and retrieve connections from there using discovery_key parameter.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - __connection:__  
//  *     - discovery_key:               (optional) a key to retrieve the connection from [https://rawgit.com/pip-services-node/pip-services-components-node/master/doc/api/interfaces/connect.idiscovery.html IDiscovery]
//  *     - ...                          other connection parameters
//  * 
//  * - __connections:__                  alternative to connection
//  *     - [connection params 1]:       first connection parameters
//  *         - ...                      connection parameters for key 1
//  *     - [connection params N]:       Nth connection parameters
//  *         - ...                      connection parameters for key N
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:discovery:\*:\*:1.0</code>    (optional) [https://rawgit.com/pip-services-node/pip-services-components-node/master/doc/api/interfaces/connect.idiscovery.html IDiscovery] services to resolve connections
//  * 
//  * See [ConnectionParams]
//  * See [IDiscovery]
//  * 
//  * ### Example ###
//  * 
//  *     let config = ConfigParams.fromTuples(
//  *         "connection.host", "10.1.1.100",
//  *         "connection.port", 8080
//  *     );
//  *     
//  *     let connectionResolver = new ConnectionResolver();
//  *     connectionResolver.configure(config);
//  *     connectionResolver.setReferences(references);
//  *     
//  *     connectionResolver.resolve("123", (err, connection) => {
//  *         // Now use connection...
//  *     });
//  */
// export class ConnectionResolver {
//     private readonly _connections: ConnectionParams[] = [];
//     private _references: IReferences = null;

//     /**
//      * Creates a new instance of connection resolver.
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
//         let connections: ConnectionParams[] = ConnectionParams.manyFromConfig(config);
//         this._connections.push(...connections);
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
//      * Gets all connections configured in component configuration.
//      * 
//      * Redirect to Discovery services is not done at this point.
//      * If you need fully fleshed connection use [resolve] method instead.
//      * 
//      * Return a list with connection parameters
//      */
//     public getAll(): ConnectionParams[] {
//         return this._connections;
//     }

//     /**
//      * Adds a new connection to component connections
//      * 
//      * - connection    new connection parameters to be added
//      */
//     public add(connection: ConnectionParams): void {
//         this._connections.push(connection);
//     }

//     private resolveInDiscovery(correlationId: string, connection: ConnectionParams, 
//         callback: (err: any, result: ConnectionParams) => void): void {
        
//         if (!connection.useDiscovery()) {
//             callback(null, null);
//             return;
//         }

//         let key: string = connection.getDiscoveryKey();
//         if (this._references == null) {
//             callback(null, null);
//             return;
//         }

//         let discoveryDescriptor = new Descriptor("*", "discovery", "*", "*", "*")
//         let discoveries: any[] = this._references.getOptional<any>(discoveryDescriptor)
//         if (discoveries.length == 0) {
//             let err = new ReferenceException(correlationId, discoveryDescriptor);
//             callback(err, null);
//             return;
//         }

//         let firstResult: ConnectionParams = null;

//         async.any(
//             discoveries,
//             (discovery, callback) => {
//                 let discoveryTyped: IDiscovery = discovery;
//                 discoveryTyped.resolveOne(correlationId, key, (err, result) => {
//                     if (err || result == null) {
//                         callback(err, false);
//                     } else {
//                         firstResult = result;
//                         callback(err, true);
//                     }
//                 });
//             },
//             (err) => {
//                 callback(err, firstResult);
//             }
//         );
//     }

//     /**
//      * Resolves a single component connection. If connections are configured to be retrieved
//      * from Discovery service it finds a [IDiscovery] and resolves the connection there.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - callback 			callback function that receives resolved connection or error.
//      * 
//      * See [IDiscovery]
//      */
//     public resolve(correlationId: string, 
//         callback: (err: any, result: ConnectionParams) => void): void {

//         if (this._connections.length == 0) {
//             callback(null, null);
//             return;
//         }

//         let connections: ConnectionParams[] = [];

//         for (let index = 0; index < this._connections.length; index++) {
//             if (!this._connections[index].useDiscovery()) {
//                 callback(null, this._connections[index]);  //If a connection is not configured for discovery use - return it.
//                 return;
//             } else {
//                 connections.push(this._connections[index]);  //Otherwise, add it to the list of connections to resolve.
//             }
//         }

//         if (connections.length == 0) {
//             callback(null, null);
//             return;
//         }

//         let firstResult: ConnectionParams = null;
//         async.any(
//             connections,
//             (connection, callback) => {
//                 this.resolveInDiscovery(correlationId, connection, (err, result) => {
//                     if (err || result == null) {
//                         callback(err, false);
//                     } else {
//                         firstResult = new ConnectionParams(ConfigParams.mergeConfigs(connection, result));
//                         callback(err, true);
//                     }
//                 });
//             },
//             (err) => {
//                 callback(err, firstResult);
//             }
//         );
//     }

//     private resolveAllInDiscovery(correlationId: string, connection: ConnectionParams, 
//         callback: (err: any, result: ConnectionParams[]) => void): void {
        
//         let resolved: ConnectionParams[] = [];
//         let key: string = connection.getDiscoveryKey();

//         if (!connection.useDiscovery()) {
//             callback(null, []);
//             return;
//         }

//         if (this._references == null) {
//             callback(null, []);
//             return;
//         }

//         let discoveryDescriptor = new Descriptor("*", "discovery", "*", "*", "*")
//         let discoveries: any[] = this._references.getOptional<any>(discoveryDescriptor)
//         if (discoveries.length == 0) {
//             let err = new ReferenceException(correlationId, discoveryDescriptor);
//             callback(err, null);
//             return;
//         }

//         async.each(
//             discoveries,
//             (discovery, callback) => {
//                 let discoveryTyped: IDiscovery = discovery;
//                 discoveryTyped.resolveAll(correlationId, key, (err, result) => {
//                     if (err || result == null) {
//                         callback(err);
//                     } else {
//                         resolved = resolved.concat(result);
//                         callback(null);
//                     }

//                 });
//             },
//             (err) => {
//                 callback(err, resolved);
//             }
//         );
//     }

//     /**
//      * Resolves all component connection. If connections are configured to be retrieved
//      * from Discovery service it finds a [IDiscovery] and resolves the connection there.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - callback 			callback function that receives resolved connections or error.
//      * 
//      * See [IDiscovery]
//      */
//     public resolveAll(correlationId: string, callback: (err: any, result: ConnectionParams[]) => void): void {
//         let resolved: ConnectionParams[] = [];
//         let toResolve: ConnectionParams[] = [];

//         for (let index = 0; index < this._connections.length; index++) {
//             if (this._connections[index].useDiscovery())
//                 toResolve.push(this._connections[index]);
//             else
//                 resolved.push(this._connections[index]);
//         }

//         if (toResolve.length <= 0) {
//             callback(null, resolved);
//             return;
//         }

//         async.each(
//             toResolve,
//             (connection, callback) => {
//                 this.resolveAllInDiscovery(correlationId, connection, (err, result) => {
//                     if (err) {
//                         callback(err);
//                     } else {
//                         for (let index = 0; index < result.length; index++) {
//                             let localResolvedConnection: ConnectionParams = new ConnectionParams(ConfigParams.mergeConfigs(connection, result[index]));
//                             resolved.push(localResolvedConnection);
//                         }
//                         callback(null);
//                     }
//                 });
//             },
//             (err) => {
//                 callback(err, resolved);
//             }
//         );
//     }

//     private registerInDiscovery(correlationId: string, connection: ConnectionParams,
//         callback: (err: any, result: boolean) => void) {
        
//         if (!connection.useDiscovery()) {
//             if (callback) callback(null, false);
//             return;
//         }

//         var key = connection.getDiscoveryKey();
//         if (this._references == null) {
//             if (callback) callback(null, false);
//             return;
//         }

//         var discoveries = this._references.getOptional<IDiscovery>(new Descriptor("*", "discovery", "*", "*", "*"));
//         if (discoveries == null) {
//             if (callback) callback(null, false);
//             return;
//         }

//         async.each(
//             discoveries,
//             (discovery, callback) => {
//                 discovery.register(correlationId, key, connection, (err, result) => {
//                     callback(err);
//                 });
//             },
//             (err) => {
//                 if (callback) callback(err, err == null);
//             }
//         );
//     }

//     /**
//      * Registers the given connection in all referenced discovery services.
//      * This method can be used for dynamic service discovery.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - connection        a connection to register.
//      * - callback          callback function that receives registered connection or error.
//      * 
//      * See [IDiscovery]
//      */
//     public register(correlationId: string, connection: ConnectionParams, callback: (err: any) => void): void {
//         this.registerInDiscovery(correlationId, connection, (err, result) => {
//             if (result)
//                 this._connections.push(connection);
//             if (callback) callback(err);
//         });
//     }

// }