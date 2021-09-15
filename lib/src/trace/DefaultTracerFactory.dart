import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/src/build/Factory.dart';

import 'CompositeTracer.dart';
import 'LogTracer.dart';
import 'NullTracer.dart';

/// Creates [ITracer] components by their descriptors.
///
/// See [Factory]
/// See [NullTracer]
/// See [ConsoleTracer]
/// See [CompositeTracer]
///
class DefaultTracerFactory extends Factory {
  static final NullTracerDescriptor =
      Descriptor('pip-services', 'tracer', 'null', '*', '1.0');
  static final LogTracerDescriptor =
      Descriptor('pip-services', 'tracer', 'log', '*', '1.0');
  static final CompositeTracerDescriptor =
      Descriptor('pip-services', 'tracer', 'composite', '*', '1.0');

  /// Create a new instance of the factory.
  DefaultTracerFactory() : super() {
    registerAsType(DefaultTracerFactory.NullTracerDescriptor, NullTracer);
    registerAsType(DefaultTracerFactory.LogTracerDescriptor, LogTracer);
    registerAsType(
        DefaultTracerFactory.CompositeTracerDescriptor, CompositeTracer);
  }
}
