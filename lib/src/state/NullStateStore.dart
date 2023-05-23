import 'package:pip_services3_components/src/state/IStateStore.dart';
import 'package:pip_services3_components/src/state/StateValue.dart';

/// Dummy state store implementation that doesn't do anything.
///
/// It can be used in testing or in situations when state management is not required
/// but shall be disabled.
///
/// See [ICache]
class NullStateStore implements IStateStore {
  /// Loads state from the store using its key.
  /// If value is missing in the stored it returns null.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key] a unique state key.
  /// Returns the state value or <code>null</code> if value wasn't found.
  @override
  Future<T?> load<T>(String? correlationId, String key) async {
    return null;
  }

  /// Loads an array of states from the store using their keys.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [keys] unique state keys.
  /// Returns an array with state values and their corresponding keys.
  ///
  @override
  Future<List<StateValue<T>>> loadBulk<T>(
      String? correlationId, List<String> keys) async {
    return [];
  }

  /// Saves state into the store.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key] a unique state key.
  /// - [value] a state value.
  /// @returns The state that was stored in the store.
  @override
  Future<T> save<T>(String? correlationId, String key, value) {
    return value;
  }

  /// Deletes a state from the store by its key.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key] a unique value key.
  ///
  @override
  Future<T?> delete<T>(String? correlationId, String key) async {
    return null;
  }
}
