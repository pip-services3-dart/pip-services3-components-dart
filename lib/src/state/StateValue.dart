/// A data object that holds a retrieved state value with its key.
class StateValue<T> {
  /// A unique state key
  String key;

  /// A stored state value;
  T? value;

  StateValue(String key, T? value)
      : key = key,
        value = value;
}
