import 'package:test/test.dart';
import 'package:pip_services3_commons/pip_services3_commons.dart';
import '../../lib/pip_services3_components.dart';

final String LOCK1 = 'lock_1';
final String LOCK2 = 'lock_2';
final String LOCK3 = 'lock_3';

class LockFixture {
  ILock _lock;

  LockFixture(ILock lock) {
    this._lock = lock;
  }

  testTryAcquireLock() async {
    // Try to acquire lock for the first time
    try {
      var result = await this._lock.tryAcquireLock(null, LOCK1, 3000);
      expect(result, isTrue);
    } catch (err) {
      expect(err, isNull);
    }

    // Try to acquire lock for the second time
    try {
      var result = await this._lock.tryAcquireLock(null, LOCK1, 3000);
      expect(result, isFalse);
    } catch (err) {
      expect(err, isNull);
    }

    // Release the lock
    await this._lock.releaseLock(null, LOCK1);

    // Try to acquire lock for the third time
    try {
      var result = await this._lock.tryAcquireLock(null, LOCK1, 3000);
      expect(result, isTrue);
    } catch (err) {
      expect(err, isNull);
    }

    await this._lock.releaseLock(null, LOCK1);
  }

  void testAcquireLock() async {
    // Acquire lock for the first time

    try {
      await this._lock.acquireLock(null, LOCK2, 3000, 1000);
    } catch (err) {
      expect(err, isNull);
    }

    // Acquire lock for the second time
    try {
      await this._lock.acquireLock(null, LOCK2, 3000, 1000);
    } catch (err) {
      expect(err, isNotNull);
    }

    // Release the lock

    await this._lock.releaseLock(null, LOCK2);

    // Acquire lock for the third time
    try {
      this._lock.acquireLock(null, LOCK2, 3000, 1000);
    } catch (err) {
      expect(err, isNull);
    }

    await this._lock.releaseLock(null, LOCK2);
  }

  void testReleaseLock() async {
    // Acquire lock for the first time
    try {
      var result = await this._lock.tryAcquireLock(null, LOCK3, 3000);
      expect(result, isTrue);
    } catch (err) {
      expect(err, isNull);
    }

    // Release the lock for the first time
    await this._lock.releaseLock(null, LOCK3);

    // Release the lock for the second time
    await this._lock.releaseLock(null, LOCK3);
  }
}
