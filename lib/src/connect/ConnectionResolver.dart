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
///         "connection.host", "10.1.1.100",
///         "connection.port", 8080
///     );
///
///     var connectionResolver = new ConnectionResolver();
///     connectionResolver.configure(config);
///     connectionResolver.setReferences(references);
///
///     connectionResolver.resolve("123", (err, connection) => {
///         // Now use connection...
///     });

class ConnectionResolver {
  final List<ConnectionParams> _connections = List<ConnectionParams>();
  IReferences _references = null;

  /// Creates a new instance of connection resolver.
  ///
  /// - config        (optional) component configuration parameters
  /// - references    (optional) component references

  ConnectionResolver(
      [ConfigParams config = null, IReferences references = null]) {
    if (config != null) this.configure(config);
    if (references != null) this.setReferences(references);
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.

  void configure(ConfigParams config) {
    List<ConnectionParams> connections =
        ConnectionParams.manyFromConfig(config);
    this._connections.addAll(connections);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.

  void setReferences(IReferences references) {
    this._references = references;
  }

  /// Gets all connections configured in component configuration.
  ///
  /// Redirect to Discovery services is not done at this point.
  /// If you need fully fleshed connection use [resolve] method instead.
  ///
  /// Return a list with connection parameters

  List<ConnectionParams> getAll() {
    return this._connections;
  }

  /// Adds a new connection to component connections
  ///
  /// - connection    new connection parameters to be added

  void add(ConnectionParams connection) {
    this._connections.add(connection);
  }

  Future<ConnectionParams> _resolveInDiscovery(
      String correlationId, ConnectionParams connection) async {
    if (!connection.useDiscovery()) {
      return Future<ConnectionParams>(() {
        return null;
      });
    }

    String key = connection.getDiscoveryKey();
    if (this._references == null) {
      return null;
    }

    var discoveryDescriptor = new Descriptor("*", "discovery", "*", "*", "*");
    List<dynamic> discoveries =
        this._references.getOptional<dynamic>(discoveryDescriptor);
    if (discoveries.length == 0) {
      var err = new ReferenceException(correlationId, discoveryDescriptor);
      throw err;
    }

    ConnectionParams firstResult = null;

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
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives resolved connection or error.
  ///
  /// See [IDiscovery]

  Future<ConnectionParams> resolve(String correlationId) async {
    if (this._connections.length == 0) {
      return null;
    }

    List<ConnectionParams> connections = List<ConnectionParams>();

    for (var index = 0; index < this._connections.length; index++) {
      if (!this._connections[index].useDiscovery()) {
        return this._connections[index]; //If a connection is not configured for discovery use - return it.

      } else {
        connections.add(this._connections[
            index]); //Otherwise, add it to the list of connections to resolve.
      }
    }

    if (connections.length == 0) {
      return null;
    }

    ConnectionParams firstResult = null;
    for (var connection in connections) {
      var result = await this._resolveInDiscovery(correlationId, connection);
      if (result != null) {
        firstResult = result;
        break;
      }
    }
    return firstResult;
  }

  Future<List<ConnectionParams>> _resolveAllInDiscovery(
      String correlationId, ConnectionParams connection) async {
    List<ConnectionParams> resolved = List<ConnectionParams>();
    String key = connection.getDiscoveryKey();

    if (!connection.useDiscovery()) {
      return List<ConnectionParams>();
    }

    if (this._references == null) {
      return List<ConnectionParams>();
    }

    var discoveryDescriptor = new Descriptor("*", "discovery", "*", "*", "*");
    List<dynamic> discoveries =
        this._references.getOptional<dynamic>(discoveryDescriptor);
    if (discoveries.length == 0) {
      var err = new ReferenceException(correlationId, discoveryDescriptor);
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
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives resolved connections or error.
  ///
  /// See [IDiscovery]

  Future<List<ConnectionParams>> resolveAll(String correlationId) async {
    List<ConnectionParams> resolved = List<ConnectionParams>();
    List<ConnectionParams> toResolve = List<ConnectionParams>();

    for (var index = 0; index < this._connections.length; index++) {
      if (this._connections[index].useDiscovery())
        toResolve.add(this._connections[index]);
      else
        resolved.add(this._connections[index]);
    }

    if (toResolve.length <= 0) {
      return resolved;
    }

    for (var connection in toResolve) {
      var result = await this._resolveAllInDiscovery(correlationId, connection);
      for (var index = 0; index < result.length; index++) {
        ConnectionParams localResolvedConnection = new ConnectionParams(
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
    if (this._references == null) {
      return false;
    }

    var discoveries = this._references.getOptional<IDiscovery>(
        new Descriptor("*", "discovery", "*", "*", "*"));
    if (discoveries == null) {
      return Future<bool>(() {
        return false;
      });
    }

    bool error = false;
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
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - connection        a connection to register.
  /// - callback          callback function that receives registered connection or error.
  ///
  /// See [IDiscovery]

  Future<ConnectionParams> register(
      String correlationId, ConnectionParams connection) async {
    var result = await this._registerInDiscovery(correlationId, connection);
    if (result) this._connections.add(connection);
    return connection;
  }
}
