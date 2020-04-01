import 'package:pip_services3_commons/src/refer/Descriptor.dart';
import '../../pip_services3_components.dart';

/// Creates information components by their descriptors.
///
/// See [IFactory]
/// See [ContextInfo]

class DefaultInfoFactory extends Factory {
  static final Descriptor descriptor =
      new Descriptor("pip-services", "factory", "info", "default", "1.0");
  static final Descriptor ContextInfoDescriptor =
      new Descriptor("pip-services", "context-info", "default", "*", "1.0");
  static final Descriptor ContainerInfoDescriptor =
      new Descriptor("pip-services", "container-info", "default", "*", "1.0");

  /// Create a new instance of the factory.

  DefaultInfoFactory() : super() {
    this.registerAsType(DefaultInfoFactory.ContextInfoDescriptor, ContextInfo);
    this.registerAsType(
        DefaultInfoFactory.ContainerInfoDescriptor, ContextInfo);
  }
}
