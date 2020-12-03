# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Component definitions for Dart

This module is a part of the [Pip.Services](http://pipservices.org) polyglot microservices toolkit.

The Components module contains standard component definitions that can be used to build applications and services.

The module contains the following packages:
- **Auth** - authentication credential stores
- **Build** - basic factories for constructing objects
- **Cache** - distributed cache
- **Config** - configuration readers and managers, whose main task is to deliver configuration parameters to the application from wherever they are being stored
- **Connect** - connection discovery and configuration services
- **Count** - performance counters
- **Info** - context info implementations that manage the saving of process information and sending additional parameter sets
- **Lock** -  distributed lock components
- **Log** - basic logging components that provide console and composite logging, as well as an interface for developing custom loggers
- **Test** - minimal set of test components to make testing easier
- **Component** - the root package

<a name="links"></a> Quick links:

* [Logging](https://www.pipservices.org/recipies/logging)
* [Configuration](https://www.pipservices.org/recipies/configuration) 
* [API Reference](https://pub.dev/documentation/pip_services3_components/latest/pip_services3_components/pip_services3_components-library.html)
* [Change Log](CHANGELOG.md)
* [Get Help](https://www.pipservices.org/community/help)
* [Contribute](https://www.pipservices.org/community/contribute)
* [Examples](https://github.com/pip-services3-dart/pip-services3-components-dart/blob/master/example/README.md)


* Warning!
Config package now not work with condition **{{#if var}} something {{/}}** in config files.
Use **Mustache** syntax, for example **{{#var}} something {{/var}}**

## Use

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  pip_services3_components: version
```

Now you can install package from the command line:
```bash
pub get
```

Example how to use Logging and Performance counters.
Here we are going to use CompositeLogger and CompositeCounters components.
They will pass through calls to loggers and counters that are set in references.

```dart
import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_commons/src/config/IConfigurable.dart';
import 'package:pip_services3_commons/src/refer/IReferences.dart';
import 'package:pip_services3_commons/src/refer/IReferenceable.dart';
import 'package:pip_services3_components/src/log/CompositeLogger.dart';
import 'package:pip_services3_components/src/count/CompositeCounters.dart';
import 'package:pip_services3_components/src/count/Timing.dart';


class MyComponent implements IConfigurable, IReferenceable {
  CompositeLogger _logger = CompositeLogger();
  CompositeCounters _counters = CompositeCounters();
  
  configure(ConfigParams config) {
    this._logger.configure(config);
  }
  
  setReferences(IReferences refs) {
    this._logger.setReferences(refs);
    this._counters.setReferences(refs);
  }
  
  myMethod(String correlationId, dynamic param1) {
    try{
      this._logger.trace(correlationId, "Executed method mycomponent.mymethod");
      this._counters.increment("mycomponent.mymethod.exec_count", 1);
      Timing timing = this._counters.beginTiming("mycomponent.mymethod.exec_time");
      ....
      timing.endTiming();
    } catch(e) {
      this._logger.error(correlationId, e, "Failed to execute mycomponent.mymethod");
      this._counters.increment("mycomponent.mymethod.error_count", 1);
    }
  }
}
```

Example how to get connection parameters and credentials using resolvers.
The resolvers support "discovery_key" and "store_key" configuration parameters
to retrieve configuration from discovery services and credential stores respectively.

```dart
import 'package:pip_services3_commons/src/config/ConfigParams.dart';
import 'package:pip_services3_commons/src/config/IConfigurable.dart';
import 'package:pip_services3_commons/src/refer/IReferences.dart';
import 'package:pip_services3_commons/src/refer/IReferenceable.dart';
import 'package:pip_services3_commons/src/run/IOpenable.dart';
import 'package:pip_services3_components/src/connect/ConnectionParams.dart';
import 'package:pip_services3_components/src/connect/ConnectionResolver.dart';
import 'package:pip_services3_components/src/auth/CredentialParams.dart';
import 'package:pip_services3_components/src/auth/CredentialResolver.dart';


class MyComponent implements IConfigurable, IReferenceable, IOpenable {
  ConnectionResolver _connectionResolver = ConnectionResolver();
  CredentialResolver _credentialResolver = CredentialResolver();
  
  configure(ConfigParams config) {
    this._connectionResolver.configure(config);
    this._credentialResolver.configure(config);
  }
  
  setReferences(IReferences refs) {
    this._connectionResolver.setReferences(refs);
    this._credentialResolver.setReferences(refs);
  }
  
  ...
  
  open(String correlationId) async{

      ConnectionParams connection = await this._connectionResolver.resolve(correlationId);
      
      CredentialParams credential = await this._credentialResolver.lookup(correlationId);
      
      String host = connection.getHost();
      int port = connection.getPort();
      String user = credential.getUsername();
      String pass = credential.getPassword();
        ...
      }
    }
  }
}
```

Example how to use caching and locking.
Here we assume that references are passed externally.

```dart

import 'package:pip_services3_commons/src/refer/Descriptor.dart';
import 'package:pip_services3_commons/src/refer/References.dart';
import 'package:pip_services3_commons/src/refer/IReferences.dart';
import 'package:pip_services3_commons/src/refer/IReferenceable.dart';
import 'package:pip_services3_components/src/lock/ILock.dart';
import 'package:pip_services3_components/src/lock/MemoryLock.dart';
import 'package:pip_services3_components/src/cache/ICache.dart';
import 'package:pip_services3_components/src/cache/MemoryCache.dart';


class MyComponent implements IReferenceable {
  ICache _cache;
  ILock _lock;
  
  setReferences(IReferences refs) {
    this._cache = refs.getOneRequired<ICache>(Descriptor("*", "cache", "*", "*", "1.0"));
    this._lock = refs.getOneRequired<ILock>(Descriptor("*", "lock", "*", "*", "1.0"));
  }
  
  myMethod(String correlationId, dynamic param1) async {
    // First check cache for result
    dynamic result = await this._cache.retrieve(correlationId, "mykey")
      
      // Lock..
      this._lock.acquireLock(correlationId, "mykey", 1000, 1000)
        
      // Do processing
      ...
      
      // Store result to cache async
      this._cache.store(correlationId, "mykey", result, 3600000);

      // Release lock async
      this._lock.releaseLock(correlationId, "mykey");
      
      };
    }
  }
}

// Use the component
MyComponent myComponent = new MyComponent();

myComponent.setReferences(References.fromTuples([
  Descriptor("pip-services", "cache", "memory", "default", "1.0"), MemoryCache(),
  Descriptor("pip-services", "lock", "memory", "default", "1.0"), MemoryLock(),
]);

myComponent.myMethod(null);
```

If you need to create components using their locators (descriptors) implement 
component factories similar to the example below.

```dart
import 'package:pip_services3_components/src/build/Factory.dart';
import 'package:pip_services3_commons/src/refer/Descriptor.dart';


class MyFactory extends Factory {
  static Descriptor myComponentDescriptor  = new Descriptor("myservice", "mycomponent", "default", "*", "1.0");
  
  MyFactory():super() {
    this.registerAsType(MyFactory.myComponentDescriptor, MyComponent);    
  }
}

// Using the factory

MyFactory myFactory = MyFactory();

MyComponent1 myComponent1 = myFactory.create(new Descriptor("myservice", "mycomponent", "default", "myComponent1", "1.0"));
MyComponent2 myComponent2 = myFactory.create(new Descriptor("myservice", "mycomponent", "default", "myComponent2", "1.0"));
...
```

## Develop

For development you shall install the following prerequisites:
* Dart SDK 2
* Visual Studio Code or another IDE of your choice
* Docker

Install dependencies:
```bash
pub get
```

Run automated tests:
```bash
pub run test
```

Generate API documentation:
```bash
./docgen.ps1
```

Before committing changes run dockerized build and test as:
```bash
./build.ps1
./test.ps1
./clear.ps1
```

## Contacts

The library is created and maintained by **Sergey Seroukhov** and **Levichev Dmitry**.

The documentation is written by **Egor Nuzhnykh**, **Alexey Dvoykin**, **Mark Makarychev**, **Levichev Dmitry**.
