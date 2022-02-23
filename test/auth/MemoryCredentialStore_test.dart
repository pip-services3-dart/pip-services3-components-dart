import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

void main() {
  group('MemoryCredentialStore', () {
    test('Lookup and store test', () async {
      var config = ConfigParams.fromTuples([
        'key1.user',
        'user1',
        'key1.pass',
        'pass1',
        'key2.user',
        'user2',
        'key2.pass',
        'pass2'
      ]);

      var credentialStore = MemoryCredentialStore();
      credentialStore.readCredentials(config);

      var cred1 = await credentialStore.lookup('123', 'key1');
      var cred2 = await credentialStore.lookup('123', 'key2');

      expect(cred1!.getUsername(), 'user1');
      expect(cred1.getPassword(), 'pass1');
      expect(cred2!.getUsername(), 'user2');
      expect(cred2.getPassword(), 'pass2');

      var credConfig = CredentialParams.fromTuples(
          ['user', 'user3', 'pass', 'pass3', 'access_id', '123']);

      await credentialStore.store(null, 'key3', credConfig);

      var cred3 = await credentialStore.lookup('123', 'key3');

      expect(cred3!.getUsername(), 'user3');
      expect(cred3.getPassword(), 'pass3');
      expect(cred3.getAccessId(), '123');
    });
  });
}
