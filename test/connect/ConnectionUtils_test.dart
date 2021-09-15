import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

void main() {
  group('ConnectionUtils', () {
    test('Concat Options', () {
      var options1 = ConfigParams.fromTuples(
          ['host', 'server1', 'port', '8080', 'param1', 'ABC']);

      var options2 = ConfigParams.fromTuples(
          ['host', 'server2', 'port', '8080', 'param2', 'XYZ']);

      var options = ConnectionUtils.concat(options1, options2);

      expect(4, options.length);
      expect('server1,server2', options.getAsNullableString('host'));
      expect('8080,8080', options.getAsNullableString('port'));
      expect('ABC', options.getAsNullableString('param1'));
      expect('XYZ', options.getAsNullableString('param2'));
    });

    test('Include Keys', () {
      var options1 = ConfigParams.fromTuples(
          ['host', 'server1', 'port', '8080', 'param1', 'ABC']);

      var options = ConnectionUtils.include(options1, ['host', 'port']);

      expect(2, options.length);
      expect('server1', options.getAsNullableString('host'));
      expect('8080', options.getAsNullableString('port'));
      expect(options.getAsNullableString('param1'), null);
    });

    test('Exclude Keys', () {
      var options1 = ConfigParams.fromTuples(
          ['host', 'server1', 'port', '8080', 'param1', 'ABC']);

      var options = ConnectionUtils.exclude(options1, ['host', 'port']);

      expect(1, options.length);
      expect(options.getAsNullableString('host'), null);
      expect(options.getAsNullableString('port'), null);
      expect('ABC', options.getAsNullableString('param1'));
    });

    test('Parse URI', () {
      var options = ConnectionUtils.parseUri('broker1', 'kafka', 9092);
      expect(4, options.length);
      expect('broker1:9092', options.getAsNullableString('servers'));
      expect('kafka', options.getAsNullableString('protocol'));
      expect('broker1', options.getAsNullableString('host'));
      expect('9092', options.getAsNullableString('port'));

      options = ConnectionUtils.parseUri('tcp://broker1:8082', 'kafka', 9092);
      expect(4, options.length);
      expect('broker1:8082', options.getAsNullableString('servers'));
      expect('tcp', options.getAsNullableString('protocol'));
      expect('broker1', options.getAsNullableString('host'));
      expect('8082', options.getAsNullableString('port'));

      options = ConnectionUtils.parseUri(
          'tcp://user:pass123@broker1:8082', 'kafka', 9092);
      expect(6, options.length);
      expect('broker1:8082', options.getAsNullableString('servers'));
      expect('tcp', options.getAsNullableString('protocol'));
      expect('broker1', options.getAsNullableString('host'));
      expect('8082', options.getAsNullableString('port'));
      expect('user', options.getAsNullableString('username'));
      expect('pass123', options.getAsNullableString('password'));

      options = ConnectionUtils.parseUri(
          'tcp://user:pass123@broker1,broker2:8082', 'kafka', 9092);
      expect(6, options.length);
      expect(
          'broker1:9092,broker2:8082', options.getAsNullableString('servers'));
      expect('tcp', options.getAsNullableString('protocol'));
      expect('broker1,broker2', options.getAsNullableString('host'));
      expect('9092,8082', options.getAsNullableString('port'));
      expect('user', options.getAsNullableString('username'));
      expect('pass123', options.getAsNullableString('password'));

      options = ConnectionUtils.parseUri(
          'tcp://user:pass123@broker1:8082,broker2:8082?param1=ABC&param2=XYZ',
          'kafka',
          9092);
      expect(8, options.length);
      expect(
          'broker1:8082,broker2:8082', options.getAsNullableString('servers'));
      expect('tcp', options.getAsNullableString('protocol'));
      expect('broker1,broker2', options.getAsNullableString('host'));
      expect('8082,8082', options.getAsNullableString('port'));
      expect('user', options.getAsNullableString('username'));
      expect('pass123', options.getAsNullableString('password'));
      expect('ABC', options.getAsNullableString('param1'));
      expect('XYZ', options.getAsNullableString('param2'));
    });

    test('Parse URI', () {
      var options = ConfigParams.fromTuples([
        'host',
        'broker1,broker2',
        'port',
        ',8082',
        'username',
        'user',
        'password',
        'pass123',
        'param1',
        'ABC',
        'param2',
        'XYZ',
        'param3',
        null
      ]);

      var uri = ConnectionUtils.composeUri(options, 'tcp', 9092);
      expect(
          'tcp://user:pass123@broker1:9092,broker2:8082?param1=ABC&param2=XYZ&param3',
          uri);

      uri = ConnectionUtils.composeUri(options, null, null);
      expect('user:pass123@broker1,broker2:8082?param1=ABC&param2=XYZ&param3',
          uri);
    });

    test('Parse URI', () {
      var options = ConnectionUtils.parseUri(
          'http://localhost:8080/test?param1=abc', 'http', 80);

      expect('http', options.getAsString('protocol'));
      expect('localhost', options.getAsString('host'));
      expect(8080, options.getAsInteger('port'));
      expect('test', options.getAsString('path'));
      expect('abc', options.getAsString('param1'));
    });

    test('Compose URI', () {
      var options = ConfigParams.fromTuples([
        'protocol',
        'http',
        'host',
        'localhost',
        'port',
        8080,
        'path',
        'test',
        'param1',
        'abc'
      ]);

      var uri = ConnectionUtils.composeUri(options, 'http', 80);
      expect('http://localhost:8080/test?param1=abc', uri);
    });
  });
}
