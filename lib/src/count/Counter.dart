// /** @module count */
// import { CounterType } from './CounterType';

// /**
//  * Data object to store measurement for a performance counter.
//  * This object is used by [CachedCounters] to store counters.
//  */
// export class Counter {
//     /** The counter unique name */
//     public name: string;
//     /** The counter type that defines measurement algorithm */
//     public type: CounterType;
//     /** The last recorded value */
//     public last: number;
//     /** The total count */
//     public count: number;
//     /** The minimum value */
//     public min: number;
//     /** The maximum value */
//     public max: number;
//     /** The average value */ 
//     public average: number;
//     /** The recorded timestamp */
//     public time: Date;
    
//     /**
//      * Creates a instance of the data obejct
//      * 
//      * - name      a counter name.
//      * - type      a counter type.
//      */
//     public constructor(name: string, type: CounterType) {
//         this.name = name;
//         this.type = type;
//     }
// }