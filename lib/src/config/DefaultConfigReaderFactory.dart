// /** @module config */
// import { Descriptor } from 'pip-services3-commons-node';

// import { Factory } from '../build/Factory';
// import { MemoryConfigReader } from './MemoryConfigReader';
// import { JsonConfigReader } from './JsonConfigReader';
// import { YamlConfigReader } from './YamlConfigReader';

// /**
//  * Creates [[IConfigReader]] components by their descriptors.
//  * 
//  * @see [[Factory]]
//  * @see [[MemoryConfigReader]]
//  * @see [[JsonConfigReader]]
//  * @see [[YamlConfigReader]]
//  */
// export class DefaultConfigReaderFactory extends Factory {
// 	public static readonly Descriptor = new Descriptor("pip-services", "factory", "config-reader", "default", "1.0");
// 	public static readonly MemoryConfigReaderDescriptor = new Descriptor("pip-services", "config-reader", "memory", "*", "1.0");
// 	public static readonly JsonConfigReaderDescriptor = new Descriptor("pip-services", "config-reader", "json", "*", "1.0");
// 	public static readonly YamlConfigReaderDescriptor = new Descriptor("pip-services", "config-reader", "yaml", "*", "1.0");
	
// 	/**
// 	 * Create a new instance of the factory.
// 	 */
// 	public constructor() {
//         super();
// 		this.registerAsType(DefaultConfigReaderFactory.MemoryConfigReaderDescriptor, MemoryConfigReader);
// 		this.registerAsType(DefaultConfigReaderFactory.JsonConfigReaderDescriptor, JsonConfigReader);
// 		this.registerAsType(DefaultConfigReaderFactory.YamlConfigReaderDescriptor, YamlConfigReader);
// 	}
// }
