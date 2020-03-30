// /** @module count */
// import { IReferenceable } from 'pip-services3-commons-node';
// import { IReferences } from 'pip-services3-commons-node';
// import { Descriptor } from 'pip-services3-commons-node';

// import { ICounters } from './ICounters';
// import { Timing } from './Timing';
// import { ITimingCallback } from './ITimingCallback';

// /**
//  * Aggregates all counters from component references under a single component.
//  * 
//  * It allows to capture metrics and conveniently send them to multiple destinations. 
//  * 
//  * ### References ###
//  * 
//  * - <code>\*:counters:\*:\*:1.0</code>     (optional) [[ICounters]] components to pass collected measurements
//  * 
//  * @see [[ICounters]]
//  * 
//  * ### Example ###
//  * 
//  *     class MyComponent implements IReferenceable {
//  *         private _counters: CompositeCounters = new CompositeCounters();
//  *         
//  *         public setReferences(references: IReferences): void {
//  *             this._counters.setReferences(references);
//  *             ...
//  *         }
//  *         
//  *         public myMethod(): void {
//  *             this._counters.increment("mycomponent.mymethod.calls");
//  *             var timing = this._counters.beginTiming("mycomponent.mymethod.exec_time");
//  *             try {
//  *                 ...
//  *             } finally {
//  *                 timing.endTiming();
//  *             }
//  *         }
//  *     }
//  * 
//  */
// export class CompositeCounters implements ICounters, ITimingCallback, IReferenceable {
//     protected readonly _counters: ICounters[] = [];

//     /**
//      * Creates a new instance of the counters.
//      * 
// 	 * @param references 	references to locate the component dependencies. 
//      */
//     public CompositeCounters(references: IReferences = null) {
//         if (references != null)
//             this.setReferences(references);
//     }

//     /**
// 	 * Sets references to dependent components.
// 	 * 
// 	 * @param references 	references to locate the component dependencies. 
//      */
//     public setReferences(references: IReferences): void {
//         var counters = references.getOptional<ICounters>(new Descriptor(null, "counters", null, null, null));
//         for (let i = 0; i < counters.length; i++) {
//             let counter: ICounters = counters[i];

//             if (counter != this as ICounters)
//                 this._counters.push(counter);
//         }
//     }

//     /**
// 	 * Begins measurement of execution time interval.
// 	 * It returns [[Timing]] object which has to be called at
// 	 * [[Timing.endTiming]] to end the measurement and update the counter.
// 	 * 
// 	 * @param name 	a counter name of Interval type.
// 	 * @returns a [[Timing]] callback object to end timing.
//      */
//     public beginTiming(name: string): Timing {
//         return new Timing(name, this);
//     }

//     /**
//      * Ends measurement of execution elapsed time and updates specified counter.
//      * 
//      * @param name      a counter name
//      * @param elapsed   execution elapsed time in milliseconds to update the counter.
//      * 
//      * @see [[Timing.endTiming]]
//      */
//     public endTiming(name: string, elapsed: number): void {
//         for (let i = 0; i < this._counters.length; i++) {
//             let counter: any = this._counters[i];
//             var callback = counter as ITimingCallback;
//             if (callback != null)
//                 callback.endTiming(name, elapsed);
//         }
//     }

//     /**
// 	 * Calculates min/average/max statistics based on the current and previous values.
// 	 * 
// 	 * @param name 		a counter name of Statistics type
// 	 * @param value		a value to update statistics
// 	 */
//     public stats(name: string, value: number): void {
//         for (let i = 0; i < this._counters.length; i++)
//             this._counters[i].stats(name, value);
//     }

//     /**
// 	 * Records the last calculated measurement value.
// 	 * 
// 	 * Usually this method is used by metrics calculated
// 	 * externally.
// 	 * 
// 	 * @param name 		a counter name of Last type.
// 	 * @param value		a last value to record.
// 	 */
//     public last(name: string, value: number): void {
//         for (let i = 0; i < this._counters.length; i++)
//             this._counters[i].last(name, value);
//     }

//     /**
// 	 * Records the current time as a timestamp.
// 	 * 
// 	 * @param name 		a counter name of Timestamp type.
// 	 */
//     public timestampNow(name: string): void {
//         this.timestamp(name, new Date());
//     }

//     /**
// 	 * Records the given timestamp.
// 	 * 
// 	 * @param name 		a counter name of Timestamp type.
// 	 * @param value		a timestamp to record.
// 	 */
//     public timestamp(name: string, value: Date): void {
//         for (let i = 0; i < this._counters.length; i++)
//             this._counters[i].timestamp(name, value);
//     }

//     /**
// 	 * Increments counter by 1.
// 	 * 
// 	 * @param name 		a counter name of Increment type.
// 	 */
//     public incrementOne(name: string): void {
//         this.increment(name, 1);
//     }

//     /**
// 	 * Increments counter by given value.
// 	 * 
// 	 * @param name 		a counter name of Increment type.
// 	 * @param value		a value to add to the counter.
// 	 */
//     public increment(name: string, value: number): void {
//         if (!name)
//             throw new Error("Name cannot be null");

//         for (let i = 0; i < this._counters.length; i++)
//             this._counters[i].increment(name, value);
//     }
// }