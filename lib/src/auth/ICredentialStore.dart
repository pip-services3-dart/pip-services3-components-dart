import './CredentialParams.dart';
import "dart:async";

/// Interface for credential stores which are used to store and lookup credentials
/// to authenticate against external services.
///
/// See [CredentialParams]
/// See [ConnectionParams]
abstract class ICredentialStore {
  /// Stores credential parameters into the store.
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the credential.
  /// - credential        a credential to be stored.
  /// - callback 			callback function that receives an error or null for success.
  Future store(String correlationId, String key, CredentialParams credential);

  /// Lookups credential parameters by its key.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - key               a key to uniquely identify the credential.
  /// - callback          callback function that receives found credential or error.
  Future<CredentialParams> lookup(String correlationId, String key);
}
