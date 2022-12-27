import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Contains credentials to authenticate against external services.
/// They are used together with connection parameters, but usually stored
/// in a separate store, protected from unauthorized access.
///
/// ### Configuration parameters ###
///
/// - [store_key]:     key to retrieve parameters from credential store
/// - [username]:      user name
/// - [user]:          alternative to username
/// - [password]:      user password
/// - [pass]:          alternative to password
/// - [access_id]:     application access id
/// - [client_id]:     alternative to access_id
/// - [access_key]:    application secret key
/// - [client_key]:    alternative to access_key
/// - [secret_key]:    alternative to access_key
///
/// In addition to standard parameters CredentialParams may contain any number of custom parameters
///
/// See [ConfigParams](https://pub.dev/documentation/pip_services3_commons/latest/pip_services3_commons/ConfigParams-class.html)
/// See [ConnectionParams]
/// See [CredentialResolver]
/// See [ICredentialStore]
///
/// ### Example ###
///
///     var credential = CredentialParams.fromTuples(
///         'user', 'jdoe',
///         'pass', 'pass123',
///         'pin', '321'
///     );
///
///     var username = credential.getUsername();             // Result: 'jdoe'
///     var password = credential.getPassword();             // Result: 'pass123'
///     var pin = credential.getAsNullableString('pin');     // Result: 321
class CredentialParams extends ConfigParams {
  /// Creates a new credential parameters and fills it with values.
  ///
  /// - [values] 	(optional) an object to be converted into key-value pairs to initialize these credentials.

  CredentialParams([dynamic values]) : super(values);

  /// Checks if these credential parameters shall be retrieved from [CredentialStore].
  /// The credential parameters are redirected to [CredentialStore] when store_key parameter is set.
  ///
  /// Return     true if credentials shall be retrieved from [CredentialStore]
  ///
  /// See [getStoreKey]
  bool useCredentialStore() {
    return super.getAsNullableString('store_key') != null;
  }

  /// Gets the key to retrieve these credentials from [CredentialStore].
  /// If this key is null, than all parameters are already present.
  ///
  /// Return     the store key to retrieve credentials.
  ///
  /// See [useCredentialStore]
  String? getStoreKey() {
    return super.getAsNullableString('store_key');
  }

  /// Sets the key to retrieve these parameters from [CredentialStore].
  ///
  /// - [value]     a new key to retrieve credentials.
  void setStoreKey(String? value) {
    super.put('store_key', value);
  }

  /// Gets the user name.
  /// The value can be stored in parameters 'username' or 'user'.
  ///
  /// Return     the user name.
  String? getUsername() {
    return super.getAsNullableString('username') ??
        super.getAsNullableString('user');
  }

  /// Sets the user name.
  ///
  /// - [value]     a new user name.
  void setUsername(String? value) {
    super.put('username', value);
  }

  /// Get the user password.
  /// The value can be stored in parameters 'password' or 'pass'.
  ///
  /// Return     the user password.
  String? getPassword() {
    return super.getAsNullableString('password') ??
        super.getAsNullableString('pass');
  }

  /// Sets the user password.
  ///
  /// - [value]     a new user password.
  void setPassword(String? value) {
    super.put('password', value);
  }

  /// Gets the application access id.
  /// The value can be stored in parameters 'access_id' pr 'client_id'
  ///
  /// Return     the application access id.
  String? getAccessId() {
    return super.getAsNullableString('access_id') ??
        super.getAsNullableString('client_id');
  }

  /// Sets the application access id.
  ///
  /// - [value]     a new application access id.
  void setAccessId(String value) {
    super.put('access_id', value);
  }

  /// Gets the application secret key.
  /// The value can be stored in parameters 'access_key', 'client_key' or 'secret_key'.
  ///
  /// Return     the application secret key.
  String? getAccessKey() {
    return super.getAsNullableString('access_key') ??
        super.getAsNullableString('client_key') ??
        super.getAsNullableString('secret_key');
  }

  /// Sets the application secret key.
  ///
  /// - [value]     a new application secret key.
  void setAccessKey(String? value) {
    super.put('access_key', value);
  }

  /// Creates a new CredentialParams object filled with key-value pairs serialized as a string.
  ///
  /// - [line] 		a string with serialized key-value pairs as 'key1=value1;key2=value2;...'
  /// 					Example: 'Key1=123;Key2=ABC;Key3=2016-09-16T00:00:00.00Z'
  /// Return			a new CredentialParams object.
  static CredentialParams fromString(String line) {
    var map = StringValueMap.fromString(line);
    return CredentialParams(map);
  }

  /// Creates a new CredentialParams object filled with provided key-value pairs called tuples.
  /// Tuples parameters contain a sequence of key1, value1, key2, value2, ... pairs.
  ///
  /// - [tuples]	the tuples to fill a new CredentialParams object.
  /// Return			a new CredentialParams object.
  static CredentialParams fromTuples(List<dynamic> tuples) {
    var map = StringValueMap.fromTuplesArray(tuples);
    return CredentialParams(map);
  }

  /// Retrieves all CredentialParams from configuration parameters
  /// from 'credentials' section. If 'credential' section is present instead,
  /// than it returns a list with only one CredentialParams.
  ///
  /// - [config] 	a configuration parameters to retrieve credentials
  /// Return			a list of retrieved CredentialParams
  static List<CredentialParams> manyFromConfig(ConfigParams config) {
    var result = <CredentialParams>[];

    var credentials = config.getSection('credentials');

    if (credentials.isNotEmpty) {
      for (var section in credentials.getSectionNames()) {
        var credential = credentials.getSection(section);
        result.add(CredentialParams(credential));
      }
    } else {
      var credential = config.getSection('credential');
      if (credential.isNotEmpty) result.add(CredentialParams(credential));
    }

    return result;
  }

  /// Retrieves a single CredentialParams from configuration parameters
  /// from 'credential' section. If 'credentials' section is present instead,
  /// then is returns only the first credential element.
  ///
  /// - [config] 	ConfigParams, containing a section named 'credential(s)'.
  /// Return			the generated CredentialParams object.
  ///
  /// See [manyFromConfig]
  static CredentialParams? fromConfig(ConfigParams config) {
    var credentials = CredentialParams.manyFromConfig(config);
    return credentials.isNotEmpty ? credentials[0] : null;
  }
}
