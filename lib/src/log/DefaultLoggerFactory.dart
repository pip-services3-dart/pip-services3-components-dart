import 'package:pip_services3_commons/src/refer/Descriptor.dart';
import '../../pip_services3_components.dart';

/// Creates [ILogger] components by their descriptors.
///
/// See [Factory]
/// See [NullLogger]
/// See [ConsoleLogger]
/// See [CompositeLogger]
class DefaultLoggerFactory extends Factory {
  static final descriptor =
      Descriptor('pip-services', 'factory', 'logger', 'default', '1.0');
  static final NullLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'null', '*', '1.0');
  static final ConsoleLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'console', '*', '1.0');
  static final CompositeLoggerDescriptor =
      Descriptor('pip-services', 'logger', 'composite', '*', '1.0');

  /// Create a instance of the factory.
  DefaultLoggerFactory() : super() {
    registerAsType(DefaultLoggerFactory.NullLoggerDescriptor, NullLogger);
    registerAsType(DefaultLoggerFactory.ConsoleLoggerDescriptor, ConsoleLogger);
    registerAsType(
        DefaultLoggerFactory.CompositeLoggerDescriptor, CompositeLogger);
  }
}
