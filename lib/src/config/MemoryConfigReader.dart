import 'dart:async';
import 'package:mustache_template/mustache.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Config reader that stores configuration in memory.
///
/// The reader supports parameterization using Handlebars
/// template engine: [Handlebars](https://handlebarsjs.com)
///
/// ### Configuration parameters ###
///
/// The configuration parameters are the configuration template
///
/// See [IConfigReader]
///
/// ### Example ####
///
///     var config = ConfigParams.fromTuples([
///         'connection.host', '{{SERVICE_HOST}}',
///         'connection.port', '{{SERVICE_PORT}}{{^SERVICE_PORT}}8080{{/SERVICE_PORT}}'
///     ]);
///
///     var configReader = new MemoryConfigReader();
///     configReader.configure(config);
///
///     var parameters = ConfigParams.fromValue(process.env);
///
///     var config = await configReader.readConfig('123', parameters)
///         // Possible result: connection.host=10.1.1.100;connection.port=8080
///
///

class MemoryConfigReader implements IConfigReader, IReconfigurable {
  ConfigParams _config = ConfigParams();

  /// Creates a new instance of config reader.
  ///
  /// - [config]        (optional) component configuration parameters
  MemoryConfigReader([ConfigParams? config])
      : _config = config ?? ConfigParams();

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _config = config;
  }

  /// Reads configuration and parameterize it with given values.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [parameters]        values to parameters the configuration or null to skip parameterization.
  /// Return              Future that receives configuration
  /// Throw  error.
  @override
  Future<ConfigParams> readConfig(
      String? correlationId, ConfigParams? parameters) async {
    if (parameters != null) {
      var config = ConfigParams(_config).toString();
      var template = Template(config);
      config = template.renderString(parameters);
      return ConfigParams.fromString(config);
    } else {
      var config = ConfigParams(_config);
      return config;
    }
  }
}
