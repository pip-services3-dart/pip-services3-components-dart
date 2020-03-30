// /** @module log */
// import { StringConverter } from 'pip-services3-commons-node';

// import { LogLevel } from './LogLevel';
// import { Logger } from './Logger';
// import { LogLevelConverter } from './LogLevelConverter';

// /**
//  * Logger that writes log messages to console.
//  * 
//  * Errors are written to standard err stream
//  * and all other messages to standard out stream.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - level:             maximum log level to capture
//  * - source:            source (context) name
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:context-info:\*:\*:1.0</code>     (optional) [[ContextInfo]] to detect the context id and specify counters source
//  * 
//  * @see [[Logger]]
//  * 
//  * ### Example ###
//  * 
//  *     let logger = new ConsoleLogger();
//  *     logger.setLevel(LogLevel.debug);
//  *     
//  *     logger.error("123", ex, "Error occured: %s", ex.message);
//  *     logger.debug("123", "Everything is OK.");
//  */
// export class ConsoleLogger extends Logger {
    
//     /**
//      * Creates a new instance of the logger.
//      */
//     public constructor() {
//         super();
//     }

//     /**
//      * Writes a log message to the logger destination.
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
//      */
// 	protected write(level: LogLevel, correlationId: string, error: Error, message: string): void {
//         if (this.getLevel() < level) return;

//         let result: string = '[';
//         result += correlationId != null ? correlationId : "---";
//         result += ':';
//         result += LogLevelConverter.toString(level);
//         result += ':';
//         result += StringConverter.toString(new Date());
//         result += "] ";

//         result += message;

//         if (error != null) {
//             if (message.length == 0)
//                 result += "Error: ";
//             else
//                 result += ": ";

//             result += this.composeError(error);
//         }

//         if (level == LogLevel.Fatal || level == LogLevel.Error || level == LogLevel.Warn)
//             console.error(result);
//         else
//             console.log(result);
// 	}

// }
