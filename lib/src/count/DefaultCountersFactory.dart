import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Creates [ICounters] components by their descriptors.
///
/// See [Factory]
/// See [NullCounters]
/// See [LogCounters]
/// See [CompositeCounters]
class DefaultCountersFactory extends Factory {
  static final descriptor =
       Descriptor('pip-services', 'factory', 'counters', 'default', '1.0');
  static final NullCountersDescriptor =
       Descriptor('pip-services', 'counters', 'null', '*', '1.0');
  static final LogCountersDescriptor =
       Descriptor('pip-services', 'counters', 'log', '*', '1.0');
  static final CompositeCountersDescriptor =
       Descriptor('pip-services', 'counters', 'composite', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultCountersFactory() : super() {
   registerAsType(
        DefaultCountersFactory.NullCountersDescriptor, NullCounters);
   registerAsType(
        DefaultCountersFactory.LogCountersDescriptor, LogCounters);
   registerAsType(
        DefaultCountersFactory.CompositeCountersDescriptor, CompositeCounters);
  }
}
