import 'package:pip_services3_commons/src/refer/Descriptor.dart';

import '../build/Factory.dart';
import './MemoryConfigReader.dart';
import './JsonConfigReader.dart';
import './YamlConfigReader.dart';


/// Creates [IConfigReader] components by their descriptors.
/// 
/// See [Factory]
/// See [MemoryConfigReader]
/// See [JsonConfigReader]
/// See [YamlConfigReader]
 
class DefaultConfigReaderFactory extends Factory {
	static final descriptor = new Descriptor("pip-services", "factory", "config-reader", "default", "1.0");
	static final MemoryConfigReaderDescriptor = new Descriptor("pip-services", "config-reader", "memory", "*", "1.0");
	static final JsonConfigReaderDescriptor = new Descriptor("pip-services", "config-reader", "json", "*", "1.0");
	static final YamlConfigReaderDescriptor = new Descriptor("pip-services", "config-reader", "yaml", "*", "1.0");
	
	
	/// Create a new instance of the factory.
	 
	DefaultConfigReaderFactory() :super() { 
		this.registerAsType(DefaultConfigReaderFactory.MemoryConfigReaderDescriptor, MemoryConfigReader);
		this.registerAsType(DefaultConfigReaderFactory.JsonConfigReaderDescriptor, JsonConfigReader);
		this.registerAsType(DefaultConfigReaderFactory.YamlConfigReaderDescriptor, YamlConfigReader);
	}
}
