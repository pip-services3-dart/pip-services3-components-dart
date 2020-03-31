import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_commons/src/config/IReconfigurable.dart';
import './IConfigReader.dart';
import 'dart:html';
import 'package:handlebars2/handlebars2.dart' as handlebars;
import 'dart:async';

/// Config reader that stores configuration in memory.
///
/// The reader supports parameterization using Handlebars
/// template engine: [https://handlebarsjs.com]
///
/// ### Configuration parameters ###
///
/// The configuration parameters are the configuration template
///
/// See [IConfigReader]
///
/// ### Example ####
///
///     var config = ConfigParams.fromTuples(
///         "connection.host", "{{SERVICE_HOST}}",
///         "connection.port", "{{SERVICE_PORT}}{{^SERVICE_PORT}}8080{{/SERVICE_PORT}}"
///     );
///
///     var configReader = new MemoryConfigReader();
///     configReader.configure(config);
///
///     var parameters = ConfigParams.fromValue(process.env);
///
///     configReader.readConfig("123", parameters, (err, config) => {
///         // Possible result: connection.host=10.1.1.100;connection.port=8080
///     });
///

class MemoryConfigReader implements IConfigReader, IReconfigurable {
  ConfigParams _config = new ConfigParams();

  /// Creates a new instance of config reader.
  ///
  /// - config        (optional) component configuration parameters

  MemoryConfigReader([ConfigParams config = null]) {
    this._config = config;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.

  void configure(ConfigParams config) {
    this._config = config;
  }

  /// Reads configuration and parameterize it with given values.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - parameters        values to parameters the configuration or null to skip parameterization.
  /// - callback          callback function that receives configuration or error.

  Future<ConfigParams> readConfig(
      String correlationId, ConfigParams parameters) {
    return Future<ConfigParams>(() {
      if (parameters != null) {
        var config = new ConfigParams(this._config).toString();
        var template = handlebars.compile(config);
        config = template(parameters);
        return ConfigParams.fromString(config);
      } else {
        var config = new ConfigParams(this._config);
        ;
        return config;
      }
    });
  }
}
