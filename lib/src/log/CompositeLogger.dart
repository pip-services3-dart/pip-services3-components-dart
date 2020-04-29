import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Aggregates all loggers from component references under a single component.
///
/// It allows to log messages and conveniently send them to multiple destinations.
///
/// ### References ###
///
/// - \*:logger:\*:\*:1.0 	(optional) [ILogger] components to pass log messages
///
/// See [ILogger]
///
/// ### Example ###
///
///      MyComponent implements IConfigurable, IReferenceable {
///          var _logger = new CompositeLogger();
///
///         void configure(ConfigParams config) {
///             _logger.configure(config);
///             ...
///         }
///
///         void setReferences(IReferences references) {
///             _logger.setReferences(references);
///             ...
///         }
///
///         myMethod(String correlationId) {
///             _logger.debug(correlationId, 'Called method mycomponent.mymethod');
///             ...
///         }
///     }
///

class CompositeLogger extends Logger implements IReferenceable {
  final _loggers = <ILogger>[];

  /// Creates a new instance of the logger.
  ///
  /// - references 	references to locate the component dependencies.

  CompositeLogger([IReferences references]) : super() {
    if (references != null) setReferences(references);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.

  @override
  void setReferences(IReferences references) {
    super.setReferences(references);

    var loggers = references
        .getOptional<dynamic>(Descriptor(null, 'logger', null, null, null));
    for (var i = 0; i < loggers.length; i++) {
      ILogger logger = loggers[i];

      // Todo: This doesn't work in TS. Redo...
      if (logger != this) _loggers.add(logger); //as ILogger
    }
  }

  /// Writes a log message to the logger destination(s).
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  @override
  void write(
      LogLevel level, String correlationId, Exception error, String message) {
    for (var index = 0; index < _loggers.length; index++) {
      _loggers[index].log(level, correlationId, error, message);
    }
  }
}
