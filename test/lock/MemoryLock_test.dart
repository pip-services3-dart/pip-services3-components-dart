import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';
import './LockFixture.dart';

void main() {
  group('MemoryLock', () {
    MemoryLock _lock;
    LockFixture _fixture;

    _lock = MemoryLock();
    _fixture = LockFixture(_lock);
    test('Try Acquire Lock', () {
      _fixture.testTryAcquireLock();
    });

    _lock = MemoryLock();
    _fixture = LockFixture(_lock);
    test('Acquire Lock', () {
      _fixture.testAcquireLock();
    });

    _lock = MemoryLock();
    _fixture = LockFixture(_lock);
    test('Release Lock', () {
      _fixture.testReleaseLock();
    });
  });
}
