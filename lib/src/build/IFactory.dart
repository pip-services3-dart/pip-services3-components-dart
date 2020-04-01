/// Interface for component factories.
///
/// Factories use locators to identify components to be created.
///
/// The locators are similar to those used to locate components in references.
/// They can be of any type like strings or integers. However Pip.Services toolkit
/// most often uses Descriptor objects as component locators.

abstract class IFactory {
  /// Checks if this factory is able to create component by given locator.
  ///
  /// This method searches for all registered components and returns
  /// a locator for component it is able to create that matches the given locator.
  /// If the factory is not able to create a requested component is returns null.
  ///
  /// - locator 	a locator to identify component to be created.
  /// Returns			a locator for a component that the factory is able to create.

  dynamic canCreate(dynamic locator);

  /// Creates a component identified by given locator.
  ///
  /// - locator 	a locator to identify component to be created.
  /// Returns the created component.
  ///
  /// Throws a CreateException if the factory is not able to create the component.

  dynamic create(dynamic locator);
}
