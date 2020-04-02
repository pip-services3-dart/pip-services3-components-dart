import 'dart:async';
import 'dart:io';
import 'package:pip_services3_commons/pip_services3_commons.dart';

/// Random shutdown component that crashes the process
/// using various methods.
///
/// The component is usually used for testing, but brave developers
/// can try to use it in production to randomly crash microservices.
/// It follows the concept of "Chaos Monkey" popularized by Netflix.
///
/// ### Configuration parameters ###
///
/// - [mode]:          null - crash by NullPointer excepiton, zero - crash by dividing by zero, excetion = crash by unhandled exception, exit - exit the process
/// - [min_timeout]:   minimum crash timeout in milliseconds (default: 5 mins)
/// - [max_timeout]:   maximum crash timeout in milliseconds (default: 15 minutes)
///
/// ### Example ###
///
///     var shutdown = Shutdown();
///     shutdown.configure(ConfigParams.fromTuples([
///         "mode": "exception"
///     ]));
///     shutdown.shutdown();         // Result: Bang!!! the process crashes

class Shutdown implements IConfigurable, IOpenable {
  Timer _interval;
  String _mode = 'exception';
  int _minTimeout = 300000;
  int _maxTimeout = 900000;

  /// Creates a new instance of the shutdown component.
  Shutdown();

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _mode = config.getAsStringWithDefault('mode', _mode);
    _minTimeout = config.getAsIntegerWithDefault('min_timeout', _minTimeout);
    _maxTimeout = config.getAsIntegerWithDefault('max_timeout', _maxTimeout);
  }

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.
  @override
  bool isOpen() {
    return _interval != null;
  }

  /// Opens the component.
  ///
  /// - correlationId 	(optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives error or null no errors occured.
  @override
  Future open(String correlationId) async {
    if (_interval != null) _interval.cancel();

    var timeout = RandomInteger.nextInteger(_minTimeout, _maxTimeout);
    _interval = Timer.periodic(Duration(milliseconds: timeout), (Timer tm) {
      shutdown();
    });
  }

  /// Closes component and frees used resources.
  ///
  /// - correlationId 	(optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives error or null no errors occured.
  @override
  Future close(String correlationId) async {
    if (_interval != null) {
      _interval.cancel();
      _interval = null;
    }
  }

  /// Crashes the process using the configured crash mode.
  void shutdown() {
    if (_mode == 'null' || _mode == 'nullpointer') {
      var obj;
      obj.crash = 123;
    } else if (_mode == 'zero' || _mode == 'dividebyzero') {
      var crash = 0 / 100;
    } else if (_mode == 'exit' || _mode == 'processexit') {
      exit(1);
    } else {
      var err =
          ApplicationException('test', null, 'CRASH', 'Crash test exception');
      throw err;
    }
  }
}
