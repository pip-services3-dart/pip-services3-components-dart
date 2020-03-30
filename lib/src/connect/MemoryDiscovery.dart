// /** @module connect */
// /** @hidden */ 
// let async = require('async');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReconfigurable } from 'pip-services3-commons-node';

// import { ConnectionParams } from './ConnectionParams';
// import { IDiscovery } from './IDiscovery';

// /**
//  * Used to store key-identifiable information about connections.
//  */
// class DiscoveryItem {
//     public key: string;
//     public connection: ConnectionParams;
// }

// /**
//  * Discovery service that keeps connections in memory.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - [connection key 1]:            
//  *     - ...                          connection parameters for key 1
//  * - [connection key 2]:            
//  *     - ...                          connection parameters for key N
//  * 
//  * See [IDiscovery]
//  * See [ConnectionParams]
//  * 
//  * ### Example ###
//  * 
//  *     let config = ConfigParams.fromTuples(
//  *         "key1.host", "10.1.1.100",
//  *         "key1.port", "8080",
//  *         "key2.host", "10.1.1.100",
//  *         "key2.port", "8082"
//  *     );
//  *     
//  *     let discovery = new MemoryDiscovery();
//  *     discovery.readConnections(config);
//  *     
//  *     discovery.resolve("123", "key1", (err, connection) => {
//  *         // Result: host=10.1.1.100;port=8080
//  *     });
//  */
// export class MemoryDiscovery implements IDiscovery, IReconfigurable {
//     private _items: DiscoveryItem[] = [];

//     /**
//      * Creates a new instance of discovery service.
//      * 
//      * - config    (optional) configuration with connection parameters.
//      */
//     public constructor(config: ConfigParams = null) {
//         if (config != null)
//             this.configure(config);
//     }

//     /**
//      * Configures component by passing configuration parameters.
//      * 
//      * - config    configuration parameters to be set.
//      */
//     public configure(config: ConfigParams): void {
//         this.readConnections(config);
//     }

//     /**
//      * Reads connections from configuration parameters.
//      * Each section represents an individual Connectionparams
//      * 
//      * - config   configuration parameters to be read
//      */
//     public readConnections(config: ConfigParams) {
//         this._items = [];
//         let keys = config.getKeys();
//         for (let index = 0; index < keys.length; index++) {
//             let key = keys[index];
//             let value = config.getAsNullableString(key);
//             let item: DiscoveryItem = new DiscoveryItem();
//             item.key = key;
//             item.connection = ConnectionParams.fromString(value);
//             this._items.push(item);
//         }
//     }

//     /**
//      * Registers connection parameters into the discovery service.
//      *
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the connection parameters.
//      * - credential        a connection to be registered.
//      * - callback 			callback function that receives a registered connection or error.
//      */
//     public register(correlationId: string, key: string, connection: ConnectionParams,
//         callback: (err: any, result: ConnectionParams) => void): void {
//         let item: DiscoveryItem = new DiscoveryItem();
//         item.key = key;
//         item.connection = connection;
//         this._items.push(item);
//         if (callback) callback(null, connection);
//     }

//     /**
//      * Resolves a single connection parameters by its key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the connection.
//      * - callback          callback function that receives found connection or error.
//      */
//     public resolveOne(correlationId: string, key: string, callback: (err: any, result: ConnectionParams) => void): void {
//         let connection: ConnectionParams = null;
//         for (let index = 0; index < this._items.length; index++) {
//             let item = this._items[index];
//             if (item.key == key && item.connection != null) {
//                 connection = item.connection;
//                 break;
//             }
//         }
//         callback(null, connection);
//     }

//     /**
//      * Resolves all connection parameters by their key.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - key               a key to uniquely identify the connections.
//      * - callback          callback function that receives found connections or error.
//      */
//     public resolveAll(correlationId: string, key: string, callback: (err: any, result: ConnectionParams[]) => void): void {
//         let connections: ConnectionParams[] = [];
//         for (let index = 0; index < this._items.length; index++) {
//             let item = this._items[index];
//             if (item.key == key && item.connection != null)
//                 connections.push(item.connection);
//         }
//         callback(null, connections);
//     }
// }