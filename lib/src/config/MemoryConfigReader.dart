// /** @module config */
// /** @hidden */ 
// let _ = require('lodash');
// let handlebars = require('handlebars');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReconfigurable } from 'pip-services3-commons-node';

// import { IConfigReader } from './IConfigReader';

// /**
//  * Config reader that stores configuration in memory.
//  * 
//  * The reader supports parameterization using Handlebars
//  * template engine: [https://handlebarsjs.com]
//  * 
//  * ### Configuration parameters ###
//  * 
//  * The configuration parameters are the configuration template
//  * 
//  * See [IConfigReader]
//  * 
//  * ### Example ####
//  * 
//  *     let config = ConfigParams.fromTuples(
//  *         "connection.host", "{{SERVICE_HOST}}",
//  *         "connection.port", "{{SERVICE_PORT}}{{^SERVICE_PORT}}8080{{/SERVICE_PORT}}"
//  *     );
//  *     
//  *     let configReader = new MemoryConfigReader();
//  *     configReader.configure(config);
//  *     
//  *     let parameters = ConfigParams.fromValue(process.env);
//  *     
//  *     configReader.readConfig("123", parameters, (err, config) => {
//  *         // Possible result: connection.host=10.1.1.100;connection.port=8080
//  *     });
//  * 
//  */
// export class MemoryConfigReader implements IConfigReader, IReconfigurable {
//     protected _config: ConfigParams = new ConfigParams();

//     /**
//      * Creates a new instance of config reader.
//      * 
//      * - config        (optional) component configuration parameters
//      */
//     public constructor(config: ConfigParams = null) {
//         this._config = config;
//     }

//     /**
//      * Configures component by passing configuration parameters.
//      * 
//      * - config    configuration parameters to be set.
//      */
//     public configure(config: ConfigParams): void {
//         this._config = config;
//     }

//     /**
//      * Reads configuration and parameterize it with given values.
//      * 
//      * - correlationId     (optional) transaction id to trace execution through call chain.
//      * - parameters        values to parameters the configuration or null to skip parameterization.
//      * - callback          callback function that receives configuration or error.
//      */
//     public readConfig(correlationId: string, parameters: ConfigParams,
//         callback: (err: any, config: ConfigParams) => void): void {
//         if (parameters != null) {
//             let config = new ConfigParams(this._config).toString();
//             let template = handlebars.compile(config);
//             config = template(parameters);
//             callback(null, ConfigParams.fromString(config));
//         } else {
//             let config = new ConfigParams(this._config);;
//             callback(null, config);
//         }
//     }

// }