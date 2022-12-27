import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/src/log/NullLogger.dart';
import 'package:pip_services3_components/src/trace/trace.dart';
import 'package:test/test.dart';

void main() {
  group('MemoryStateStore', () {
    var _tracer = LogTracer();
    _tracer.setReferences(References.fromTuples([
      Descriptor('pip-services', 'logger', 'null', 'default', '1.0'),
      NullLogger()
    ]));
    test('Simple Tracing', () {
      _tracer.trace('123', 'mycomponent', 'mymethod', 123456);
      _tracer.failure(
          '123', 'mycomponent', 'mymethod', Exception('Test error'), 123456);
    });
    test('Trace Timing', () {
      var timing = _tracer.beginTrace('123', 'mycomponent', 'mymethod');
      timing.endTrace();

      timing = _tracer.beginTrace('123', 'mycomponent', 'mymethod');
      timing.endFailure(Exception('Test error'));
    });
  });
}
