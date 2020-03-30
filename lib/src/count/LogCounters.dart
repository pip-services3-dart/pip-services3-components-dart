// /** @module count */
// import { IReferenceable } from 'pip-services3-commons-node';
// import { IReferences } from 'pip-services3-commons-node';
// import { StringConverter } from 'pip-services3-commons-node';

// import { Counter } from './Counter';
// import { CachedCounters } from './CachedCounters';
// import { CompositeLogger } from '../log/CompositeLogger';

// /**
//  * Performance counters that periodically dumps counters measurements to logger.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - __options:__
//  *     - interval:          interval in milliseconds to save current counters measurements (default: 5 mins)
//  *     - reset_timeout:     timeout in milliseconds to reset the counters. 0 disables the reset (default: 0)
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:logger:\*:\*:1.0</code>           [ILogger] components to dump the captured counters
//  * - <code>\*:context-info:\*:\*:1.0</code>     (optional) [ContextInfo] to detect the context id and specify counters source
//  * 
//  * See [Counter]
//  * See [CachedCounters]
//  * See [CompositeLogger]
//  * 
//  * ### Example ###
//  * 
//  *     let counters = new LogCounters();
//  *     counters.setReferences(References.fromTuples(
//  *         new Descriptor("pip-services", "logger", "console", "default", "1.0"), new ConsoleLogger()
//  *     ));
//  *     
//  *     counters.increment("mycomponent.mymethod.calls");
//  *     let timing = counters.beginTiming("mycomponent.mymethod.exec_time");
//  *     try {
//  *         ...
//  *     } finally {
//  *         timing.endTiming();
//  *     }
//  *     
//  *     counters.dump();
//  */
// export class LogCounters extends CachedCounters implements IReferenceable {
//     private readonly _logger: CompositeLogger = new CompositeLogger();

//     /**
//      * Creates a new instance of the counters.
//      */
//     public LogCounters() { }

//     /**
// 	 * Sets references to dependent components.
// 	 * 
// 	 * - references 	references to locate the component dependencies. 
// 	 * 
//      */
//     public setReferences(references: IReferences): void {
//         this._logger.setReferences(references);
//     }

//     private counterToString(counter: Counter): string {
//         var result = "Counter " + counter.name + " { ";
//         result += "\"type\": " + counter.type;
//         if (counter.last != null)
//             result += ", \"last\": " + StringConverter.toString(counter.last);
//         if (counter.count != null)
//             result += ", \"count\": " + StringConverter.toString(counter.count);
//         if (counter.min != null)
//             result += ", \"min\": " + StringConverter.toString(counter.min);
//         if (counter.max != null)
//             result += ", \"max\": " + StringConverter.toString(counter.max);
//         if (counter.average != null)
//             result += ", \"avg\": " + StringConverter.toString(counter.average);
//         if (counter.time != null)
//             result += ", \"time\": " + StringConverter.toString(counter.time);
//         result += " }";
//         return result;
//     }

//     /**
//      * Saves the current counters measurements.
//      * 
//      * - counters      current counters measurements to be saves.
//      */
//     protected save(counters: Counter[]): void {
//         if (this._logger == null || counters == null)
//             return;

//         if (counters.length == 0) return;

//         counters.sort((c1, c2) => {
//             if (c1.name < c2.name) return -1;
//             if (c1.name > c2.name) return 1;
//             return 0;
//         });

//         for(var i = 0; i < counters.length; i++) {
//             this._logger.info(null, this.counterToString(counters[i]));
//         }
//     }

// }