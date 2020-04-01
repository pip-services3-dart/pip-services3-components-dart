import "package:pip_services3_commons/pip_services3_commons.dart";
import '../../pip_services3_components.dart';

/// Creates [ILock] components by their descriptors.
///
/// See [Factory]
/// See [ILock]
/// See [MemoryLock]
/// See [NullLock]

class DefaultLockFactory extends Factory {
  static final descriptor =
      new Descriptor("pip-services", "factory", "lock", "default", "1.0");
  static final NullLockDescriptor =
      new Descriptor("pip-services", "lock", "null", "*", "1.0");
  static final MemoryLockDescriptor =
      new Descriptor("pip-services", "lock", "memory", "*", "1.0");

  /// Create a new instance of the factory.
  DefaultLockFactory() : super() {
    this.registerAsType(DefaultLockFactory.NullLockDescriptor, NullLock);
    this.registerAsType(DefaultLockFactory.MemoryLockDescriptor, MemoryLock);
  }
}
