import 'dart:async';
import 'dart:io';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Config reader that reads configuration from JSON file.
///
/// The reader supports parameterization using Handlebar template engine.
///
/// ### Configuration parameters ###
///
/// - [path]:          path to configuration file
/// - [parameters]:    this entire section is used as template parameters
/// - ...
///
/// See [IConfigReader]
/// See [FileConfigReader]
///
/// ### Example ###
///
///     ======== config.json ======
///     { 'key1': '{{KEY1_VALUE}}', 'key2': '{{KEY2_VALUE}}' }
///     ===========================
///
///     var configReader = new JsonConfigReader('config.json');
///
///     var parameters = ConfigParams.fromTuples(['KEY1_VALUE', 123, 'KEY2_VALUE', 'ABC']);
///     var config = await configReader.readConfig('123', parameters)
///         // Result: key1=123;key2=ABC
///
class JsonConfigReader extends FileConfigReader {
  /// Creates a new instance of the config reader.
  ///
  /// - [path]  (optional) a path to configuration file.
  JsonConfigReader([String? path]) : super(path);

  /// Reads configuration file, parameterizes its content and converts it into JSON object.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [parameters]        values to parameters the configuration.
  /// Return                 a JSON object with configuration.
  dynamic readObject(String? correlationId, ConfigParams parameters) {
    if (super.getPath() == null) {
      throw ConfigException(
          correlationId, 'NO_PATH', 'Missing config file path');
    }

    try {
      // Todo: make this async?
      var data = File(super.getPath()!).readAsStringSync();
      data = parameterize(data, parameters);
      return JsonConverter.toNullableMap(data);
    } catch (e) {
      throw FileException(
              correlationId,
              'READ_FAILED',
              'Failed reading configuration ' +
                  super.getPath()! +
                  ': ' +
                  e.toString())
          .withDetails('path', super.getPath())
          .withCause(e);
    }
  }

  /// Reads configuration and parameterize it with given values.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [parameters]        values to parameters the configuration
  /// Return          Future that receives configuration
  /// Throws error.
  @override
  Future<ConfigParams> readConfig(
      String? correlationId, ConfigParams parameters) async {
    var value = readObject(correlationId, parameters);
    var config = ConfigParams.fromValue(value);
    return config;
  }

  /// Reads configuration file, parameterizes its content and converts it into JSON object.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [file]              a path to configuration file.
  /// - [parameters]        values to parameters the configuration.
  /// Return                a JSON object with configuration.
  static dynamic readObject_(
      String? correlationId, String path, ConfigParams parameters) async {
    return JsonConfigReader(path).readObject(correlationId, parameters);
  }

  /// Reads configuration from a file, parameterize it with given values and returns a new ConfigParams object.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [file]              a path to configuration file.
  /// - [parameters]        values to parameters the configuration.
  /// Return          callback function that receives configuration or error.
  static ConfigParams readConfig_(
      String? correlationId, String path, ConfigParams parameters) {
    var value = JsonConfigReader(path).readObject(correlationId, parameters);
    var config = ConfigParams.fromValue(value);
    return config;
  }
}
