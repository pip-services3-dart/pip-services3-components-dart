# Examples for Components

This library has an extensive set of components for working in various fields when creating
microservices, micro-applications and applications. It includes:


- **Auth** - authentication credential store
* Example:

```dart
void main(){
     var restConfig = ConfigParams.fromTuples([
      'credential.username',
      'Negrienko',
      'credential.password',
      'qwerty',
      'credential.access_key',
      'key',
      'credential.store_key',
      'store key'
    ]);
    var credentialResolver = CredentialResolver(restConfig);
    var configList = credentialResolver.getAll();
    configList[0].get('username'); // Returns 'Negrienko'
    configList[0].get('password'); // Returns 'qwerty'
    configList[0].get('access_key'); // Returns 'key'
    configList[0].get('store_key'); // Returns 'store key'
}
```

- **Build** - factories

- **Cache** - distributed cache
* Example:

```dart
void main(){
    String KEY1 = 'key1';
    String VALUE1 = 'value1';

    var _cache = MemoryCache();
     try {
      await _cache.store('123', KEY1, VALUE1, 5000);
    } catch (err) {
      //...
    }

    try {
      var val = await _cache.retrieve('123', KEY1);
      // Expect VALUE1
    } catch (err) {
        //...
    }
}
```

- **Component** - root package

- **Config** - configuration reader
* Example:

```dart
void main(){
     var parameters = ConfigParams.fromTuples(
          ['param1', 'Test Param 1', 'param2', 'Test Param 2']);
      var config =
          JsonConfigReader.readConfig_('123', './data/config.json', parameters);

      config.getAsInteger('field1.field11'); // Return 123
      config.get('field1.field12'); // Return 'ABC'
      config.getAsInteger('field2.0'); // Return  123
      config.get('field4'); // Return 'Test Param 1'
      config.get('field5'); // Return 'Test Param 2'
}
```

- **Connect** - connection discovery services
* Example:

```dart
void main(){
    var RestConfig = ConfigParams.fromTuples([
      'connection.protocol',
      'http',
      'connection.host',
      'localhost',
      'connection.port',
      3000
    ]);
    var connectionResolver = ConnectionResolver(RestConfig);
    var configList = connectionResolver.getAll();
    configList[0].get('protocol'); // Return 'http'
    configList[0].get('host'); // Return 'localhost'
    configList[0].get('port'); // Return '3000'
}
```

- **Count** - performance counters
* Example:

```dart
void main(){
    LogCounters counters;

    var log = NullLogger();
    var refs =
        References.fromTuples([DefaultLoggerFactory.NullLoggerDescriptor, log]);
    counters = LogCounters();
    counters.setReferences(refs);
    counters.last('Test.LastValue', 123);
    counters.last('Test.LastValue', 123456);

    var counter = counters.get('Test.LastValue', CounterType.LastValue);
    
    counter.last; // Return  123456
    counters.incrementOne('Test.Increment');
    counters.increment('Test.Increment', 3);
    counter = counters.get('Test.Increment', CounterType.Increment);
    counters.timestampNow('Test.Timestamp');
    counters.timestampNow('Test.Timestamp');
    counter = counters.get('Test.Timestamp', CounterType.Timestamp);
    counter.time; // Return time
    counters.stats('Test.Statistics', 1);
    counters.stats('Test.Statistics', 2);
    counters.stats('Test.Statistics', 3);
    counter = counters.get('Test.Statistics', CounterType.Statistics);
    counter.average;// Return 2
}
```

- **Information** - contextual information
* Example:

```dart
void main(){
    var config = ConfigParams.fromTuples([
        'name',
        'name',
        'description',
        'description',
        'properties.access_key',
        'key',
        'properties.store_key',
        'store key'
      ]);

      var contextInfo = ContextInfo.fromConfig(config);
      contextInfo.name; // Return 'name'
      contextInfo.description; // Return 'description'
}
```

- **Lock** - distributed locks
* Example:

```dart
void main() async {
    final String LOCK1 = 'lock_1';
    var _lock = MemoryLock();
    // Try to acquire lock for the first time
    try {
      var result = await _lock.tryAcquireLock('123', LOCK1, 3000);
      // result True
    } catch (err) {
      //...
    }
    // Try to acquire lock for the second time
    try {
      var result = await _lock.tryAcquireLock('123', LOCK1, 3000);
      // result False
    } catch (err) {
      //...
    }
    // Release the lock
    await _lock.releaseLock('123', LOCK1);
    // Try to acquire lock for the third time
    try {
      var result = await _lock.tryAcquireLock('123', LOCK1, 3000);
      // result True
    } catch (err) {
     //...
    }
    await _lock.releaseLock('123', LOCK1);
}
```

- **Log** - logging components
* Example:

```dart
void main(){
    var _logger = ConsoleLogger();
    _logger.setLevel(LogLevel.Trace);
    _logger.fatal(null, null, 'Fatal error message');
    _logger.error(null, null, 'Error message');
    _logger.warn(null, 'Warning message');
    _logger.info(null, 'Information message');
    _logger.debug(null, 'Debug message');
    _logger.trace(null, 'Trace message');

    try {
        // Raise an exception
        throw Exception();
      } catch (err) {
        var ex = ApplicationException().wrap(err);
        _logger.fatal('123', ex, 'Fatal error');
        _logger.error('123', ex, 'Recoverable error');
      }
}
```

- **Test** - component testing

In the help for each class there is a general example of its use. Also one of the quality sources
are the source code for the [**tests**](https://github.com/pip-services3-dart/pip-services3-components-dart/tree/master/test).

