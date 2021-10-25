import 'package:pip_services3_components/src/state/state.dart';
import 'package:test/test.dart';

import 'StateStoreFixture.dart';

void main() {
  late MemoryStateStore _cache;
  late StateStoreFixture _fixture;
  group('LogTracer', () {
    _cache = MemoryStateStore();
    _fixture = StateStoreFixture(_cache);
  });
  test('Save and Load', () async {
    await _fixture.testSaveAndLoad();
  });
  test('Delete', () async {
    await _fixture.testDelete();
  });
}
