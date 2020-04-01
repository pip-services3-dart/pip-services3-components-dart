import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../lib/pip_services3_components.dart';

void main() {
  group('ContextInfo', () {
    ContextInfo contextInfo;

    contextInfo = ContextInfo();

    test('Name', () {
      expect(contextInfo.name, 'unknown');

      String update = 'name';
      contextInfo.name = update;
      expect(contextInfo.name, update);
    });

    contextInfo = ContextInfo();
    test('Description', () {
      expect(contextInfo.description, isNull);

      String update = 'description';
      contextInfo.description = update;
      expect(contextInfo.description, update);
    });
    contextInfo = ContextInfo();
    test('ContextId', () {
      expect(contextInfo.contextId, isNotNull);

      String update = 'context id';
      contextInfo.contextId = update;
      expect(contextInfo.contextId, update);
    });
    contextInfo = ContextInfo();
    test('StartTime', () {
      var now = DateTime.now();

      expect(contextInfo.startTime.year, now.year);
      expect(contextInfo.startTime.month, now.month);

      contextInfo.startTime = DateTime(1975, 4, 8);
      expect(contextInfo.startTime.year, 1975);
      expect(contextInfo.startTime.month, 4);
      expect(contextInfo.startTime.day, 8);
    });
    contextInfo = ContextInfo();
    test('FromConfig', () {
      ConfigParams config = ConfigParams.fromTuples([
        'name',
        'name',
        'description',
        'description',
        'properties.access_key',
        'key',
        'properties.store_key',
        'store key'
      ]);

      ContextInfo contextInfo = ContextInfo.fromConfig(config);
      expect(contextInfo.name, 'name');
      expect(contextInfo.description, 'description');
    });
  });
}
