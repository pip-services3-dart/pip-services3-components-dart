import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Used to store key-identifiable information about connections.
class DiscoveryItem {
  String key;
  ConnectionParams connection;
}

/// Discovery service that keeps connections in memory.
///
/// ### Configuration parameters ###
///
/// - [connection key 1]:
///     - ...                          connection parameters for key 1
/// - [connection key 2]:
///     - ...                          connection parameters for key N
///
/// See [IDiscovery]
/// See [ConnectionParams]
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples(
///         "key1.host", "10.1.1.100",
///         "key1.port", "8080",
///         "key2.host", "10.1.1.100",
///         "key2.port", "8082"
///     );
///
///     var discovery = new MemoryDiscovery();
///     discovery.readConnections(config);
///
///     discovery.resolve("123", "key1", (err, connection) => {
///         // Result: host=10.1.1.100;port=8080
///     });

class MemoryDiscovery implements IDiscovery, IReconfigurable {
  List<DiscoveryItem> _items = List<DiscoveryItem>();

  /// Creates a new instance of discovery service.
  ///
  /// - config    (optional) configuration with connection parameters.

  MemoryDiscovery([ConfigParams config = null]) {
    if (config != null) this.configure(config);
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.

  void configure(ConfigParams config) {
    this.readConnections(config);
  }

  /// Reads connections from configuration parameters.
  /// Each section represents an individual Connectionparams
  ///
  /// - config   configuration parameters to be read

  void readConnections(ConfigParams config) {
    this._items = [];
    var keys = config.getKeys();
    for (var index = 0; index < keys.length; index++) {
      var key = keys[index];
      var value = config.getAsNullableString(key);
      DiscoveryItem item = new DiscoveryItem();
      item.key = key;
      item.connection = ConnectionParams.fromString(value);
      this._items.add(item);
    }
  }

  /// Registers connection parameters into the discovery service.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the connection parameters.
  /// - credential        a connection to be registered.
  /// - callback 			callback function that receives a registered connection or error.
  Future<ConnectionParams> register(
      String correlationId, String key, ConnectionParams connection) async {
    DiscoveryItem item = new DiscoveryItem();
    item.key = key;
    item.connection = connection;
    this._items.add(item);

    return connection;
  }

  /// Resolves a single connection parameters by its key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the connection.
  /// - callback          callback function that receives found connection or error.
  Future<ConnectionParams> resolveOne(String correlationId, String key) async {
    ConnectionParams connection = null;
    for (var index = 0; index < this._items.length; index++) {
      var item = this._items[index];
      if (item.key == key && item.connection != null) {
        connection = item.connection;
        break;
      }
    }
    return connection;
  }

  /// Resolves all connection parameters by their key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the connections.
  /// - callback          callback function that receives found connections or error.
  Future<List<ConnectionParams>> resolveAll(
      String correlationId, String key) async {
    List<ConnectionParams> connections = List<ConnectionParams>();
    for (var index = 0; index < this._items.length; index++) {
      var item = this._items[index];
      if (item.key == key && item.connection != null)
        connections.add(item.connection);
    }
    return connections;
  }
}
