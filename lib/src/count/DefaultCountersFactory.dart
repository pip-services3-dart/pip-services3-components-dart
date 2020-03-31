
import 'package:pip_services3_commons/src/refer/Descriptor.dart';

import './NullCounters.dart';
import './LogCounters.dart';
import './CompositeCounters.dart';
import '../build/Factory.dart';


/// Creates [ICounters] components by their descriptors.
/// 
/// See [Factory]
/// See [NullCounters]
/// See [LogCounters]
/// See [CompositeCounters]

class DefaultCountersFactory extends Factory {
	static final descriptor = new Descriptor("pip-services", "factory", "counters", "default", "1.0");
	static final NullCountersDescriptor = new Descriptor("pip-services", "counters", "null", "*", "1.0");
	static final LogCountersDescriptor = new Descriptor("pip-services", "counters", "log", "*", "1.0");
	static final CompositeCountersDescriptor = new Descriptor("pip-services", "counters", "composite", "*", "1.0");

	
	/// Create a new instance of the factory.
	 
	DefaultCountersFactory(): super() {
		this.registerAsType(DefaultCountersFactory.NullCountersDescriptor, NullCounters);
		this.registerAsType(DefaultCountersFactory.LogCountersDescriptor, LogCounters);
		this.registerAsType(DefaultCountersFactory.CompositeCountersDescriptor, CompositeCounters);
	}
}