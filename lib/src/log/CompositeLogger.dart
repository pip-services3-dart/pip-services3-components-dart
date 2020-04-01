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
///     class MyComponent implements IConfigurable, IReferenceable {
///         private _logger: CompositeLogger = new CompositeLogger();
///
///         public configure(config: ConfigParams): void {
///             this._logger.configure(config);
///             ...
///         }
///
///         public setReferences(references: IReferences): void {
///             this._logger.setReferences(references);
///             ...
///         }
///
///         public myMethod(string correlationId): void {
///             this._logger.debug(correlationId, "Called method mycomponent.mymethod");
///             ...
///         }
///     }
///

class CompositeLogger extends Logger implements IReferenceable {
  final List<ILogger> _loggers = List<ILogger>();

  /// Creates a new instance of the logger.
  ///
  /// - references 	references to locate the component dependencies.

  CompositeLogger([IReferences references = null]) : super() {
    if (references != null) this.setReferences(references);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.

  void setReferences(IReferences references) {
    super.setReferences(references);

    List loggers = references
        .getOptional<dynamic>(new Descriptor(null, "logger", null, null, null));
    for (var i = 0; i < loggers.length; i++) {
      ILogger logger = loggers[i];

      // Todo: This doesn't work in TS. Redo...
      if (logger != this as ILogger) this._loggers.add(logger);
    }
  }

  /// Writes a log message to the logger destination(s).
  ///
  /// - level             a log level.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - error             an error object associated with this message.
  /// - message           a human-readable message to log.
  @override
  void write(LogLevel level, String correlationId, ApplicationException error,
      String message) {
    for (var index = 0; index < this._loggers.length; index++)
      this._loggers[index].log(level, correlationId, error, message, []);
  }
}
