import "package:pip_services3_commons/src/refer/Descriptor.dart";
import '../build/Factory.dart';
import './NullCache.dart';
import './MemoryCache.dart';


/// Creates [ICache] components by their descriptors.
/// 
/// See [Factory]
/// See [ICache]
/// See [MemoryCache]
/// See [NullCache]
 
class DefaultCacheFactory extends Factory {
    static final  Descriptor descriptor = Descriptor("pip-services", "factory", "cache", "default", "1.0");
    static final  Descriptor NullCacheDescriptor =  Descriptor("pip-services", "cache", "null", "*", "1.0");
    static final  Descriptor MemoryCacheDescriptor =  Descriptor("pip-services", "cache", "memory", "*", "1.0");

	
	/// Create a new instance of the factory.
	 
	DefaultCacheFactory():super() {
		this.registerAsType(DefaultCacheFactory.MemoryCacheDescriptor, MemoryCache);
		this.registerAsType(DefaultCacheFactory.NullCacheDescriptor, NullCache);
	}
}
