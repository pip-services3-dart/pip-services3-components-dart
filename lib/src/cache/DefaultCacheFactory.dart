// /** @module cache */
// import { Descriptor } from 'pip-services3-commons-node';

// import { Factory } from '../build/Factory';
// import { NullCache } from './NullCache';
// import { MemoryCache } from './MemoryCache';

// /**
//  * Creates [ICache] components by their descriptors.
//  * 
//  * See [Factory]
//  * See [ICache]
//  * See [MemoryCache]
//  * See [NullCache]
//  */
// export class DefaultCacheFactory extends Factory {
//     public static readonly Descriptor: Descriptor = new Descriptor("pip-services", "factory", "cache", "default", "1.0");
//     public static readonly NullCacheDescriptor: Descriptor = new Descriptor("pip-services", "cache", "null", "*", "1.0");
//     public static readonly MemoryCacheDescriptor: Descriptor = new Descriptor("pip-services", "cache", "memory", "*", "1.0");

// 	/**
// 	 * Create a new instance of the factory.
// 	 */
// 	public constructor() {
//         super();
// 		this.registerAsType(DefaultCacheFactory.MemoryCacheDescriptor, MemoryCache);
// 		this.registerAsType(DefaultCacheFactory.NullCacheDescriptor, NullCache);
// 	}
// }
