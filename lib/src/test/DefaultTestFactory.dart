
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';


/// Creates test components by their descriptors.
///
/// See [Factory]
/// See [Shutdown]

class DefaultTestFactory extends Factory {
	static final descriptor = new Descriptor('pip-services', 'factory', 'test', 'default', '1.0');
	static final ShutdownDescriptor = new Descriptor('pip-services', 'shutdown', '*', '*', '1.0');


	/// Create a new instance of the factory.

	DefaultTestFactory(): super() {
		this.registerAsType(DefaultTestFactory.ShutdownDescriptor, Shutdown);
	}
}
