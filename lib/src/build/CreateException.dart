import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Error raised when factory is not able to create requested component.
///
/// See [InternalException](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/InternalException-class.html) (in the PipServices 'Commons' package)
/// See [ApplicationException](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/ApplicationException-class.html) (in the PipServices 'Commons' package)
class CreateException extends InternalException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [correlation_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [messageOrLocator]  human-readable error or locator of the component that cannot be created.
  CreateException(String? correlationId, dynamic messageOrLocator)
      : super(
            correlationId,
            'CANNOT_CREATE',
            (messageOrLocator is String)
                ? messageOrLocator
                : 'Requested component ' +
                    messageOrLocator +
                    ' cannot be created') {
    if (!(messageOrLocator is String) && messageOrLocator != null) {
      withDetails('locator', messageOrLocator);
    }
  }
}
