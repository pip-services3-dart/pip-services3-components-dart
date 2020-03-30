
import './IFactory.dart';
import './CreateException.dart';

class Registration {
    dynamic locator;
    Function (dynamic locator) factory_;

    Registration(dynamic locator, factory_ (dynamic locator)):this.locator=locator, this.factory_= factory_ 
    {
    }

}


/**
 * Basic component factory that creates components using registered types and factory functions.
 * 
 * #### Example ###
 * 
 *     var factory = new Factory();
 *     
 *     factory.registerAsType(
 *         new Descriptor("mygroup", "mycomponent1", "default", "*", "1.0"),
 *         MyComponent1
 *     );
 *     factory.register(
 *         new Descriptor("mygroup", "mycomponent2", "default", "*", "1.0"),
 *         (locator) => {
 *             return new MyComponent2();
 *         }
 *     );
 *     
 *     factory.create(new Descriptor("mygroup", "mycomponent1", "default", "name1", "1.0"))
 *     factory.create(new Descriptor("mygroup", "mycomponent2", "default", "name2", "1.0"))
 * 
 * See [https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/refer.descriptor.html Descriptor]
 * See [IFactory]
 */
class Factory implements IFactory {	
	List<Registration> _registrations = List<Registration>();

	/**
	 * Registers a component using a factory method.
	 * 
	 * - locator 	a locator to identify component to be created.
	 * - factory   a factory function that receives a locator and returns a created component.
	 */
	void register(dynamic locator, factory_ (dynamic locator)) {
		if (locator == null)
			throw new Error("Locator cannot be null");
		if (factory_ == null)
			throw new Error("Factory cannot be null");
		
		this._registrations.add( Registration(locator, factory_));
	}

	/**
	 * Registers a component using its type (a constructor function).
	 * 
	 * - locator 		a locator to identify component to be created.
	 * - type 			a component type.
	 */
	void registerAsType(dynamic locator, dynamic type) {
		if (locator == null)
			throw new Error("Locator cannot be null");
		if (type == null)
			throw new Error("Factory cannot be null");
		this._registrations.add(Registration(locator, (locator) {return type();} ));
	}
	
	/**
	 * Checks if this factory is able to create component by given locator.
	 * 
	 * This method searches for all registered components and returns
	 * a locator for component it is able to create that matches the given locator.
	 * If the factory is not able to create a requested component is returns null.
	 * 
	 * - locator 	a locator to identify component to be created.
	 * Return			a locator for a component that the factory is able to create.
	 */
	dynamic canCreate(dynamic locator) {
        for (var index = 0; index < this._registrations.length; index++) {
            var registration = this._registrations[index];
			var thisLocator = registration.locator;
			if (thisLocator == locator || (thisLocator.equals && thisLocator.equals(locator)))
                return thisLocator;
		}
		return null;
	}

	/**
	 * Creates a component identified by given locator.
	 * 
	 * - locator 	a locator to identify component to be created.
	 * Return the created component.
	 * 
	 * Trows a CreateException if the factory is not able to create the component.
	 */
	dynamic create(dynamic locator) {
        for (var index = 0; index < this._registrations.length; index++) {
            var registration = this._registrations[index];
			var thisLocator = registration.locator;

			if (thisLocator == locator || (thisLocator.equals && thisLocator.equals(locator)))
				try {
					return registration.factory_(locator);
				} catch (ex) {
					if (ex is CreateException)
						throw ex;
					
					throw new CreateException(
						null, 
						"Failed to create object for " + locator
					).withCause(ex);
				}
		}
		return null;
	}
	
}
