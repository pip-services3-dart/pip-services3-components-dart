// /** @module count */

// /**
//  * Interface for a callback to end measurement of execution elapsed time.
//  * 
//  * See [Timing]
//  */
// export interface ITimingCallback {
//     /**
//      * Ends measurement of execution elapsed time and updates specified counter.
//      * 
//      * - name      a counter name
//      * - elapsed   execution elapsed time in milliseconds to update the counter.
//      * 
//      * See [Timing.endTiming]
//      */
//     endTiming(name: string, elapsed: number): void;
// }