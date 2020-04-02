import 'dart:async';
import '../../pip_services3_components.dart';

/// Interface for credential stores which are used to store and lookup credentials
/// to authenticate against external services.
///
/// See [CredentialParams]
/// See [ConnectionParams]
abstract class ICredentialStore {
  /// Stores credential parameters into the store.
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a key to uniquely identify the credential.
  /// - [credential]        a credential to be stored.
  /// Return 			        Future that receives an null for success.
  /// Throw error
  Future store(String correlationId, String key, CredentialParams credential);

  /// Lookups credential parameters by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a key to uniquely identify the credential.
  /// Return              Future that receives found credential
  /// Throw  error.
  Future<CredentialParams> lookup(String correlationId, String key);
}
