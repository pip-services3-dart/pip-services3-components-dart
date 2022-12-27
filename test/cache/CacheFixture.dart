import 'dart:async';
import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

String KEY1 = 'key1';
String KEY2 = 'key2';

String VALUE1 = 'value1';
String VALUE2 = 'value2';

class CacheFixture {
  final ICache _cache;

  CacheFixture(ICache cache) : _cache = cache;

  void testStoreAndRetrieve() async {
    try {
      await _cache.store(null, KEY1, VALUE1, 5000);
    } catch (err) {
      expect(err, isNull);
    }

    try {
      await _cache.store(null, KEY2, VALUE2, 5000);
    } catch (err) {
      expect(err, isNull);
    }

    await Future.delayed(Duration(milliseconds: 500));

    try {
      var val = await _cache.retrieve(null, KEY1);
      expect(val, isNotNull);
      expect(VALUE1, val);
    } catch (err) {
      expect(err, isNull);
    }
    try {
      var val = await _cache.retrieve(null, KEY2);
      expect(val, isNotNull);
      expect(VALUE2, val);
    } catch (err) {
      expect(err, isNull);
    }
  }

  void testRetrieveExpired() async {
    try {
      await _cache.store(null, KEY1, VALUE1, 1000);
    } catch (err) {
      expect(err, isNull);
    }

    await Future.delayed(Duration(milliseconds: 1500));

    try {
      var val = await _cache.retrieve(null, KEY1);
      expect(val, isNull);
    } catch (err) {
      expect(err, isNull);
    }
  }

  void testRemove() async {
    try {
      await _cache.store(null, KEY1, VALUE1, 1000);
    } catch (err) {
      expect(err, isNull);
    }
    try {
      await _cache.remove(null, KEY1);
    } catch (err) {
      expect(err, isNull);
    }

    try {
      var val = await _cache.retrieve(null, KEY1);
      expect(val, isNull);
    } catch (err) {
      expect(err, isNull);
    }
  }
}
