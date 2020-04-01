import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Creates [ICache] components by their descriptors.
///
/// See [Factory]
/// See [ICache]
/// See [MemoryCache]
/// See [NullCache]

class DefaultCacheFactory extends Factory {
  static final Descriptor descriptor =
      new Descriptor("pip-services", "factory", "cache", "default", "1.0");
  static final Descriptor NullCacheDescriptor =
      new Descriptor("pip-services", "cache", "null", "*", "1.0");
  static final Descriptor MemoryCacheDescriptor =
      new Descriptor("pip-services", "cache", "memory", "*", "1.0");

  /// Create a new instance of the factory.

  DefaultCacheFactory() : super() {
    this.registerAsType(DefaultCacheFactory.MemoryCacheDescriptor, MemoryCache);
    this.registerAsType(DefaultCacheFactory.NullCacheDescriptor, NullCache);
  }
}
