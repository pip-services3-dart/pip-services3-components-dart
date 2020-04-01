import 'dart:async';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../pip_services3_components.dart';

/// Helper class to retrieve component credentials.
///
/// If credentials are configured to be retrieved from [ICredentialStore],
/// it automatically locates [ICredentialStore] in component references
/// and retrieve credentials from there using store_key parameter.
///
/// ### Configuration parameters ###
///
/// __credential:__
/// - store_key:                   (optional) a key to retrieve the credentials from [ICredentialStore]
/// - ...                          other credential parameters
///
/// __credentials:__                   alternative to credential
/// - [credential params 1]:       first credential parameters
///     - ...                      credential parameters for key 1
/// - ...
/// - [credential params N]:       Nth credential parameters
///     - ...                      credential parameters for key N
///
/// ### References ###
///
/// - [*:credential-store:\*:\*:1.0]  (optional) Credential stores to resolve credentials
///
/// See [CredentialParams]
/// See [ICredentialStore]
///
/// ### Example ###
///
///     var config = ConfigParams.fromTuples([
///         'credential.user', 'jdoe',
///         'credential.pass',  'pass123'
///     ]);
///
///     var credentialResolver = new CredentialResolver();
///     credentialResolver.configure(config);
///     credentialResolver.setReferences(references);
///
///     credentialResolver.lookup('123', (err, credential) => {
///         // Now use credential...
///     });
///
class CredentialResolver {
  List<CredentialParams> _credentials = List<CredentialParams>();
  IReferences _references = null;

  /// Creates a new instance of credentials resolver.
  ///
  /// - config        (optional) component configuration parameters
  /// - references    (optional) component references
  CredentialResolver(
      [ConfigParams config = null, IReferences references = null]) {
    if (config != null) this.configure(config);
    if (references != null) this.setReferences(references);
  }

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    List<CredentialParams> credentials =
        CredentialParams.manyFromConfig(config);
    this._credentials.addAll(credentials);
  }

  /// Sets references to dependent components.
  ///
  /// - references 	references to locate the component dependencies.
  void setReferences(IReferences references) {
    this._references = references;
  }

  /// Gets all credentials configured in component configuration.
  ///
  /// Redirect to CredentialStores is not done at this point.
  /// If you need fully fleshed credential use [lookup] method instead.
  ///
  /// Return a list with credential parameters
  List<CredentialParams> getAll() {
    return this._credentials;
  }

  /// Adds a new credential to component credentials
  ///
  /// - credential    new credential parameters to be added
  void add(CredentialParams credential) {
    this._credentials.add(credential);
  }

  Future<CredentialParams> _lookupInStores(
      String correlationId, CredentialParams credential) async {
    if (!credential.useCredentialStore()) return null;

    String key = credential.getStoreKey();
    if (this._references == null) return null;

    var storeDescriptor =
         Descriptor('*', 'credential-store', '*', '*', '*');
    List<dynamic> components =
        this._references.getOptional<dynamic>(storeDescriptor);
    if (components.isEmpty) {
      throw  ReferenceException(correlationId, storeDescriptor);
    }

    CredentialParams firstResult;
    for (var component in components) {
      ICredentialStore store = component;
      var result = await store.lookup(correlationId, key);
      if (result != null) {
        firstResult = result;
        break;
      }
    }
    return firstResult;
  }

  /// Looks up component credential parameters. If credentials are configured to be retrieved
  /// from Credential store it finds a [ICredentialStore] and lookups credentials there.
  ///
  /// - correlationId     (optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives resolved credential or error.
  Future<CredentialParams> lookup(String correlationId) async {
    if (this._credentials.isEmpty) {
      return null;
    }

    List<CredentialParams> lookupCredentials = List<CredentialParams>();

    for (var index = 0; index < this._credentials.length; index++) {
      if (!this._credentials[index].useCredentialStore()) {
        return this._credentials[index];
      } else {
        lookupCredentials.add(this._credentials[index]);
      }
    }

    CredentialParams firstResult;
    for (var credential in lookupCredentials) {
      var result = await this._lookupInStores(correlationId, credential);
      if (result != null) {
        firstResult = result;
        break;
      }
    }

    return firstResult;
  }
}
