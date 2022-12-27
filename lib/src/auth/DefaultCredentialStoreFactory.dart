import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Creates [ICredentialStore] components by their descriptors.
///
/// See [IFactory]
/// See [ICredentialStore]
/// See [MemoryCredentialStore]
class DefaultCredentialStoreFactory extends Factory {
  static final descriptor = Descriptor(
      'pip-services', 'factory', 'credential-store', 'default', '1.0');
  static final MemoryCredentialStoreDescriptor =
      Descriptor('pip-services', 'credential-store', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultCredentialStoreFactory() : super() {
    registerAsType(
        DefaultCredentialStoreFactory.MemoryCredentialStoreDescriptor,
        MemoryCredentialStore);
  }
}
