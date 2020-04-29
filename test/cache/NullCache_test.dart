import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

void main() {
  group('NullCache', () {
    NullCache cache;

    cache = NullCache();

    test('Retrieve Returns Null', () async {
      try {
        var val = await cache.retrieve(null, 'key1');
        expect(val, isNull);
      } catch (err) {
        expect(err, isNull);
      }
    });

    test('Store Returns Same Value', () async {
      var key = 'key1';
      var initVal = 'value1';
      try {
        var val = await cache.store(null, key, initVal, 0);
        expect(initVal, val);
      } catch (err) {
        expect(err, isNull);
      }
    });
  });
}
