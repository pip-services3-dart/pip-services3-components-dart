import 'dart:async';
import '../../pip_services3_components.dart';

/// Interface for discovery services which are used to store and resolve connection parameters
/// to connect to external services.
///
/// See [ConnectionParams]
/// See [CredentialParams]

abstract class IDiscovery {
  /// Registers connection parameters into the discovery service.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the connection parameters.
  /// - credential        a connection to be registered.
  /// - callback 			callback function that receives a registered connection or error.

  Future<ConnectionParams> register(
      String correlationId, String key, ConnectionParams connection);

  /// Resolves a single connection parameters by its key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the connection.
  /// - callback          callback function that receives found connection or error.

  Future<ConnectionParams> resolveOne(String correlationId, String key);

  /// Resolves all connection parameters by their key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the connections.
  /// - callback          callback function that receives found connections or error.

  Future<List<ConnectionParams>> resolveAll(String correlationId, String key);
}
