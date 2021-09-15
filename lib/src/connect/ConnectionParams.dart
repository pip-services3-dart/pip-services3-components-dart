import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Contains connection parameters to connect to external services.
/// They are used together with credential parameters, but usually stored
/// separately from more protected sensitive values.
///
/// ### Configuration parameters ###
///
/// - [discovery_key]: key to retrieve parameters from discovery service
/// - [protocol]:      connection protocol like http, https, tcp, udp
/// - [host]:          host name or IP address
/// - [port]:          port number
/// - [uri]:           resource URI or connection string with all parameters in it
///
/// In addition to standard parameters ConnectionParams may contain any number of custom parameters
///
/// See [ConfigParams](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/ConfigParams-class.html)
/// See [CredentialParams]
/// See [ConnectionResolver]
/// See [IDiscovery]
///
/// ### Example ###
///
/// Example ConnectionParams object usage:
///
///     var connection = ConnectionParams.fromTuples([
///         'protocol', 'http',
///         'host', '10.1.1.100',
///         'port', '8080',
///         'cluster', 'mycluster'
///     ]);
///
///     var host = connection.getHost();                             // Result: '10.1.1.100'
///     var port = connection.getPort();                             // Result: 8080
///     var cluster = connection.getAsNullableString('cluster');     // Result: 'mycluster'

class ConnectionParams extends ConfigParams {
  /// Creates a new connection parameters and fills it with values.
  ///
  /// - values 	(optional) an object to be converted into key-value pairs to initialize this connection.
  ConnectionParams([values]) : super(values);

  /// Checks if these connection parameters shall be retrieved from [DiscoveryService].
  /// The connection parameters are redirected to [DiscoveryService] when discovery_key parameter is set.
  ///
  /// Return     true if connection shall be retrieved from [DiscoveryService]
  ///
  /// See [getDiscoveryKey]
  bool useDiscovery() {
    return super.getAsNullableString('discovery_key') != null;
  }

  /// Gets the key to retrieve this connection from [DiscoveryService].
  /// If this key is null, than all parameters are already present.
  ///
  /// Return     the discovery key to retrieve connection.
  ///
  /// See [useDiscovery]
  String? getDiscoveryKey() {
    return super.getAsNullableString('discovery_key');
  }

  /// Sets the key to retrieve these parameters from [DiscoveryService].
  ///
  /// - [value]     a new key to retrieve connection.
  void setDiscoveryKey(String? value) {
    return super.put('discovery_key', value);
  }

  /// Gets the connection protocol.
  ///
  /// - [defaultValue]  (optional) the default protocol
  /// Return             the connection protocol or the default value if it's not set.
  String? getProtocol([String? defaultValue]) {
    var result = super.getAsStringWithDefault('protocol', defaultValue ?? '');
    return result != '' ? result : null;
  }

  /// Gets the connection protocol with default value.
  ///
  /// - [defaultValue]  (optional) the default protocol
  /// return the connection protocol or the default value if it's not set.
  String getProtocolWithDefault(String defaultValue) {
    return super.getAsStringWithDefault('protocol', defaultValue);
  }

  /// Sets the connection protocol.
  ///
  /// - [value]     a new connection protocol.
  void setProtocol(String? value) {
    return super.put('protocol', value);
  }

  /// Gets the host name or IP address.
  ///
  /// Return     the host name or IP address.
  String? getHost() {
    var host = super.getAsNullableString('host');
    host = host ?? super.getAsNullableString('ip');
    return host;
  }

  /// Sets the host name or IP address.
  ///
  /// - [value]     a new host name or IP address.
  void setHost(String? value) {
    return super.put('host', value);
  }

  /// Gets the port number.
  ///
  /// Return the port number.
  int? getPort() {
    return super.getAsInteger('port');
  }

  /// Gets the port number with default value.
  ///
  /// - [defaultPort] a default port number.
  /// return the port number.
  int getPortWithDefault(int defaultPort) {
    return super.getAsIntegerWithDefault('port', defaultPort);
  }

  /// Sets the port number.
  ///
  /// - [value]     a new port number.
  ///
  /// See [getHost]
  void setPort(int value) {
    return super.put('port', value);
  }

  /// Gets the resource URI or connection string.
  /// Usually it includes all connection parameters in it.
  ///
  /// Return the resource URI or connection string.
  String? getUri() {
    return super.getAsNullableString('uri');
  }

  /// Sets the resource URI or connection string.
  ///
  /// - [value]     a new resource URI or connection string.
  void setUri(String value) {
    return super.put('uri', value);
  }

  /// Creates a new ConnectionParams object filled with key-value pairs serialized as a string.
  ///
  /// - [line] 		a string with serialized key-value pairs as 'key1=value1;key2=value2;...'
  /// 					Example: 'Key1=123;Key2=ABC;Key3=2016-09-16T00:00:00.00Z'
  /// Return			a new ConnectionParams object.
  ///
  /// See [StringValueMap.fromString]
  static ConnectionParams fromString(String line) {
    var map = StringValueMap.fromString(line);
    return ConnectionParams(map);
  }

  /// Creates a new ConnectionParams object filled with provided key-value pairs called tuples.
  /// Tuples parameters contain a sequence of key1, value1, key2, value2, ... pairs.
  ///
  /// - [tuples]	the tuples to fill a new ConnectionParams object.
  /// Return			a new ConnectionParams object.
  static ConnectionParams fromTuples(List<dynamic> tuples) {
    var map = StringValueMap.fromTuplesArray(tuples);
    return ConnectionParams(map);
  }

  /// Retrieves all ConnectionParams from configuration parameters
  /// from 'connections' section. If 'connection' section is present instead,
  /// than it returns a list with only one ConnectionParams.
  ///
  /// - [config] 	a configuration parameters to retrieve connections
  /// Return			a list of retrieved ConnectionParams
  static List<ConnectionParams> manyFromConfig(ConfigParams config) {
    var result = <ConnectionParams>[];
    var connections = config.getSection('connections');

    if (connections.isNotEmpty) {
      var connectionSections = connections.getSectionNames();
      for (var index = 0; index < connectionSections.length; index++) {
        var connection = connections.getSection(connectionSections[index]);
        result.add(ConnectionParams(connection));
      }
    } else {
      var connection = config.getSection('connection');
      if (connection.isNotEmpty) result.add(ConnectionParams(connection));
    }

    return result;
  }

  /// Retrieves a single ConnectionParams from configuration parameters
  /// from 'connection' section. If 'connections' section is present instead,
  /// then is returns only the first connection element.
  ///
  /// - [config] 	ConnectionParams, containing a section named 'connection(s)'.
  /// Return			the generated ConnectionParams object.
  ///
  /// See [manyFromConfig]
  static ConnectionParams? fromConfig(ConfigParams config) {
    var connections = ConnectionParams.manyFromConfig(config);
    return connections.isNotEmpty ? connections[0] : null;
  }
}
