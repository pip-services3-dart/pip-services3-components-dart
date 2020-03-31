// import { StringValueMap } from 'pip-services3-commons-node';
// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReconfigurable } from 'pip-services3-commons-node';
import "package:pip_services3_commons/pip_services3_commons.dart";

import 'dart:io';

/// Context information component that provides detail information
/// about execution context: container or/and process.
///
/// Most often ContextInfo is used by logging and performance counters
/// to identify source of the collected logs and metrics.
///
/// ### Configuration parameters ###
///
/// - name: 					the context (container or process) name
/// - description: 		   	human-readable description of the context
/// - properties: 			entire section of additional descriptive properties
/// - ...
///
/// ### Example ###
///
///     let contextInfo = new ContextInfo();
///     contextInfo.configure(ConfigParams.fromTuples(
///         "name", "MyMicroservice",
///         "description", "My first microservice"
///     ));
///
///     context.name;			// Result: "MyMicroservice"
///     context.contextId;		// Possible result: "mylaptop"
///     context.startTime;		// Possible result: 2018-01-01:22:12:23.45Z
///     context.uptime;			// Possible result: 3454345
class ContextInfo implements IReconfigurable {
  String _name = "unknown";
  String _description = null;
  String _contextId = Platform.localHostname; // IdGenerator.nextLong();
  DateTime _startTime = new DateTime.now();
  StringValueMap _properties = new StringValueMap();

  /// Creates a new instance of this context info.
  ///
  /// - name  		(optional) a context name.
  /// - description 	(optional) a human-readable description of the context.
  ContextInfo([String name, String description]) {
    this._name = name ?? "unknown";
    this._description = description ?? null;
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    this.name = config.getAsStringWithDefault("name", this.name);
    this.description =
        config.getAsStringWithDefault("description", this.description);
    this.properties = config.getSection("properties");
  }

  /// Gets the context name.
  ///
  /// Return the context name
  String get name {
    return this._name;
  }

  /// Sets the context name.
  ///
  /// - value		a new name for the context.
  void set name(String value) {
    this._name = value ?? "unknown";
  }

  /// Gets the human-readable description of the context.
  ///
  /// Return the human-readable description of the context.
  String get description {
    return this._description;
  }

  /// Sets the human-readable description of the context.
  ///
  /// - value a new human readable description of the context.
  void set description(String value) {
    this._description = value;
  }

  /// Gets the unique context id.
  /// Usually it is the current host name.
  ///
  /// Return the unique context id.
  String get contextId {
    return this._contextId;
  }

  /// Sets the unique context id.
  ///
  /// - value a new unique context id.
  void set contextId(String value) {
    this._contextId = value;
  }

  /// Gets the context start time.
  ///
  /// Return the context start time.
  DateTime get startTime {
    return this._startTime;
  }

  /// Sets the context start time.
  ///
  /// - value a new context start time.
  void set startTime(DateTime value) {
    this._startTime = value ?? new DateTime.now();
  }

  /// Calculates the context uptime as from the start time.
  ///
  /// Return number of milliseconds from the context start time.
  int get uptime {
    return new DateTime.now().millisecondsSinceEpoch -
        this._startTime.millisecondsSinceEpoch;
  }

  /// Gets context additional parameters.
  ///
  /// Return a JSON object with additional context parameters.
  dynamic get properties {
    return this._properties;
  }

  /// Sets context additional parameters.
  ///
  /// - properties 	a JSON object with context additional parameters
  void set properties(dynamic properties) {
    this._properties = StringValueMap.fromValue(properties);
  }

  /// Creates a new ContextInfo and sets its configuration parameters.
  ///
  /// - config 	configuration parameters for the new ContextInfo.
  /// Return a newly created ContextInfo
  static ContextInfo fromConfig(ConfigParams config) {
    var result = new ContextInfo();
    result.configure(config);
    return result;
  }
}
