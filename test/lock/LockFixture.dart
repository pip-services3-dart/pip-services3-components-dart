import 'package:test/test.dart';
import 'package:pip_services3_components/pip_services3_components.dart';

final String LOCK1 = 'lock_1';
final String LOCK2 = 'lock_2';
final String LOCK3 = 'lock_3';

class LockFixture {
  ILock _lock;

  LockFixture(ILock lock) {
    _lock = lock;
  }

  void testTryAcquireLock() async {
    // Try to acquire lock for the first time

    var result = await _lock.tryAcquireLock(null, LOCK1, 3000);
    expect(result, isTrue);

    // Try to acquire lock for the second time

    result = await _lock.tryAcquireLock(null, LOCK1, 3000);
    expect(result, isFalse);

    // Release the lock
    await _lock.releaseLock(null, LOCK1);

    // Try to acquire lock for the third time
    result = await _lock.tryAcquireLock(null, LOCK1, 3000);
    expect(result, isTrue);

    await _lock.releaseLock(null, LOCK1);
  }

  void testAcquireLock() async {
    // Acquire lock for the first time
    await _lock.acquireLock(null, LOCK2, 3000, 1000);

    // Acquire lock for the second time
    var err;
    try {
      await _lock.acquireLock(null, LOCK2, 3000, 1000);
    } catch (ex) {
      err = ex;
    }
    expect(err, isNotNull);

    // Release the lock
    await _lock.releaseLock(null, LOCK2);

    // Acquire lock for the third time
    await _lock.acquireLock(null, LOCK2, 3000, 1000);

    await _lock.releaseLock(null, LOCK2);
  }

  void testReleaseLock() async {
    // Acquire lock for the first time

    var result = await _lock.tryAcquireLock(null, LOCK3, 3000);
    expect(result, isTrue);

    // Release the lock for the first time
    await _lock.releaseLock(null, LOCK3);

    // Release the lock for the second time
    await _lock.releaseLock(null, LOCK3);
  }
}
