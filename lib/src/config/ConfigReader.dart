import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
//import 'package:handlebars2/handlebars2.dart' as handlebars;
import 'package:stubble/stubble.dart';

/// Abstract config reader that supports configuration parameterization.
///
/// ### Configuration parameters ###
///
/// - __parameters:__            this entire section is used as template parameters
///     - ...
///
///  See [IConfigReader]
abstract class ConfigReader implements IConfigurable {
  ConfigParams _parameters = ConfigParams();

  /// Creates a new instance of the config reader.
  ConfigReader();

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    var parameters = config.getSection('parameters');
    if (parameters.isNotEmpty) _parameters = parameters;
  }

  /// Reads configuration and parameterize it with given values.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - parameters        values to parameters the configuration or null to skip parameterization.
  /// - callback          callback function that receives configuration or error.
  Future<ConfigParams> readConfig(
      String correlationId, ConfigParams parameters);

  /// Parameterized configuration template given as string with dynamic parameters.
  ///
  /// The method uses Handlebars template engine: [https://handlebarsjs.com]
  ///
  /// - config        a string with configuration template to be parameterized
  /// - parameters    dynamic parameters to inject into the template
  /// Return a parameterized configuration string.
  String parameterize(String config, ConfigParams parameters) {
    parameters = _parameters.override(parameters);
    var handlebars = Stubble();
    var template = handlebars.compile(config);
    return template(parameters);
  }
}
