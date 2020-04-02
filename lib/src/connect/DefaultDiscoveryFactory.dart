import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Creates [https://rawgit.com/pip-services-node/pip-services-components-node/master/doc/api/interfaces/connect.idiscovery.html IDiscovery] components by their descriptors.
///
/// See [Factory]
/// See [IDiscovery]
/// See [MemoryDiscovery]
class DefaultDiscoveryFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'discovery', 'default', '1.0');
  static final MemoryDiscoveryDescriptor =
      Descriptor('pip-services', 'discovery', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultDiscoveryFactory() : super() {
    registerAsType(
        DefaultDiscoveryFactory.MemoryDiscoveryDescriptor, MemoryDiscovery);
  }
}
