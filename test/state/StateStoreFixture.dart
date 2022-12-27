import 'package:pip_services3_components/src/state/state.dart';
import 'package:test/test.dart';

var KEY1 = 'key1';
var KEY2 = 'key2';

var VALUE1 = 'value1';
var VALUE2 = 'value2';

class StateStoreFixture {
  IStateStore _state;

  StateStoreFixture(IStateStore state) : _state = state;

  Future testSaveAndLoad() async {
    await _state.save(null, KEY1, VALUE1);
    await _state.save(null, KEY2, VALUE2);

    var val = await _state.load(null, KEY1);
    expect(val, isNotNull);
    expect(VALUE1 == val, isTrue);

    var values = await _state.loadBulk(null, [KEY2]);
    expect(values.length == 1, isTrue);
    expect(KEY2 == values[0].key, isTrue);
    expect(VALUE2 == values[0].value, isTrue);
  }

  Future testDelete() async {
    await _state.save(null, KEY1, VALUE1);

    await _state.delete(null, KEY1);

    var val = await _state.load(null, KEY1);
    expect(val, isNull);
  }
}
