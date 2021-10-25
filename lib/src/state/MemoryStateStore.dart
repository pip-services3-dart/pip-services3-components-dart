import 'package:pip_services3_commons/pip_services3_commons.dart';
import 'package:pip_services3_components/src/state/StateValue.dart';

import 'IStateStore.dart';
import 'StateEntry.dart';

/// State store that keeps states in the process memory.
///
/// Remember: This implementation is not suitable for synchronization of distributed processes.
///
/// ### Configuration parameters ###
///
/// __options:__
/// - timeout: default caching timeout in milliseconds (default: disabled)
///
/// See: [ICache]
///
/// ### Example ###
///
///     var store = MemoryStateStore();
///
///     var value = await store.load("123", "key1");
///     ...
///     await store.save("123", "key1", "ABC");
///
class MemoryStateStore implements IStateStore, IReconfigurable {
  Map<String, StateEntry> _states = {};
  int _timeout = 0;

  /// Configures component by passing configuration parameters.
  ///
  /// - [config] configuration parameters to be set.
  @override
  void configure(ConfigParams config) {
    _timeout = config.getAsLongWithDefault('options.timeout', _timeout);
  }

  /// Clears component state.
  void _cleanup() {
    if (_timeout == 0) return;

    var cutOffTime = DateTime.now().millisecondsSinceEpoch - _timeout;

    // Cleanup obsolete entries
    for (var key in _states.keys) {
      var entry = _states[key]!;
      // Remove obsolete entry
      if (entry.getLastUpdateTime() < cutOffTime) {
        _states.remove(key);
      }
    }
  }

  /// Loads stored value from the store using its key.
  /// If value is missing in the store it returns null.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key] a unique state key.
  /// Returns the state value or <code>null</code> if value wasn't found.
  @override
  Future<T?> load<T>(String? correlationId, String key) async {
    // Cleanup the stored states
    _cleanup();

    // Get entry from the store
    var entry = _states.containsKey(key) ? _states[key] : null;

    // Store has nothing
    if (entry == null) {
      return null;
    }

    return entry.getValue();
  }

  ///
  /// Loads an array of states from the store using their keys.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [keys] unique state keys.
  /// Returns an array with state values.
  @override
  Future<List<StateValue<T>>> loadBulk<T>(
      String? correlationId, List<String> keys) async {
    // Cleanup the stored states
    _cleanup();

    var result = <StateValue<T>>[];

    for (var key in keys) {
      var value = await load<T>(correlationId, key);
      result.add(StateValue(key, value));
    }

    return result;
  }

  /// Saves state into the store
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique state key.
  /// - [value]             a state value to store.
  /// Returns                 The value that was stored in the cache.
  @override
  Future<T> save<T>(String? correlationId, String key, value) async {
    // Cleanup the stored states
    _cleanup();

    // Get the entry
    var entry = _states.containsKey(key) ? _states[key] : null;

    // Shortcut to remove entry from the cache
    if (value == null) {
      _states.remove(key);
      return value;
    }

    // Update the entry
    if (entry != null) {
      entry.setValue(value);
    }
    // Or create a new entry
    else {
      entry = StateEntry(key, value);
      _states[key] = entry;
    }

    return value;
  }

  /// Deletes a state from the store by its key.
  ///
  /// - [correlationId]     (optional) transaction id to trace execution through call chain.
  /// - [key]               a unique state key.
  @override
  Future<T?> delete<T>(String? correlationId, String key) async {
    // Cleanup the stored states
    _cleanup();

    // Get the entry
    var entry = _states.containsKey(key) ? _states[key] : null;

    // Remove entry from the cache
    if (entry != null) {
      _states.remove(key);
      return entry.getValue();
    }

    return null;
  }
}
