import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';

import '../../lib/src/log/NullLogger.dart';
import '../../lib/src/log/ConsoleLogger.dart';
import '../../lib/src/log/CompositeLogger.dart';
import '../../lib/src/log/LogLevel.dart';
import '../../lib/src/log/DefaultLoggerFactory.dart';

void main() {
  group('CompositeLogger', () {
    CompositeLogger _logger;

    _logger = CompositeLogger();
    var refs = References.fromTuples([
      DefaultLoggerFactory.NullLoggerDescriptor,
      NullLogger(),
      DefaultLoggerFactory.ConsoleLoggerDescriptor,
      ConsoleLogger()
    ]);
    _logger.setReferences(refs);

    test('Log Level', () {
      expect(_logger.getLevel().index >= LogLevel.None.index, isTrue);
      expect(_logger.getLevel().index <= LogLevel.Trace.index, isTrue);
    });

    _logger = CompositeLogger();
    refs = References.fromTuples([
      DefaultLoggerFactory.NullLoggerDescriptor,
      NullLogger(),
      DefaultLoggerFactory.ConsoleLoggerDescriptor,
      ConsoleLogger()
    ]);
    _logger.setReferences(refs);
    test('Simple Logging', () {
      _logger.setLevel(LogLevel.Trace);

      _logger.fatal(null, null, 'Fatal error message');
      _logger.error(null, null, 'Error message');
      _logger.warn(null, 'Warning message');
      _logger.info(null, 'Information message');
      _logger.debug(null, 'Debug message');
      _logger.trace(null, 'Trace message');
    });

    _logger = CompositeLogger();
    refs = References.fromTuples([
      DefaultLoggerFactory.NullLoggerDescriptor,
      NullLogger(),
      DefaultLoggerFactory.ConsoleLoggerDescriptor,
      ConsoleLogger()
    ]);
    _logger.setReferences(refs);
    test('Error Logging', () {
      try {
        // Raise an exception
        throw Exception();
      } catch (err) {
        var ex = ApplicationException().wrap(err);
        _logger.fatal('123', ex, 'Fatal error');
        _logger.error('123', ex, 'Recoverable error');

        expect(ex, isNotNull);
      }
    });
  });
}
