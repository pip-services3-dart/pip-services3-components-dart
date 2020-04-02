import 'package:pip_services3_commons/src/refer/Descriptor.dart';
import '../../pip_services3_components.dart';

/// Creates information components by their descriptors.
///
/// See [IFactory]
/// See [ContextInfo]

class DefaultInfoFactory extends Factory {
  static final Descriptor descriptor =
       Descriptor('pip-services', 'factory', 'info', 'default', '1.0');
  static final Descriptor ContextInfoDescriptor =
       Descriptor('pip-services', 'context-info', 'default', '*', '1.0');
  static final Descriptor ContainerInfoDescriptor =
       Descriptor('pip-services', 'container-info', 'default', '*', '1.0');
  /// Create a new instance of the factory.

  DefaultInfoFactory() : super() {
    registerAsType(DefaultInfoFactory.ContextInfoDescriptor, ContextInfo);
    registerAsType(
        DefaultInfoFactory.ContainerInfoDescriptor, ContextInfo);
  }
}
