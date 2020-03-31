
import 'package:pip_services3_commons/src/refer/Descriptor.dart';

import './NullLogger.dart';
import './ConsoleLogger.dart';
import './CompositeLogger.dart';
import '../build/Factory.dart';


/// Creates [ILogger] components by their descriptors.
/// 
/// See [Factory]
/// See [NullLogger]
/// See [ConsoleLogger]
/// See [CompositeLogger]
class DefaultLoggerFactory extends Factory {
	static final descriptor = new Descriptor("pip-services", "factory", "logger", "default", "1.0");
	static final NullLoggerDescriptor = new Descriptor("pip-services", "logger", "null", "*", "1.0");
	static final ConsoleLoggerDescriptor = new Descriptor("pip-services", "logger", "console", "*", "1.0");
	static final CompositeLoggerDescriptor = new Descriptor("pip-services", "logger", "composite", "*", "1.0");

	
	/// Create a new instance of the factory.
	 
	DefaultLoggerFactory() :super() {
		this.registerAsType(DefaultLoggerFactory.NullLoggerDescriptor, NullLogger);
		this.registerAsType(DefaultLoggerFactory.ConsoleLoggerDescriptor, ConsoleLogger);
		this.registerAsType(DefaultLoggerFactory.CompositeLoggerDescriptor, CompositeLogger);
	}
}