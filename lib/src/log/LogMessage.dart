import 'package:pip_services3_commons/src/errors/ErrorDescription.dart';

/// Data object to store captured log messages.
/// This object is used by [CachedLogger].
// Todo: Make it JSON Serializable
class LogMessage {
  // The time then message was generated
  DateTime time;
  // The source (context name)
  String source;
  // This log level
  String level;
  // The transaction id to trace execution through call chain.
  String correlation_id;

  /// The description of the captured error
  ///
  /// [https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/errors.errordescription.html ErrorDescription]
  /// [https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/errors.applicationexception.html ApplicationException]

  ErrorDescription error;
  // The human-readable message
  String message;
}
