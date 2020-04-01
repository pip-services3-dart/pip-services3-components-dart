import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../lib/pip_services3_components.dart';

void main() {
  group('NullCounters', () {
    test('Simple Counters', () {
      NullCounters counters = NullCounters();

      counters.last("Test.LastValue", 123);
      counters.increment("Test.Increment", 3);
      counters.stats("Test.Statistics", 123);
    });

    test('Measure Elapsed Time', () {
      NullCounters counters = NullCounters();
      Timing timer = counters.beginTiming("Test.Elapsed");
      timer.endTiming();
    });
  });
}
