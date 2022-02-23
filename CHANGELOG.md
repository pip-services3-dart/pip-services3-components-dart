# <img src="https://uploads-ssl.webflow.com/5ea5d3315186cf5ec60c3ee4/5edf1c94ce4c859f2b188094_logo.svg" alt="Pip.Services Logo" width="200"> <br/> Component definitions for Dart Changelog

## 1.0.0

- Initial version, created by Sergey Seroukhov and Dmitry Levichev

## 1.0.2

- Fix registerAsType, create and canCreate method in Factory class.

## 1.0.3

- Fix access level to field in CachedLogger class.

## 1.0.4

- Fix json converter in LogMessage class.

## 1.0.5 

- Fix acquireLock method in Lock class.
- Change type of error in ILoger interface methods. Make auto wraping exceptions in ApplicationException type. 

## 1.0.6

- Fix working wiith time, convert all to UTC.

## 1.0.7

- **connect** added **CompositeConnectionResolver** and **ConnectionUtils**
- **ConnectionParams** added getProtocolWithDefault and getPortWithDefault methods

## 1.1.0

- Added **trace** module
- Added null-safety supports

## 1.1.1

- Replace **mustache_template** dependency with **pip_services3_expressions**


## 1.1.2

- Renamed Timing to CounterTiming
- Renamed ITimingCallback to ICounterTimingCallback
- Made optional param for CompositeTracer

## 1.2.0

- Added addChangeListener and removeChangeListener to IConfigReader

- Added state management components
- **state** Added IStateStore interface and StateValue class
- **state** Added NullStateStore class
- **state** Added MemoryStateStore class
- **state** Added DefaultStateStoreFactory class

## 1.2.1

- Fixed MemoryDiscovery class

## 1.2.2

- Fixed MemoryCredentialStore class