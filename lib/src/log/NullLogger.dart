// /** @module log */
// import { ILogger } from './ILogger';
// import { LogLevel } from './LogLevel';

// /**
//  * Dummy implementation of logger that doesn't do anything.
//  * 
//  * It can be used in testing or in situations when logger is required
//  * but shall be disabled.
//  * 
//  * @see [[ILogger]]
//  */
// export class NullLogger implements ILogger {

// 	/**
// 	 * Creates a new instance of the logger.
// 	 */
// 	public constructor() { }

// 	/**
//      * Gets the maximum log level. 
//      * Messages with higher log level are filtered out.
//      * 
//      * @returns the maximum log level.
//      */
// 	public getLevel(): LogLevel { return LogLevel.None; }

// 	/**
//      * Set the maximum log level.
//      * 
//      * @param value     a new maximum log level.
//      */
// 	public setLevel(value: LogLevel): void { }

// 	/**
//      * Logs a message at specified log level.
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public log(level: LogLevel, correlationId: string, error: Error, message: string, ...args: any[]): void { }

// 	/**
//      * Logs fatal (unrecoverable) message that caused the process to crash.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public fatal(correlationId: string, error: Error, message: string, ...args: any[]): void { }

//     /**
//      * Logs recoverable application error.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public error(correlationId: string, error: Error, message: string, ...args: any[]): void { }

//     /**
//      * Logs a warning that may or may not have a negative impact.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public warn(correlationId: string, message: string, ...args: any[]): void { }

//     /**
//      * Logs an important information message
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public info(correlationId: string, message: string, ...args: any[]): void { }

//     /**
//      * Logs a high-level debug information for troubleshooting.
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public debug(correlationId: string, message: string, ...args: any[]): void { }
	
//     /**
//      * Logs a low-level debug information for troubleshooting. 
//      * 
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param message           a human-readable message to log.
//      * @param args              arguments to parameterize the message. 
//      */
// 	public trace(correlationId: string, message: string, ...args: any[]): void { }
// }