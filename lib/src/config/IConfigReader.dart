import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Interface for configuration readers that retrieve configuration from various sources
/// and make it available for other components.
///
/// Some IConfigReader implementations may support configuration parameterization.
/// The parameterization allows to use configuration as a template and inject there dynamic values.
/// The values may come from application command like arguments or environment variables.
abstract class IConfigReader {
  /// Reads configuration and parameterize it with given values.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Return            Future that receives configuration
  /// Throws error.
  Future<ConfigParams> readConfig(
      String correlationId, ConfigParams parameters);
}
