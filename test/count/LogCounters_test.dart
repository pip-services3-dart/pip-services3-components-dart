import 'dart:async';
import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../lib/pip_services3_components.dart';

void main() {
  group('LogCounters', () {
    LogCounters _counters;

    var log = NullLogger();
    var refs =
        References.fromTuples([DefaultLoggerFactory.NullLoggerDescriptor, log]);
    _counters = LogCounters();
    _counters.setReferences(refs);

    test('Simple Counters', () {
      var counters = _counters;

      counters.last('Test.LastValue', 123);
      counters.last('Test.LastValue', 123456);

      var counter = counters.get('Test.LastValue', CounterType.LastValue);
      expect(counter, isNotNull);
      expect(counter.last, isNotNull);
      expect(counter.last, 123456); // ,3

      counters.incrementOne('Test.Increment');
      counters.increment('Test.Increment', 3);

      counter = counters.get('Test.Increment', CounterType.Increment);
      expect(counter, isNotNull);
      expect(counter.count, 4);

      counters.timestampNow('Test.Timestamp');
      counters.timestampNow('Test.Timestamp');

      counter = counters.get('Test.Timestamp', CounterType.Timestamp);
      expect(counter, isNotNull);
      expect(counter.time, isNotNull);

      counters.stats('Test.Statistics', 1);
      counters.stats('Test.Statistics', 2);
      counters.stats('Test.Statistics', 3);

      counter = counters.get('Test.Statistics', CounterType.Statistics);
      expect(counter, isNotNull);
      expect(counter.average, 2); // ,3

      counters.dump();
    });

    log = NullLogger();
    refs =
        References.fromTuples([DefaultLoggerFactory.NullLoggerDescriptor, log]);
    _counters = LogCounters();
    _counters.setReferences(refs);

    test('Measure Elapsed Time', () async {
      var timer = _counters.beginTiming('Test.Elapsed');

      await Future.delayed(Duration(milliseconds: 100), () {
        timer.endTiming();

        var counter = _counters.get('Test.Elapsed', CounterType.Interval);
        print(counter.last);
        expect(counter.last > 50, isTrue);
        expect(counter.last < 5000, isTrue);

        _counters.dump();
      });
    });
  });
}
