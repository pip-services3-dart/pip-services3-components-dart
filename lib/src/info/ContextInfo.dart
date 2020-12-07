import 'dart:io';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Context information component that provides detail information
/// about execution context: container or/and process.
///
/// Most often ContextInfo is used by logging and performance counters
/// to identify source of the collected logs and metrics.
///
/// ### Configuration parameters ###
///
/// - [name]: 					the context (container or process) name
/// - [description]: 		   	human-readable description of the context
/// - [properties]: 			entire section of additional descriptive properties
/// - ...
///
/// ### Example ###
///
///     let contextInfo = new ContextInfo();
///     contextInfo.configure(ConfigParams.fromTuples(
///         'name', 'MyMicroservice',
///         'description', 'My first microservice'
///     ));
///
///     context.name;			// Result: 'MyMicroservice'
///     context.contextId;		// Possible result: 'mylaptop'
///     context.startTime;		// Possible result: 2018-01-01:22:12:23.45Z
///     context.uptime;			// Possible result: 3454345
class ContextInfo implements IReconfigurable {
  String _name = 'unknown';
  String _description;
  String _contextId = Platform.localHostname; // IdGenerator.nextLong();
  DateTime _startTime = DateTime.now().toUtc();
  StringValueMap _properties = StringValueMap();

  /// Creates a new instance of this context info.
  ///
  /// - name  		(optional) a context name.
  /// - description 	(optional) a human-readable description of the context.
  ContextInfo([String name, String description]) {
    _name = name ?? 'unknown';
    //_description = description ?? null;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    name = config.getAsStringWithDefault('name', name);
    description = config.getAsStringWithDefault('description', description);
    properties = config.getSection('properties');
  }

  /// Gets the context name.
  ///
  /// Return the context name
  String get name {
    return _name;
  }

  /// Sets the context name.
  ///
  /// - value		a new name for the context.
  set name(String value) {
    _name = value ?? 'unknown';
  }

  /// Gets the human-readable description of the context.
  ///
  /// Return the human-readable description of the context.
  String get description {
    return _description;
  }

  /// Sets the human-readable description of the context.
  ///
  /// - value a new human readable description of the context.
  set description(String value) {
    _description = value;
  }

  /// Gets the unique context id.
  /// Usually it is the current host name.
  ///
  /// Return the unique context id.
  String get contextId {
    return _contextId;
  }

  /// Sets the unique context id.
  ///
  /// - value a new unique context id.
  set contextId(String value) {
    _contextId = value;
  }

  /// Gets the context start time.
  ///
  /// Return the context start time.
  DateTime get startTime {
    return _startTime;
  }

  /// Sets the context start time.
  ///
  /// - value a new context start time.
  set startTime(DateTime value) {
    _startTime = value ?? DateTime.now().toUtc();
  }

  /// Calculates the context uptime as from the start time.
  ///
  /// Return number of milliseconds from the context start time.
  int get uptime {
    return DateTime.now().toUtc().millisecondsSinceEpoch -
        _startTime.millisecondsSinceEpoch;
  }

  /// Gets context additional parameters.
  ///
  /// Return a JSON object with additional context parameters.
  dynamic get properties {
    return _properties;
  }

  /// Sets context additional parameters.
  ///
  /// - properties 	a JSON object with context additional parameters
  set properties(dynamic properties) {
    _properties = StringValueMap.fromValue(properties);
  }

  /// Creates a new ContextInfo and sets its configuration parameters.
  ///
  /// - config 	configuration parameters for the new ContextInfo.
  /// Return a newly created ContextInfo
  static ContextInfo fromConfig(ConfigParams config) {
    var result = ContextInfo();
    result.configure(config);
    return result;
  }
}
