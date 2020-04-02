import '../../pip_services3_components.dart';

/// Aggregates multiple factories into a single factory component.
/// When a new component is requested, it iterates through
/// factories to locate the one able to create the requested component.
///
/// This component is used to conveniently keep all supported factories in a single place.
///
/// ### Example ###
///
///     var factory = new CompositeFactory();
///     factory.add(new DefaultLoggerFactory());
///     factory.add(new DefaultCountersFactory());
///
///     var loggerLocator = new Descriptor("*", "logger", "*", "*", "1.0");
///     factory.canCreate(loggerLocator); 		// Result: Descriptor("pip-service", "logger", "null", "default", "1.0")
///     factory.create(loggerLocator); 			  // Result: created NullLogger
class CompositeFactory implements IFactory {
  List<IFactory> _factories = List<IFactory>();

  /// Creates a new instance of the factory.
  ///
  /// - factories 	a list of factories to embed into this factory.
  CompositeFactory(List<IFactory> factories) {
    if (factories != null)
      this._factories.addAll(factories);
  }

  /// Adds a factory into the list of embedded factories.
  ///
  /// - factory 	a factory to be added.
  void add(IFactory factory) {
    if (factory == null)
      throw Exception("Factory cannot be null");

    this._factories.add(factory);
  }

  /// Removes a factory from the list of embedded factories.
  ///
  /// - factory 	the factory to remove.
  void remove(IFactory factory) {
    this._factories.remove(factory);
  }

  /// Checks if this factory is able to create component by given locator.
  ///
  /// This method searches for all registered components and returns
  /// a locator for component it is able to create that matches the given locator.
  /// If the factory is not able to create a requested component is returns null.
  ///
  /// - locator 	a locator to identify component to be created.
  /// Return			a locator for a component that the factory is able to create.
  canCreate(locator) {
    if (locator == null)
      throw Exception("Locator cannot be null");

    // Iterate from the latest factories
    for (var index = this._factories.length - 1; index >= 0; index--) {
      var thisLocator = this._factories[index].canCreate(locator);
      if (thisLocator != null) return thisLocator;
    }

    return null;
  }

  /// Creates a component identified by given locator.
  ///
  /// - locator 	a locator to identify component to be created.
  /// Return the created component.
  ///
  /// Trows a CreateException if the factory is not able to create the component.
  create(locator) {
    if (locator == null)
      throw Exception("Locator cannot be null");

    // Iterate from the latest factories
    for (var index = this._factories.length - 1; index >= 0; index--) {
      var factory = this._factories[index];
      if (factory.canCreate(locator) != null)
        return factory.create(locator);
    }

    throw new CreateException(null, locator);
  }
}
