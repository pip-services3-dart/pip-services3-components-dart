import 'package:pip_services3_commons/pip_services3_commons.dart';
import './log/CompositeLogger.dart';
import './count/CompositeCounters.dart';

/// Abstract component that supportes configurable dependencies, logging
/// and performance counters.
///
/// ### Configuration parameters ###
///
/// - __dependencies:__
///     - [dependency name 1]: Dependency 1 locator (descriptor)
///     - ...
///     - [dependency name N]: Dependency N locator (descriptor)
///
/// ### References ###
///
/// - \*:counters:\*:\*:1.0     (optional) [ICounters] components to pass collected measurements
/// - \*:logger:\*:\*:1.0       (optional) [ILogger] components to pass log messages
/// - ...                                    References must match configured dependencies.

class Component implements IConfigurable, IReferenceable {
  DependencyResolver dependencyResolver = DependencyResolver();
  CompositeLogger logger = CompositeLogger();
  CompositeCounters counters = CompositeCounters();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    dependencyResolver.configure(config);
    logger.configure(config);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    dependencyResolver.setReferences(references);
    logger.setReferences(references);
    counters.setReferences(references);
  }
}
