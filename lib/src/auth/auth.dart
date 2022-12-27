///
/// Todo: Rewrite this description
///
/// Contains credentials implementation.
///
/// Credentials – passwords, logins, application keys, secrets. This information is usually linked
/// with connection parameters. Connection parameters separate from authentication, because auth.
/// is saved as a secret, and stored separately from configuration parameters (host name, ip
/// addresses). They need added security and protection, so they were separated.
///
/// Credential parameters include various credentials.
///
/// Interfaces and abstract classes for credential stores, which can save or retrieve various
/// credential parameters.

export './CredentialParams.dart';
export './ICredentialStore.dart';
export './CredentialResolver.dart';
export './MemoryCredentialStore.dart';
export './DefaultCredentialStoreFactory.dart';
