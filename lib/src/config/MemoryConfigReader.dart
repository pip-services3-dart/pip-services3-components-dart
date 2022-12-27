import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_expressions/pip_services3_expressions.dart';
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
      var template = MustacheTemplate(config);
      config = template.evaluateWithVariables(parameters) ?? '';
      return ConfigParams.fromString(config);
    } else {
      var config = ConfigParams(_config);
      return config;
    }
  }

  /// Adds a listener that will be notified when configuration is changed
  ///
  /// - [listener] a listener to be added.
  @override
  void addChangeListener(INotifiable listener) {
    // Do nothing...
  }

  /// Remove a previously added change listener.
  ///
  /// - [listener]  a listener to be removed.
  @override
  void removeChangeListener(INotifiable listener) {
    // Do nothing...
  }
}
