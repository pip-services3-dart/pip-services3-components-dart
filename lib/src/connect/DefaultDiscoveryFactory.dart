
import 'package:pip_services3_commons/src/refer/Descriptor.dart';

import '../build/Factory.dart';
import './MemoryDiscovery.dart';


/// Creates [https://rawgit.com/pip-services-node/pip-services-components-node/master/doc/api/interfaces/connect.idiscovery.html IDiscovery] components by their descriptors.
/// 
/// See [Factory]
/// See [IDiscovery]
/// See [MemoryDiscovery]

class DefaultDiscoveryFactory extends Factory {
	 static final descriptor = new Descriptor("pip-services", "factory", "discovery", "default", "1.0");
	 static final MemoryDiscoveryDescriptor = new Descriptor("pip-services", "discovery", "memory", "*", "1.0");
	
	/// Create a new instance of the factory.

	DefaultDiscoveryFactory(): super() {
		this.registerAsType(DefaultDiscoveryFactory.MemoryDiscoveryDescriptor, MemoryDiscovery);
	}	
}
