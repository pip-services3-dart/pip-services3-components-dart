import 'package:test/test.dart';
import '../../lib/pip_services3_components.dart';

void main() {
  group('ConnectionParams', () {
    test('Gets and sets discovery key', () {
      var connection = ConnectionParams();
      connection.setDiscoveryKey(null);
      expect(connection.getDiscoveryKey(), isNull);

      connection.setDiscoveryKey('Discovery key value');
      expect(connection.getDiscoveryKey(), 'Discovery key value');
      expect(connection.useDiscovery(), isTrue);
    });

    test('Gets and sets protocol', () {
      var connection = ConnectionParams();
      connection.setProtocol(null);
      expect(connection.getProtocol(), isNull);
      expect(connection.getProtocol(null), isNull);
      expect(connection.getProtocol('https'), 'https');

      connection.setProtocol('https');
      expect(connection.getProtocol(), 'https');
    });

    test('Gets and sets host', () {
      var connection = ConnectionParams();
      expect(connection.getHost(), isNull);
      connection.setHost(null);
      expect(connection.getHost(), isNull);

      connection.setHost('localhost');
      expect(connection.getHost(), 'localhost');
    });

    test('Gets and sets port', () {
      var connection = ConnectionParams();
      expect(connection.getHost(), isNull);

      connection.setPort(3000);
      expect(connection.getPort(), 3000);
    });

    test('Gets and sets uri', () {
      var connection = ConnectionParams();
      expect(connection.getUri(), isNull);

      connection.setUri('https://pipgoals:3000');
      expect(connection.getUri(), 'https://pipgoals:3000');
    });
  });
}
