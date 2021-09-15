import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

/// Helper class that resolves connection and credential parameters,
/// validates them and generates connection options.
///
/// ### Configuration parameters ###
/// - [connection(s)]:
///   - [discovery_key]: (optional) a key to retrieve the connection from [IDiscovery](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/IDiscovery-class.html)
///   - [protocol]:      connection protocol like http, https, tcp, udp
///   - [host]:          host name or IP address
///   - [port]:          port number
///   - [uri]:           resource URI or connection string with all parameters in it
/// - [credential(s)]:
///   - [store_key]:   (optional) a key to retrieve the credentials from [ICredentialStore](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/ICredentialStore-class.html)
///   - [username]:    user name
///   - [password]:    user password
///
/// ### References ###
///
/// - \*:discovery:\*:\*:1.0    (optional) [IDiscovery](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/IDiscovery-class.html) services to resolve connections
/// - \*:credential-store:\*:\*:1.0   (optional) Credential stores to resolve credentials
///
class CompositeConnectionResolver implements IReferenceable, IConfigurable {
  /// The connection options
  ConfigParams? _options;

  /// The connections resolver.
  final ConnectionResolver _connectionResolver = ConnectionResolver();

  /// The credentials resolver.
  final CredentialResolver _credentialResolver = CredentialResolver();

  /// The cluster support (multiple connections)
  final bool _clusterSupported = true;

  /// The default protocol
  final String? _defaultProtocol = null;

  /// The default port number
  final int _defaultPort = 0;

  /// The list of supported protocols
  final List<String>? _supportedProtocols = null;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]     configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _connectionResolver.configure(config);
    _credentialResolver.configure(config);
    _options = config.getSection('options');
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  @override
  void setReferences(IReferences references) {
    _connectionResolver.setReferences(references);
    _credentialResolver.setReferences(references);
  }

  /// Resolves connection options from connection and credential parameters.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// Return resolved options.
  Future<ConfigParams> resolve(String? correlationId) async {
    var connections = <ConnectionParams>[];
    var credential = CredentialParams();

    await Future(() async {
      connections = await _connectionResolver.resolveAll(correlationId);
      connections = connections.isNotEmpty ? connections : [];

      // Validate if cluster (multiple connections) is supported
      if (connections.isEmpty && !_clusterSupported) {
        throw ConfigException(
            correlationId,
            'MULTIPLE_CONNECTIONS_NOT_SUPPORTED',
            'Multiple (cluster) connections are not supported');
      }

      for (dynamic connection in connections) {
        validateConnection(correlationId, connection);
      }
    });

    await Future(() async {
      var result = await _credentialResolver.lookup(correlationId);
      credential = result ?? credential;
      // Validate credential
      validateCredential(correlationId, credential);
    });

    return composeOptions(connections, credential, _options!);
  }

  /// Composes Composite connection options from connection and credential parameters.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [connections]       connection parameters
  /// - [credential]        credential parameters
  /// - [parameters]        optional parameters
  /// Return                resolved options.
  ConfigParams compose(
      String? correlationId,
      List<ConnectionParams> connections,
      CredentialParams credential,
      ConfigParams parameters) {
    // Validate connection parameters
    for (dynamic connection in connections) {
      validateConnection(correlationId, connection);
    }

    // Validate credential parameters
    validateCredential(correlationId, credential);

    // Compose final options
    return composeOptions(connections, credential, parameters);
  }

  /// Validates connection parameters and throws an exception on error.
  /// This method can be overriden in child classes.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [connection]        connection parameters to be validated
  void validateConnection(String? correlationId, ConnectionParams? connection) {
    if (connection == null) {
      throw ConfigException(correlationId, 'NO_CONNECTION',
          'Connection parameters are not set is not set');
    }

    // URI usually contains all information
    dynamic uri = connection.getUri();
    if (uri != null) {
      return;
    }

    dynamic protocol = connection.getProtocol(_defaultProtocol);
    if (protocol == null) {
      throw ConfigException(
          correlationId, 'NO_PROTOCOL", "Connection protocol is not set');
    }
    if (_supportedProtocols != null &&
        !_supportedProtocols!.contains(protocol)) {
      throw ConfigException(correlationId, 'UNSUPPORTED_PROTOCOL',
          'The protocol ' + protocol + ' is not supported');
    }

    dynamic host = connection.getHost();
    if (host == null) {
      throw ConfigException(
          correlationId, 'NO_HOST', 'Connection host is not set');
    }

    dynamic port = connection.getPortWithDefault(_defaultPort);
    if (port == 0) {
      throw ConfigException(
          correlationId, 'NO_PORT', 'Connection port is not set');
    }
  }

  /// Validates credential parameters and throws an exception on error.
  /// This method can be overriden in child classes.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [credential]        credential parameters to be validated
  void validateCredential(String? correlationId, CredentialParams? credential) {
    // By default the rules are open
  }

  ConfigParams composeOptions(List<ConnectionParams> connections,
      CredentialParams credential, ConfigParams parameters) {
    // Connection options
    dynamic options = ConfigParams();

    // Merge connection parameters
    for (dynamic connection in connections) {
      options = mergeConnection(options, connection);
    }

    // Merge credential parameters
    options = mergeCredential(options, credential);

    // Merge optional parameters
    options = mergeOptional(options, parameters);

    // Perform final processing
    options = finalizeOptions(options);

    return options;
  }

  /// Merges connection options with connection parameters
  /// This method can be overriden in child classes.
  ///
  /// - [options] connection options
  /// - [connection] connection parameters to be merged
  /// Return merged connection options.
  ConfigParams mergeConnection(
      ConfigParams options, ConnectionParams connection) {
    var mergedOptions = options.setDefaults(connection);
    return mergedOptions;
  }

  /// Merges connection options with credential parameters
  /// This method can be overriden in child classes.
  ///
  /// - [options] connection options
  /// - [credential] credential parameters to be merged
  /// Return merged connection options.
  ConfigParams mergeCredential(
      ConfigParams options, CredentialParams credential) {
    dynamic mergedOptions = options.override(credential);
    return mergedOptions;
  }

  /// Merges connection options with optional parameters
  /// This method can be overriden in child classes.
  ///
  /// - [options] connection options
  /// - [parameters] optional parameters to be merged
  /// return merged connection options.
  ConfigParams mergeOptional(ConfigParams options, ConfigParams parameters) {
    dynamic mergedOptions = options.setDefaults(parameters);
    return mergedOptions;
  }

  /// Finalize merged options
  /// This method can be overriden in child classes.
  ///
  /// - [options] connection options
  /// return finalized connection options
  ConfigParams finalizeOptions(ConfigParams options) {
    return options;
  }
}
