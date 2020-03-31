//  @module log 
// import { ConfigParams } from 'pip-services3-commons-node';
// import { ErrorDescription } from 'pip-services3-commons-node';
// import { ErrorDescriptionFactory } from 'pip-services3-commons-node';

// import { LogLevel } from './LogLevel';
// import { Logger } from './Logger';
// import { LogMessage } from './LogMessage';
// import { LogLevelConverter } from './LogLevelConverter';

// 
// /// Abstract logger that caches captured log messages in memory and periodically dumps them.
// /// Child classes implement saving cached messages to their specified destinations.
// /// 
// /// ### Configuration parameters ###
// /// 
// /// - level:             maximum log level to capture
// /// - source:            source (context) name
// /// - options:
// ///     - interval:        interval in milliseconds to save log messages (default: 10 seconds)
// ///     - max_cache_size:  maximum number of messages stored in this cache (default: 100)        
// /// 
// /// ### References ###
// /// 
// /// - \*:context-info:\*:\*:1.0     (optional) [ContextInfo] to detect the context id and specify counters source
// /// 
// /// See [ILogger]
// /// See [Logger]
// /// See [LogMessage]
//  
// export abstract class CachedLogger extends Logger {
//     protected _cache: LogMessage[] = [];
//     protected _updated: boolean = false;
//     protected _lastDumpTime: number = new Date().getTime();
//     protected _maxCacheSize: number = 100;
//     protected _interval: number = 10000;
    
//     
//     /// Creates a new instance of the logger.
//      
//     public constructor() {
//         super();
//     }

//     
//     /// Writes a log message to the logger destination.
//     /// 
//     /// - level             a log level.
//     /// - correlationId     (optional) transaction id to trace execution through call chain.
//     /// - error             an error object associated with this message.
//     /// - message           a human-readable message to log.
//      
// 	protected write(level: LogLevel, correlationId: string, error: Error, message: string): void {
// 		let errorDesc: ErrorDescription = error != null ? ErrorDescriptionFactory.create(error) : null;
// 		let logMessage: LogMessage = <LogMessage>{
//             time: new Date(),
//             level: LogLevelConverter.toString(level),
//             source: this._source,
//             correlation_id: correlationId,
//             error: errorDesc,
//             message: message
//         };
		
//         this._cache.push(logMessage);
		
// 		this.update();
// 	}

//     
//     /// Saves log messages from the cache.
//     /// 
//     /// - messages  a list with log messages
//     /// - callback  callback function that receives error or null for success.
//      
//     protected abstract save(messages: LogMessage[], callback: (err: any) => void): void;

//     
//     /// Configures component by passing configuration parameters.
//     /// 
//     /// - config    configuration parameters to be set.
//      
//     public configure(config: ConfigParams): void {
//         super.configure(config);
        
//         this._interval = config.getAsLongWithDefault("options.interval", this._interval);
//         this._maxCacheSize = config.getAsIntegerWithDefault("options.max_cache_size", this._maxCacheSize);
//     }
    
//     
//     /// Clears (removes) all cached log messages.
//      
//     public clear(): void {
//         this._cache = [];
// 	    this._updated = false;
//     }

//     
//     /// Dumps (writes) the currently cached log messages.
//     /// 
//     /// See [write]
//      
//     public dump(): void {
//         if (this._updated) {
//             if (!this._updated) return;
            
//             let messages = this._cache;
//             this._cache = [];
            
//             this.save(messages, (err) => {
//                 if (err) {
//                     // Adds messages back to the cache
//                     messages.push(...this._cache);
//                     this._cache = messages;

//                     // Truncate cache
//                     let deleteCount = this._cache.length - this._maxCacheSize;
//                     if (deleteCount > 0)
//                         this._cache.splice(0, deleteCount);
//                 }
//             });

//             this._updated = false;
//             this._lastDumpTime = new Date().getTime();
//         }
//     }

//     
//     /// Makes message cache as updated
//     /// and dumps it when timeout expires.
//     /// 
//     /// See [dump]
//      
//     protected update(): void {
//     	this._updated = true;
//     	let now = new Date().getTime();

//     	if (now > this._lastDumpTime + this._interval) {
//     		try {
//     			this.dump();
//     		} catch (ex) {
//     			// Todo: decide what to do
//     		}
//     	}
//     }
// }
