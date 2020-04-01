import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_commons/src/config/IConfigurable.dart';
import 'package:pip_services3_commons/src/refer/IReferences.dart';
import 'package:pip_services3_commons/src/refer/IReferenceable.dart';
import 'package:pip_services3_commons/src/refer/DependencyResolver.dart';
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
  DependencyResolver _dependencyResolver = new DependencyResolver();
  CompositeLogger _logger = new CompositeLogger();
  CompositeCounters _counters = new CompositeCounters();

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    this._dependencyResolver.configure(config);
    this._logger.configure(config);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  void setReferences(IReferences references) {
    this._dependencyResolver.setReferences(references);
    this._logger.setReferences(references);
    this._counters.setReferences(references);
  }
}
