import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:pip_services3_components/src/state/MemoryStateStore.dart';
import 'package:pip_services3_components/src/state/NullStateStore.dart';

/// Creates [IStateStore] components by their descriptors.
///
/// See: [Factory], [IStateStore], [MemoryStateStore], [NullStateStore]
class DefaultStateStoreFactory extends Factory {
  static var Desriptor =
      Descriptor('pip-services', 'factory', 'state-store', 'default', '1.0');
  static var NullStateStoreDescriptor =
      Descriptor('pip-services', 'state-store', 'null', '*', '1.0');
  static var MemoryStateStoreDescriptor =
      Descriptor('pip-services', 'state-store', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultStateStoreFactory() : super() {
    registerAsType(
        DefaultStateStoreFactory.MemoryStateStoreDescriptor, MemoryStateStore);
    registerAsType(
        DefaultStateStoreFactory.NullStateStoreDescriptor, NullStateStore);
  }
}
