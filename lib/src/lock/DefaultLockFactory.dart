import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Creates [ILock] components by their descriptors.
///
/// See [Factory]
/// See [ILock]
/// See [MemoryLock]
/// See [NullLock]

class DefaultLockFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'lock', 'default', '1.0');
  static final NullLockDescriptor =
      Descriptor('pip-services', 'lock', 'null', '*', '1.0');
  static final MemoryLockDescriptor =
      Descriptor('pip-services', 'lock', 'memory', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultLockFactory() : super() {
    registerAsType(DefaultLockFactory.NullLockDescriptor, NullLock);
    registerAsType(DefaultLockFactory.MemoryLockDescriptor, MemoryLock);
  }
}
