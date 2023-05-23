import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

void main() {
  group('NullCounters', () {
    test('Simple Counters', () {
      var counters = NullCounters();

      counters.last('Test.LastValue', 123);
      counters.increment('Test.Increment', 3);
      counters.stats('Test.Statistics', 123);
    });

    test('Measure Elapsed Time', () {
      var counters = NullCounters();
      var timer = counters.beginTiming('Test.Elapsed');
      timer.endTiming();
    });
  });
}
