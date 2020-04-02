import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Error raised when factory is not able to create requested component.
///
/// See [https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/errors.internalexception.html InternalException] (in the PipServices 'Commons' package)
/// See [https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/errors.applicationexception.html ApplicationException] (in the PipServices 'Commons' package)
class CreateException extends InternalException {
  /// Creates an error instance and assigns its values.
  ///
  /// - [correlation_id]    (optional) a unique transaction id to trace execution through call chain.
  /// - [messageOrLocator]  human-readable error or locator of the component that cannot be created.
  CreateException(String correlationId, dynamic messageOrLocator)
      : super(
          correlationId,
          'CANNOT_CREATE',
          (messageOrLocator is String) 
            ? messageOrLocator 
            : 'Requested component ' + messageOrLocator + ' cannot be created') {
    if (!(messageOrLocator is String) && messageOrLocator != null) {
      withDetails('locator', messageOrLocator);
    }
  }
}
