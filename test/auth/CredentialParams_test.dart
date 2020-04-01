
import 'package:test/test.dart';
import '../../lib/pip_services3_components.dart';

void main(){
group('CredentialParams', () {

    test('Gets and sets store key', () {
		var credential = CredentialParams();
		credential.setStoreKey(null);
		expect(credential.getStoreKey(), isNull);

		credential.setStoreKey('Store key');
		expect(credential.getStoreKey(), 'Store key');
		expect(credential.useCredentialStore(), isTrue);
        
    });

    test('Gets and sets username', ()  {
		var credential = CredentialParams();
		credential.setUsername(null);
		expect(credential.getUsername(), isNull);

		credential.setUsername('Kate Negrienko');
		expect(credential.getUsername(), 'Kate Negrienko');

       
    });

    test('Gets and sets password', ()  {
		var credential = CredentialParams();
		credential.setPassword(null);
		expect(credential.getPassword(), isNull);

		credential.setPassword('qwerty');
		expect(credential.getPassword(), 'qwerty');

       
    });

    test('Gets and sets access key', ()  {
		var credential = CredentialParams();
		credential.setAccessKey(null);
		expect(credential.getAccessKey(), isNull);

		credential.setAccessKey('key');
		expect(credential.getAccessKey(), 'key');

       
    });

});
}