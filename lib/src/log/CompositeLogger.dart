// /** @module log */
// import { IReferences } from 'pip-services3-commons-node';
// import { IReferenceable } from 'pip-services3-commons-node';
// import { Descriptor } from 'pip-services3-commons-node';

// import { ILogger } from './ILogger';
// import { Logger } from './Logger';
// import { LogLevel } from './LogLevel';

// /**
//  * Aggregates all loggers from component references under a single component.
//  * 
//  * It allows to log messages and conveniently send them to multiple destinations. 
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:logger:\*:\*:1.0</code> 	(optional) [[ILogger]] components to pass log messages
//  * 
//  * @see [[ILogger]]
//  * 
//  * ### Example ###
//  * 
//  *     class MyComponent implements IConfigurable, IReferenceable {
//  *         private _logger: CompositeLogger = new CompositeLogger();
//  *     
//  *         public configure(config: ConfigParams): void {
//  *             this._logger.configure(config);
//  *             ...
//  *         }
//  *     
//  *         public setReferences(references: IReferences): void {
//  *             this._logger.setReferences(references);
//  *             ...
//  *         }
//  *     
//  *         public myMethod(string correlationId): void {
//  *             this._logger.debug(correlationId, "Called method mycomponent.mymethod");
//  *             ...
//  *         }
//  *     }
//  * 
//  */
// export class CompositeLogger extends Logger implements IReferenceable {
// 	private readonly _loggers: ILogger[] = [];

// 	/**
//      * Creates a new instance of the logger.
//      * 
// 	 * @param references 	references to locate the component dependencies. 
//      */
// 	public constructor(references: IReferences = null) {
// 		super();

// 		if (references)
// 			this.setReferences(references);
// 	}

// 	/**
// 	 * Sets references to dependent components.
// 	 * 
// 	 * @param references 	references to locate the component dependencies. 
//      */
// 	public setReferences(references: IReferences): void {
// 		super.setReferences(references);

// 		let loggers: any[] = references.getOptional<any>(new Descriptor(null, "logger", null, null, null));
//         for (var i = 0; i < loggers.length; i++) {
//             let logger: ILogger = loggers[i];

// 			// Todo: This doesn't work in TS. Redo...
//             if (logger != this as ILogger)
//                 this._loggers.push(logger);
//         }
// 	}

// 	/**
//      * Writes a log message to the logger destination(s).
//      * 
//      * @param level             a log level.
//      * @param correlationId     (optional) transaction id to trace execution through call chain.
//      * @param error             an error object associated with this message.
//      * @param message           a human-readable message to log.
// 	 */
// 	protected write(level: LogLevel, correlationId: string, error: Error, message: string): void {
// 		for (let index = 0; index < this._loggers.length; index++) 
// 			this._loggers[index].log(level, correlationId, error, message);
// 	}
// }