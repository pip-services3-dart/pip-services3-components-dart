// /** @module count */
// import { Timing } from './Timing';

// /**
//  * Interface for performance counters that measure execution metrics.
//  * 
//  * The performance counters measure how code is performing:
//  * how fast or slow, how many transactions performed, how many objects
//  * are stored, what was the latest transaction time and so on.
//  * 
//  * They are critical to monitor and improve performance, scalability
//  * and reliability of code in production. 
//  */
// export interface ICounters {
// 	/**
// 	 * Begins measurement of execution time interval.
// 	 * It returns [[Timing]] object which has to be called at
// 	 * [[Timing.endTiming]] to end the measurement and update the counter.
// 	 * 
// 	 * @param name 	a counter name of Interval type.
// 	 * @returns a [[Timing]] callback object to end timing.
// 	 */
// 	beginTiming(name: string) : Timing;
	
// 	/**
// 	 * Calculates min/average/max statistics based on the current and previous values.
// 	 * 
// 	 * @param name 		a counter name of Statistics type
// 	 * @param value		a value to update statistics
// 	 */
// 	stats(name: string, value: number) : void;

// 	/**
// 	 * Records the last calculated measurement value.
// 	 * 
// 	 * Usually this method is used by metrics calculated
// 	 * externally.
// 	 * 
// 	 * @param name 		a counter name of Last type.
// 	 * @param value		a last value to record.
// 	 */
// 	last(name: string, value: number) : void;

// 	/**
// 	 * Records the current time as a timestamp.
// 	 * 
// 	 * @param name 		a counter name of Timestamp type.
// 	 */
// 	timestampNow(name: string) : void;

// 	/**
// 	 * Records the given timestamp.
// 	 * 
// 	 * @param name 		a counter name of Timestamp type.
// 	 * @param value		a timestamp to record.
// 	 */
// 	timestamp(name: string, value: Date) : void;
	
// 	/**
// 	 * Increments counter by 1.
// 	 * 
// 	 * @param name 		a counter name of Increment type.
// 	 */
// 	incrementOne(name: string) : void;

// 	/**
// 	 * Increments counter by given value.
// 	 * 
// 	 * @param name 		a counter name of Increment type.
// 	 * @param value		a value to add to the counter.
// 	 */
// 	increment(name: string, value: number) : void;
// }