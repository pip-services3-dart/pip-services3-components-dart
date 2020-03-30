// /** @module auth */
// import { Descriptor } from 'pip-services3-commons-node';

// import { Factory } from '../build/Factory';
// import { MemoryCredentialStore } from './MemoryCredentialStore';

// /**
//  * Creates [[ICredentialStore]] components by their descriptors.
//  * 
//  * @see [[IFactory]]
//  * @see [[ICredentialStore]]
//  * @see [[MemoryCredentialStore]]
//  */
// export class DefaultCredentialStoreFactory extends Factory {
// 	public static readonly Descriptor = new Descriptor("pip-services", "factory", "credential-store", "default", "1.0");
// 	public static readonly MemoryCredentialStoreDescriptor = new Descriptor("pip-services", "credential-store", "memory", "*", "1.0");
	
// 	/**
// 	 * Create a new instance of the factory.
// 	 */
// 	public constructor() {
//         super();
// 		this.registerAsType(DefaultCredentialStoreFactory.MemoryCredentialStoreDescriptor, MemoryCredentialStore);
// 	}	
// }
