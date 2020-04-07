import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Credential store that keeps credentials in memory.
///
/// ### Configuration parameters ###
///
/// - [credential key 1]:
///     - ...                          credential parameters for key 1
/// - [credential key 2]:
///     - ...                          credential parameters for key N
/// - ...
///
/// See [ICredentialStore]
/// See [CredentialParams]
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples(
///         'key1.user', 'jdoe',
///         'key1.pass', 'pass123',
///         'key2.user', 'bsmith',
///         'key2.pass', 'mypass'
///     );
///
///     var credentialStore = MemoryCredentialStore();
///     credentialStore.readCredentials(config);
///
///     var credential = await credentialStore.lookup('123', 'key1')
///     // Result: user=jdoe;pass=pass123

class MemoryCredentialStore implements ICredentialStore, IReconfigurable {
  Map<String, dynamic> _items = <String, dynamic>{};

  /// Creates a new instance of the credential store.
  ///
  /// - [config]    (optional) configuration with credential parameters.

  MemoryCredentialStore([ConfigParams config]) {
    if (config != null) configure(config);
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - [config]    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    readCredentials(config);
  }

  /// Reads credentials from configuration parameters.
  /// Each section represents an individual CredentialParams
  ///
  /// - [config]   configuration parameters to be read
  void readCredentials(ConfigParams config) {
    _items = <String, dynamic>{};
    var keys = config.getKeys();
    for (var index = 0; index < keys.length; index++) {
      var key = keys[index];
      var value = config.getAsString(key);
      _items[key] = CredentialParams.fromString(value);
    }
  }

  /// Stores credential parameters into the store.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a key to uniquely identify the credential parameters.
  /// - [credential]        a credential parameters to be stored.
  /// Return 			        Future that receives an null for success.
  /// Throw error
  @override
  Future store(
      String correlationId, String key, CredentialParams credential) async {
    if (credential != null) {
      _items[key] = credential;
    } else {
      _items.remove(key);
    }
  }

  /// Lookups credential parameters by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a key to uniquely identify the credential parameters.
  /// Return              Future that receives found credential parameters
  /// Throw error.
  @override
  Future<CredentialParams> lookup(String correlationId, String key) async {
    var credential = _items[key];
    return credential;
  }
}
