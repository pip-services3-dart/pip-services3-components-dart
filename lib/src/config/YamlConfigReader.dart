import 'dart:async';
import 'dart:io';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:yaml/yaml.dart';
import '../../pip_services3_components.dart';

/// Config reader that reads configuration from YAML file.
///
/// The reader supports parameterization using Handlebars template engine.
///
/// ### Configuration parameters ###
///
/// - path:          path to configuration file
/// - parameters:    this entire section is used as template parameters
/// - ...
///
/// See [IConfigReader]
/// See [FileConfigReader]
///
/// ### Example ###
///
///     ======== config.yml ======
///     key1: '{{KEY1_VALUE}}'
///     key2: '{{KEY2_VALUE}}'
///     ===========================
///
///     var configReader = new YamlConfigReader('config.yml');
///
///     var parameters = ConfigParams.fromTuples('KEY1_VALUE', 123, 'KEY2_VALUE', 'ABC');
///     configReader.readConfig('123', parameters, (err, config) => {
///         // Result: key1=123;key2=ABC
///     });
///
class YamlConfigReader extends FileConfigReader {
  /// Creates a new instance of the config reader.
  ///
  /// - path  (optional) a path to configuration file.

  YamlConfigReader([String path]) : super(path);

  /// Reads configuration file, parameterizes its content and converts it into JSON object.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - parameters        values to parameters the configuration.
  /// Return                 a JSON object with configuration.
  dynamic readObject(String correlationId, ConfigParams parameters) async {
    if (super.getPath() == null)
      throw ConfigException(
          correlationId, 'NO_PATH', 'Missing config file path');

    try {
      // Todo: make this async?
      var content = await File(super.getPath()).readAsString();
      content = parameterize(content, parameters);
      var data = loadYaml(content);
      return data;
    } catch (e) {
      throw FileException(correlationId, 'READ_FAILED',
              'Failed reading configuration ' + super.getPath() + ': ' + e)
          .withDetails('path', super.getPath())
          .withCause(e);
    }
  }

  /// Reads configuration and parameterize it with given values.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - parameters        values to parameters the configuration or null to skip parameterization.
  /// - callback          callback function that receives configuration or error.
  @override
  Future<ConfigParams> readConfig(
      String correlationId, ConfigParams parameters) async {
    var value = readObject(correlationId, parameters);
    var config = ConfigParams.fromValue(value);
    return config;
  }

  /// Reads configuration file, parameterizes its content and converts it into JSON object.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - file              a path to configuration file.
  /// - parameters        values to parameters the configuration.
  /// Return                 a JSON object with configuration.
  static dynamic readObject_(
      String correlationId, String path, ConfigParams parameters) {
    return YamlConfigReader(path).readObject(correlationId, parameters);
  }

  /// Reads configuration from a file, parameterize it with given values and returns a new ConfigParams object.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - file              a path to configuration file.
  /// - parameters        values to parameters the configuration or null to skip parameterization.
  /// - callback          callback function that receives configuration or error.
  static ConfigParams readConfig_(
      String correlationId, String path, ConfigParams parameters) {
    var value = YamlConfigReader(path).readObject(correlationId, parameters);
    var config = ConfigParams.fromValue(value);
    return config;
  }
}
