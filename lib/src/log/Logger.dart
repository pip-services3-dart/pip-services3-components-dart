// /** @module log */
// /** @hidden */ 
// let util = require('util');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReferenceable } from 'pip-services3-commons-node';
// import { IReferences } from 'pip-services3-commons-node';
// import { Descriptor } from 'pip-services3-commons-node';

// import { IReconfigurable } from 'pip-services3-commons-node';
// import { ILogger } from './ILogger';
// import { LogLevel } from './LogLevel';
// import { LogLevelConverter } from './LogLevelConverter';
// import { ContextInfo } from '../info/ContextInfo';

// /**
//  * Abstract logger that captures and formats log messages.
//  * Child classes take the captured messages and write them to their specific destinations.
//  *
//  * ### Configuration parameters ###
//  * 
//  * Parameters to pass to the [[configure]] method for component configuration:
//  *  
//  * - level:             maximum log level to capture
//  * - source:            source (context) name
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:context-info:\*:\*:1.0</code>     (optional) [[ContextInfo]] to detect the context id and specify counters source
//  * 
//  * @see [[ILogger]]
//  */
// export abstract class Logger implements ILogger, IReconfigurable, IReferenceable {
//     protected _level: LogLevel = LogLevel.Info;
//     protected _source: string = null;

//     /**
//      * Creates a new instance of the logger.
//      */
//     protected constructor() { }

//     /**
//      * Configures component by passing configuration parameters.
//      * 
//      * @param config    configuration parameters to be set.
//      */
//     public configure(config: ConfigParams): void {
//         this._level = LogLevelConverter.toLogLevel(
//             config.getAsObject("level"),
//             this._level
//         );
//         this._source = config.getAsStringWithDefault("source", this._source);
//     }

//     /**
// 	 * Sets references to dependent components.
// 	 * 
// 	 * @param references 	references to locate the component dependencies. 
//      */
//     public setReferences(references: IReferences) {
//         let contextInfo = references.getOneOptional<ContextInfo>(
//             new Descriptor("pip-services", "context-info", "*", "*", "1.0"));
//         if (contextInfo != null && this._source == null) {
//             this._source = contextInfo.name;
//         }
//     }

//     /**
//      * Gets the maximum log level. 
//      * Messages with higher log level are filtered out.
//      * 
//      * @returns the maximum log level.
//      */
//     public getLevel(): LogLevel {
//         return this._level;
//     }

//     /**
//      * Set the maximum log level.
//      * 
//      * @param value     a new maximum log level.
//      */
//     public setLevel(value: LogLevel): void {
//         this._level = value;
//     }

//     /**
//      * Gets the source (context) name.
//      * 
//      * @returns the source (context) name.
//      */
//     public getSource(): string {
//         return this._source;
//     }

//     /**
//      * Sets the source (context) name.
//      * 
//      * @param value     a new source (context) name.
//      */
//     public setSource(value: string): void {
//         this._source = value;
//     }
    
//     /**
//      * Writes a log message to the logger destination.
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      */
//     protected abstract write(level: LogLevel, correlationId: string, error: Error, message: string): void;

//     /**
//      * Formats the log message and writes it to the logger destination.
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     protected formatAndWrite(level: LogLevel, correlationId: string, error: Error, message: string, ...args: any[]): void {
//         message = message != null ? message : "";
//         if (args != null && args.length > 0) {
//             // message = message.replace(/{(\d+)}/g, function (match, number) {
//             //     return typeof args[number] != 'undefined' ? args[number] : match;
//             // });
//             message = util.format(message, ...args);
//         }

//         this.write(level, correlationId, error, message);
//     }

//     /**
//      * Logs a message at specified log level.
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public log(level: LogLevel, correlationId: string, error: Error, message: string, ...args: any[]): void {
//         this.formatAndWrite(level, correlationId, error, message, ...args);
//     }

//     /**
//      * Logs fatal (unrecoverable) message that caused the process to crash.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public fatal(correlationId: string, error: Error, message: string, ...args: any[]): void {
//         this.formatAndWrite(LogLevel.Fatal, correlationId, error, message, ...args);
//     }

//     /**
//      * Logs recoverable application error.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public error(correlationId: string, error: Error, message: string, ...args: any[]): void {
//         this.formatAndWrite(LogLevel.Error, correlationId, error, message, ...args);
//     }

//     /**
//      * Logs a warning that may or may not have a negative impact.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public warn(correlationId: string, message: string, ...args: any[]): void {
//         this.formatAndWrite(LogLevel.Warn, correlationId, null, message, ...args);
//     }

//     /**
//      * Logs an important information message
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public info(correlationId: string, message: string, ...args: any[]): void {
//         this.formatAndWrite(LogLevel.Info, correlationId, null, message, ...args);
//     }

//     /**
//      * Logs a high-level debug information for troubleshooting.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public debug(correlationId: string, message: string, ...args: any[]): void {
//         this.formatAndWrite(LogLevel.Debug, correlationId, null, message, ...args);
//     }

//     /**
//      * Logs a low-level debug information for troubleshooting. 
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     public trace(correlationId: string, message: string, ...args: any[]): void {
//         this.formatAndWrite(LogLevel.Trace, correlationId, null, message, ...args);
//     }

//     /**
//      * Composes an human-readable error description
//      * 
//      * @param error     an error to format.
//      * @returns a human-reable error description.
//      */
//     protected composeError(error: Error): string {
//         let builder: string = "";

//         builder += error.message;

//         let appError: any = error;
//         if (appError.cause) {
//             builder += " Caused by: ";
//             builder += appError.cause;
//         }

//         if (error.stack) {
//             builder += " Stack trace: ";
//             builder += error.stack;
//         }

//         return builder;
//     }
// }