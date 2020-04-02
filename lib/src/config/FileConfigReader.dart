import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Abstract config reader that reads configuration from a file.
/// Child classes add support for config files in their specific format
/// like JSON, YAML or property files.
///
/// ### Configuration parameters ###
///
/// - path:          path to configuration file
/// - parameters:    this entire section is used as template parameters
/// - ...
///
/// See [IConfigReader]
/// See [ConfigReader]
abstract class FileConfigReader extends ConfigReader {
  String _path;

  /// Creates a new instance of the config reader.
  ///
  /// - path  (optional) a path to configuration file.
  FileConfigReader([String path = null]) : super() {
    this._path = path;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    super.configure(config);
    this._path = config.getAsStringWithDefault("path", this._path);
  }

  /// Get the path to configuration file..
  ///
  /// Return the path to configuration file.
  String getPath() {
    return this._path;
  }

  /// Set the path to configuration file.
  ///
  /// - path  a new path to configuration file.
  void setPath(String path) {
    this._path = path;
  }
}
