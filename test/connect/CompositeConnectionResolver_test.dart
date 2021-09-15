import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import 'package:test/test.dart';

void main() {
  group('CompositeConnectionResolver', () {
    test('Resolver', () async {
      var config = ConfigParams.fromTuples([
        'connection.protocol',
        'http',
        'connection.host',
        'localhost',
        'connection.port',
        3000,
        'credential.username',
        'user',
        'credential.password',
        'pass'
      ]);

      var connectionResolver = CompositeConnectionResolver();
      connectionResolver.configure(config);
      var options = await connectionResolver.resolve(null);

      expect(options.get('protocol'), 'http');
      expect(options.get('host'), 'localhost');
      expect(options.get('port'), '3000');
    });
  });
}
