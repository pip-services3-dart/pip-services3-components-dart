import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Helper class to retrieve component connections.
///
/// If connections are configured to be retrieved from [IDiscovery],
/// it automatically locates [IDiscovery] in component references
/// and retrieve connections from there using discovery_key parameter.
///
/// ### Configuration parameters ###
///
/// - __connection:__
///     - discovery_key:               (optional) a key to retrieve the connection from [https://rawgit.com/pip-services-node/pip-services-components-node/master/doc/api/interfaces/connect.idiscovery.html IDiscovery]
///     - ...                          other connection parameters
///
/// - __connections:__                  alternative to connection
///     - [connection params 1]:       first connection parameters
///         - ...                      connection parameters for key 1
///     - [connection params N]:       Nth connection parameters
///         - ...                      connection parameters for key N
///
/// ### References ###
///
/// - \*:discovery:\*:\*:1.0    (optional) [https://rawgit.com/pip-services-node/pip-services-components-node/master/doc/api/interfaces/connect.idiscovery.html IDiscovery] services to resolve connections
///
/// See [ConnectionParams]
/// See [IDiscovery]
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples(
///         'connection.host', '10.1.1.100',
///         'connection.port', 8080
///     );
///
///     var connectionResolver = new ConnectionResolver();
///     connectionResolver.configure(config);
///     connectionResolver.setReferences(references);
///
///     connection await = connectionResolver.resolve('123') 
///         // Now use connection...
///     
class ConnectionResolver {
  final _connections = List<ConnectionParams>();
  IReferences _references;

  /// Creates a new instance of connection resolver.
  ///
  /// - [config]        (optional) component configuration parameters
  /// - [references]    (optional) component references
  ConnectionResolver([ConfigParams config, IReferences references]) {
    if (config != null) {
      configure(config);
    }
    if (references != null) {
      setReferences(references);
    }
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  void configure(ConfigParams config) {
    var connections =
        ConnectionParams.manyFromConfig(config);
    _connections.addAll(connections);
  }

  /// Sets references to dependent components.
  ///
  /// - [references] 	references to locate the component dependencies.
  void setReferences(IReferences references) {
    _references = references;
  }

  /// Gets all connections configured in component configuration.
  ///
  /// Redirect to Discovery services is not done at this point.
  /// If you need fully fleshed connection use [resolve] method instead.
  ///
  /// Return a list with connection parameters
  List<ConnectionParams> getAll() {
    return _connections;
  }

  /// Adds a new connection to component connections
  ///
  /// - [connection]    new connection parameters to be added
  void add(ConnectionParams connection) {
    _connections.add(connection);
  }

  Future<ConnectionParams> _resolveInDiscovery(
      String correlationId, ConnectionParams connection) async {
    if (!connection.useDiscovery()) {
      return null;
    }

    var key = connection.getDiscoveryKey();
    if (_references == null) {
      return null;
    }

    var discoveryDescriptor =  Descriptor('*', 'discovery', '*', '*', '*');
    var discoveries =
        _references.getOptional<dynamic>(discoveryDescriptor);
    if (discoveries.isEmpty) {
      var err =  ReferenceException(correlationId, discoveryDescriptor);
      throw err;
    }

    ConnectionParams firstResult;

    for (var discovery in discoveries) {
      IDiscovery discoveryTyped = discovery;
      var result = await discoveryTyped.resolveOne(correlationId, key);
      if (result != null) {
        firstResult = result;
        break;
      }
    }

    return firstResult;
  }

  /// Resolves a single component connection. If connections are configured to be retrieved
  /// from Discovery service it finds a [IDiscovery] and resolves the connection there.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// Return 			Future that receives resolved connection 
  /// Throws error.
  ///
  /// See [IDiscovery]
  Future<ConnectionParams> resolve(String correlationId) async {
    if (_connections.isEmpty) {
      return null;
    }

    var connections = List<ConnectionParams>();

    for (var index = 0; index < _connections.length; index++) {
      if (!_connections[index].useDiscovery()) {
        return _connections[index]; //If a connection is not configured for discovery use - return it.

      } else {
        connections.add(_connections[
            index]); //Otherwise, add it to the list of connections to resolve.
      }
    }

    if (connections.isEmpty) {
      return null;
    }

    ConnectionParams firstResult;
    for (var connection in connections) {
      var result = await _resolveInDiscovery(correlationId, connection);
      if (result != null) {
        firstResult = result;
        break;
      }
    }
    return firstResult;
  }

  Future<List<ConnectionParams>> _resolveAllInDiscovery(
      String correlationId, ConnectionParams connection) async {
    var resolved = List<ConnectionParams>();
    var key = connection.getDiscoveryKey();

    if (!connection.useDiscovery()) {
      return List<ConnectionParams>();
    }

    if (_references == null) {
      return List<ConnectionParams>();
    }

    var discoveryDescriptor =  Descriptor('*', 'discovery', '*', '*', '*');
    var discoveries =
        _references.getOptional<dynamic>(discoveryDescriptor);
    if (discoveries.isEmpty) {
      var err =  ReferenceException(correlationId, discoveryDescriptor);
      throw err;
    }

    for (var discovery in discoveries) {
      IDiscovery discoveryTyped = discovery;
      var result = await discoveryTyped.resolveAll(correlationId, key);
      if (result != null) {
        resolved.addAll(result);
      }
    }
    return resolved;
  }

  /// Resolves all component connection. If connections are configured to be retrieved
  /// from Discovery service it finds a [IDiscovery] and resolves the connection there.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// Return 			          Future that receives resolved connections
  /// Throws error.
  ///
  /// See [IDiscovery]
  Future<List<ConnectionParams>> resolveAll(String correlationId) async {
    var resolved = List<ConnectionParams>();
    var toResolve = List<ConnectionParams>();

    for (var index = 0; index < _connections.length; index++) {
      if (_connections[index].useDiscovery()) {
        toResolve.add(_connections[index]);
      } else {
        resolved.add(_connections[index]);
      }
    }

    if (toResolve.length <= 0) {
      return resolved;
    }

    for (var connection in toResolve) {
      var result = await _resolveAllInDiscovery(correlationId, connection);
      for (var index = 0; index < result.length; index++) {
        var localResolvedConnection = ConnectionParams(
            ConfigParams.mergeConfigs([connection, result[index]]));
        resolved.add(localResolvedConnection);
      }
    }

    return resolved;
  }

  Future<bool> _registerInDiscovery(
      String correlationId, ConnectionParams connection) async {
    if (!connection.useDiscovery()) {
      return false;
    }

    var key = connection.getDiscoveryKey();
    if (_references == null) {
      return false;
    }

    var discoveries = _references.getOptional<IDiscovery>(
        Descriptor('*', 'discovery', '*', '*', '*'));
    if (discoveries == null) {
      return false;
    }

    var error = false;
    for (var discovery in discoveries) {
      try {
        await discovery.register(correlationId, key, connection);
      } catch (err) {
        error = true;
      }
    }
    return !error;
  }

  /// Registers the given connection in all referenced discovery services.
  /// This method can be used for dynamic service discovery.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [connection]        a connection to register.
  /// Return          Future that receives registered connection 
  /// throws error.
  ///
  /// See [IDiscovery]
  Future<ConnectionParams> register(
      String correlationId, ConnectionParams connection) async {
    var result = await _registerInDiscovery(correlationId, connection);
    if (result) {
      _connections.add(connection);
    }
    return connection;
  }
}
