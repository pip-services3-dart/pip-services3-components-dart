import 'StateValue.dart';

/// Interface for state storages that are used to store and retrieve transaction states.
abstract class IStateStore {
  /// Loads state from the store using its key.
  /// If value is missing in the store it returns null.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key] a unique state key.
  /// Returns the state value or <code>null</code> if value wasn't found.
  Future<T?> load<T>(String? correlationId, String key);

  /// Loads an array of states from the store using their keys.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [keys] unique state keys.
  /// Returns an array with state values and their corresponding keys.
  Future<List<StateValue<T>>> loadBulk<T>(
      String? correlationId, List<String> keys);

  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key]           a unique state key.
  /// - [value]         a state value.
  /// Return The state that was stored in the store.
  Future<T> save<T>(String? correlationId, String key, value);

  /// Deletes a state from the store by its key.
  ///
  /// - [correlationId] (optional) transaction id to trace execution through call chain.
  /// - [key] a unique value key.
  Future<T?> delete<T>(String? correlationId, String key);
}
