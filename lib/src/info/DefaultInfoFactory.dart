// /** @module info */
// import { Descriptor } from 'pip-services3-commons-node';

// import { Factory } from '../build/Factory';
// import { ContextInfo } from './ContextInfo';

// /**
//  * Creates information components by their descriptors.
//  * 
//  * See [IFactory]
//  * See [ContextInfo]
//  */
// export class DefaultInfoFactory extends Factory {
// 	public static readonly Descriptor: Descriptor = new Descriptor("pip-services", "factory", "info", "default", "1.0");
// 	public static readonly ContextInfoDescriptor: Descriptor = new Descriptor("pip-services", "context-info", "default", "*", "1.0");
// 	public static readonly ContainerInfoDescriptor: Descriptor = new Descriptor("pip-services", "container-info", "default", "*", "1.0");
	
// 	/**
// 	 * Create a new instance of the factory.
// 	 */
// 	public constructor() {
// 		super();
// 		this.registerAsType(DefaultInfoFactory.ContextInfoDescriptor, ContextInfo);
// 		this.registerAsType(DefaultInfoFactory.ContainerInfoDescriptor, ContextInfo);
// 	}
// }
