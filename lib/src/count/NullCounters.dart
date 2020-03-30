// /** @module count */
// import { Timing } from './Timing';
// import { ICounters } from './ICounters';

// /**
//  * Dummy implementation of performance counters that doesn't do anything.
//  * 
//  * It can be used in testing or in situations when counters is required
//  * but shall be disabled.
//  * 
//  * @see [[ICounters]]
//  */
// export class NullCounters implements ICounters {

// 	/**
// 	 * Creates a new instance of the counter.
// 	 */
// 	public NullCounters() { }

// 	/**
// 	 * Begins measurement of execution time interval.
// 	 * It returns [[Timing]] object which has to be called at
// 	 * [[Timing.endTiming]] to end the measurement and update the counter.
// 	 * 
// 	 * @param name 	a counter name of Interval type.
// 	 * @returns a [[Timing]] callback object to end timing.
//      */
// 	public beginTiming(name: string): Timing {
// 		return new Timing();
// 	}

// 	/**
// 	 * Calculates min/average/max statistics based on the current and previous values.
// 	 * 
// 	 * @param name 		a counter name of Statistics type
// 	 * @param value		a value to update statistics
// 	 */
// 	public stats(name: string, value: number): void { }

// 	/**
// 	 * Records the last calculated measurement value.
// 	 * 
// 	 * Usually this method is used by metrics calculated
// 	 * externally.
// 	 * 
// 	 * @param name 		a counter name of Last type.
// 	 * @param value		a last value to record.
// 	 */
// 	public last(name: string, value: number): void { }

// 	/**
// 	 * Records the current time as a timestamp.
// 	 * 
// 	 * @param name 		a counter name of Timestamp type.
// 	 */
// 	public timestampNow(name: string): void { }

// 	/**
// 	 * Records the given timestamp.
// 	 * 
// 	 * @param name 		a counter name of Timestamp type.
// 	 * @param value		a timestamp to record.
// 	 */
// 	public timestamp(name: string, value: Date): void { }

// 	/**
// 	 * Increments counter by 1.
// 	 * 
// 	 * @param name 		a counter name of Increment type.
// 	 */
// 	public incrementOne(name: string): void { }

// 	/**
// 	 * Increments counter by given value.
// 	 * 
// 	 * @param name 		a counter name of Increment type.
// 	 * @param value		a value to add to the counter.
// 	 */
// 	public increment(name: string, value: number): void { }
// }