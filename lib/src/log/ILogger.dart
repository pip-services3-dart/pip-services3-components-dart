// /** @module log */
// import { LogLevel } from './LogLevel';

// // Todo: solve issue with overloaded methods. Look at Python implementation
// /**
//  * Interface for logger components that capture execution log messages.
//  */
// export interface ILogger {
//     /**
//      * Gets the maximum log level. 
//      * Messages with higher log level are filtered out.
//      * 
//      * @returns the maximum log level.
//      */
//     getLevel(): LogLevel;
    
//     /**
//      * Set the maximum log level.
//      * 
//      * @param value     a new maximum log level.
//      */
//     setLevel(value: LogLevel): void;
    
//     /**
//      * Logs a message at specified log level.
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     log(level: LogLevel, correlationId: string, error: Error, message: string, ...args: any[]) : void;

//     /**
//      * Logs fatal (unrecoverable) message that caused the process to crash.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     fatal(correlationId: string, error: Error, message: string, ...args: any[]) : void;
//     // Todo: these overloads are not supported in TS
//     //fatal(correlationId: string, error: Error) : void;
//     //fatal(correlationId: string, message: string, ...args: any[]) : void;

//     /**
//      * Logs recoverable application error.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     error(correlationId: string, error: Error, message: string, ...args: any[]) : void;
//     // Todo: these overloads are not supported in TS
//     //error(correlationId: string, error: Error) : void;
//     //error(correlationId: string, message: string, ...args: any[]) : void;    

//     /**
//      * Logs a warning that may or may not have a negative impact.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     warn(correlationId: string, message: string, ...args: any[]) : void;

//     /**
//      * Logs an important information message
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     info(correlationId: string, message: string, ...args: any[]) : void;

//     /**
//      * Logs a high-level debug information for troubleshooting.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     debug(correlationId: string, message: string, ...args: any[]) : void;

//     /**
//      * Logs a low-level debug information for troubleshooting. 
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
//     trace(correlationId: string, message: string, ...args: any[]) : void;
// }