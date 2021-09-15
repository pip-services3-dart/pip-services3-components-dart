import 'package:pip_services3_commons/pip_services3_commons.dart';

class OperationTrace {
  /// The time when operation was executed
  DateTime? time;

  /// The source (context name)
  String? source;

  /// The name of component
  String? component;

  /// The name of the executed operation
  String? operation;

  /// The transaction id to trace execution through call chain.
  String? correlation_id;

  /// The duration of the operation in milliseconds
  int? duration;

  ///
  /// The description of the captured error
  /// [ErrorDescription](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/ErrorDescription-class.html)
  /// [ApplicationException](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/ApplicationException-class.html)
  ErrorDescription? error;

  OperationTrace(this.time, this.source, this.component, this.operation,
      this.correlation_id, this.duration, this.error);
}
