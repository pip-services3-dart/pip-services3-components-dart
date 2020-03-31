import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'dart:async';

/// Interface for configuration readers that retrieve configuration from various sources
/// and make it available for other components.
/// 
/// Some IConfigReader implementations may support configuration parameterization.
/// The parameterization allows to use configuration as a template and inject there dynamic values.
/// The values may come from application command like arguments or environment variables.
abstract class IConfigReader {
    
    /// Reads configuration and parameterize it with given values.
    /// 
    /// - correlationId     (optional) transaction id to trace execution through call chain.
    /// - parameters        values to parameters the configuration or null to skip parameterization.
    /// - callback          callback function that receives configuration or error.
   Future<ConfigParams> readConfig(String correlationId, ConfigParams parameters);
}