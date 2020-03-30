// /** @module connect */
// import { ConfigParams } from 'pip-services3-commons-node';
// import { StringValueMap } from 'pip-services3-commons-node';

// /**
//  * Contains connection parameters to connect to external services.
//  * They are used together with credential parameters, but usually stored
//  * separately from more protected sensitive values.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - discovery_key: key to retrieve parameters from discovery service
//  * - protocol:      connection protocol like http, https, tcp, udp
//  * - host:          host name or IP address
//  * - port:          port number
//  * - uri:           resource URI or connection string with all parameters in it
//  * 
//  * In addition to standard parameters ConnectionParams may contain any number of custom parameters
//  * 
//  * See [https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/config.configparams.html ConfigParams]
//  * See [CredentialParams]
//  * See [ConnectionResolver]
//  * See [IDiscovery]
//  * 
//  * ### Example ###
//  * 
//  * Example ConnectionParams object usage:
//  * 
//  *     let connection = ConnectionParams.fromTuples(
//  *         "protocol", "http",
//  *         "host", "10.1.1.100",
//  *         "port", "8080",
//  *         "cluster", "mycluster"
//  *     );
//  *     
//  *     let host = connection.getHost();                             // Result: "10.1.1.100"
//  *     let port = connection.getPort();                             // Result: 8080
//  *     let cluster = connection.getAsNullableString("cluster");     // Result: "mycluster"   
//  */
// export class ConnectionParams extends ConfigParams {

//     /**
// 	 * Creates a new connection parameters and fills it with values.
//      * 
// 	 * - values 	(optional) an object to be converted into key-value pairs to initialize this connection.
//      */
//     public constructor(values: any = null) {
//         super(values);
//     }

//     /**
//      * Checks if these connection parameters shall be retrieved from [DiscoveryService].
//      * The connection parameters are redirected to [DiscoveryService] when discovery_key parameter is set.
//      * 
//      * Return     true if connection shall be retrieved from [DiscoveryService]
//      * 
//      * See [getDiscoveryKey]
//      */
//     public useDiscovery(): boolean {
//         return super.getAsNullableString("discovery_key") != null;
//     }

//     /**
//      * Gets the key to retrieve this connection from [DiscoveryService].
//      * If this key is null, than all parameters are already present.
//      * 
//      * Return     the discovery key to retrieve connection.
//      * 
//      * See [useDiscovery]
//      */
//     public getDiscoveryKey(): string {
//         return super.getAsString("discovery_key");
//     }

//     /**
//      * Sets the key to retrieve these parameters from [DiscoveryService].
//      * 
//      * - value     a new key to retrieve connection.
//      */
//     public setDiscoveryKey(value: string): void {
//         return super.put("discovery_key", value);
//     }

//     /**
//      * Gets the connection protocol.
//      * 
//      * - defaultValue  (optional) the default protocol
//      * Return             the connection protocol or the default value if it's not set.
//      */
//     public getProtocol(defaultValue: string = null): string {
//         return super.getAsStringWithDefault("protocol", defaultValue);
//     }

//     /**
//      * Sets the connection protocol.
//      * 
//      * - value     a new connection protocol.
//      */
//     public setProtocol(value: string): void {
//         return super.put("protocol", value);
//     }

//     /**
//      * Gets the host name or IP address.
//      * 
//      * Return     the host name or IP address.
//      */
//     public getHost(): string {
//         let host: string = super.getAsNullableString("host");
//         host = host || super.getAsNullableString("ip");
//         return host;
//     }

//     /**
//      * Sets the host name or IP address.
//      * 
//      * - value     a new host name or IP address.
//      */
//     public setHost(value: string): void {
//         return super.put("host", value);
//     }

//     /**
//      * Gets the port number.
//      * 
//      * Return the port number.
//      */
//     public getPort(): number {
//         return super.getAsInteger("port");
//     }

//     /**
//      * Sets the port number.
//      * 
//      * - value     a new port number.
//      * 
//      * See [getHost]
//      */
//     public setPort(value: number): void {
//         return super.put("port", value);
//     }

//     /**
//      * Gets the resource URI or connection string.
//      * Usually it includes all connection parameters in it.
//      * 
//      * Return the resource URI or connection string.
//      */
//     public getUri(): string {
//         return super.getAsString("uri");
//     }

//     /**
//      * Sets the resource URI or connection string.
//      * 
//      * - value     a new resource URI or connection string.
//      */
//     public setUri(value: string): void {
//         return super.put("uri", value);
//     }

//     /**
// 	 * Creates a new ConnectionParams object filled with key-value pairs serialized as a string.
// 	 * 
// 	 * - line 		a string with serialized key-value pairs as "key1=value1;key2=value2;..."
// 	 * 					Example: "Key1=123;Key2=ABC;Key3=2016-09-16T00:00:00.00Z"
// 	 * Return			a new ConnectionParams object.
// 	 * 
// 	 * See [StringValueMap.fromString]
//      */
//     public static fromString(line: string): ConnectionParams {
//         let map: StringValueMap = StringValueMap.fromString(line);
//         return new ConnectionParams(map);
//     }

//     /**
// 	 * Creates a new ConnectionParams object filled with provided key-value pairs called tuples.
// 	 * Tuples parameters contain a sequence of key1, value1, key2, value2, ... pairs.
// 	 * 
// 	 * - tuples	the tuples to fill a new ConnectionParams object.
// 	 * Return			a new ConnectionParams object.
// 	 */
// 	public static fromTuples(...tuples: any[]): ConnectionParams {
// 		let map = StringValueMap.fromTuplesArray(tuples);
// 		return new ConnectionParams(map);
//     }

//     /**
// 	 * Retrieves all ConnectionParams from configuration parameters
//      * from "connections" section. If "connection" section is present instead,
//      * than it returns a list with only one ConnectionParams.
// 	 * 
// 	 * - config 	a configuration parameters to retrieve connections
// 	 * Return			a list of retrieved ConnectionParams
// 	 */
//     public static manyFromConfig(config: ConfigParams): ConnectionParams[] {
//         let result: ConnectionParams[] = [];
//         let connections: ConfigParams = config.getSection("connections");

//         if (connections.length() > 0) {
//             let connectionSections: string[] = connections.getSectionNames();
//             for (let index = 0; index < connectionSections.length; index++) {
//                 let connection: ConfigParams = connections.getSection(connectionSections[index]);
//                 result.push(new ConnectionParams(connection));
//             }
//         } else {
//             let connection: ConfigParams = config.getSection("connection");
//             if (connection.length() > 0)
//                 result.push(new ConnectionParams(connection));
//         }

//         return result;
//     }

//     /**
// 	 * Retrieves a single ConnectionParams from configuration parameters
//      * from "connection" section. If "connections" section is present instead,
//      * then is returns only the first connection element.
// 	 * 
// 	 * - config 	ConnectionParams, containing a section named "connection(s)".
// 	 * Return			the generated ConnectionParams object.
// 	 * 
// 	 * See [manyFromConfig]
// 	 */
//     public static fromConfig(config: ConfigParams): ConnectionParams {
//         let connections: ConnectionParams[] = this.manyFromConfig(config);
//         return connections.length > 0 ? connections[0] : null;
//     }

// }