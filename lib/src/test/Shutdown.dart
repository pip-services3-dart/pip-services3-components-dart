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
/// - mode:          null - crash by NullPointer excepiton, zero - crash by dividing by zero, excetion = crash by unhandled exception, exit - exit the process
/// - min_timeout:   minimum crash timeout in milliseconds (default: 5 mins)
/// - max_timeout:   maximum crash timeout in milliseconds (default: 15 minutes)
///
/// ### Example ###
///
///     let shutdown = new Shutdown();
///     shutdown.configure(ConfigParams.fromTuples(
///         "mode": "exception"
///     ));
///     shutdown.shutdown();         // Result: Bang!!! the process crashes

class Shutdown implements IConfigurable, IOpenable {
  Timer _interval;
  String _mode = 'exception';
  int _minTimeout = 300000;
  int _maxTimeout = 900000;

  /// Creates a new instance of the shutdown component.
  Shutdown() {}

  /// Configures component by passing configuration parameters.
  ///
  /// - config    configuration parameters to be set.
  void configure(ConfigParams config) {
    this._mode = config.getAsStringWithDefault('mode', this._mode);
    this._minTimeout =
        config.getAsIntegerWithDefault('min_timeout', this._minTimeout);
    this._maxTimeout =
        config.getAsIntegerWithDefault('max_timeout', this._maxTimeout);
  }

  /// Checks if the component is opened.
  ///
  /// Return true if the component has been opened and false otherwise.
  bool isOpen() {
    return this._interval != null;
  }

  /// Opens the component.
  ///
  /// - correlationId 	(optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives error or null no errors occured.
  Future open(String correlationId) {
    if (this._interval != null) this._interval.cancel();

    var timeout = RandomInteger.nextInteger(this._minTimeout, this._maxTimeout);
    this._interval =
        Timer.periodic(Duration(milliseconds: timeout), (Timer tm) {
      this.shutdown();
    });
  }

  /// Closes component and frees used resources.
  ///
  /// - correlationId 	(optional) transaction id to trace execution through call chain.
  /// - callback 			callback function that receives error or null no errors occured.
  Future close(String correlationId) {
    if (this._interval != null) {
      this._interval.cancel();
      this._interval = null;
    }
  }

  /// Crashes the process using the configured crash mode.
  void shutdown() {
    if (this._mode == 'null' || this._mode == 'nullpointer') {
      var obj = null;
      obj.crash = 123;
    } else if (this._mode == 'zero' || this._mode == 'dividebyzero') {
      var crash = 0 / 100;
    } else if (this._mode == 'exit' || this._mode == 'processexit') {
      exit(1);
    } else {
      var err = new ApplicationException(
          'test', null, 'CRASH', 'Crash test exception');
      throw err;
    }
  }
}
