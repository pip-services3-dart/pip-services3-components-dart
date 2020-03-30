// /** @module build */
// import { IFactory } from './IFactory';
// import { CreateException } from './CreateException';

// class Registration {
//     public locator: any;
//     public factory: (locator: any) => any;
// }

// /**
//  * Basic component factory that creates components using registered types and factory functions.
//  * 
//  * #### Example ###
//  * 
//  *     let factory = new Factory();
//  *     
//  *     factory.registerAsType(
//  *         new Descriptor("mygroup", "mycomponent1", "default", "*", "1.0"),
//  *         MyComponent1
//  *     );
//  *     factory.register(
//  *         new Descriptor("mygroup", "mycomponent2", "default", "*", "1.0"),
//  *         (locator) => {
//  *             return new MyComponent2();
//  *         }
//  *     );
//  *     
//  *     factory.create(new Descriptor("mygroup", "mycomponent1", "default", "name1", "1.0"))
//  *     factory.create(new Descriptor("mygroup", "mycomponent2", "default", "name2", "1.0"))
//  * 
//  * @see [[https://rawgit.com/pip-services-node/pip-services3-commons-node/master/doc/api/classes/refer.descriptor.html Descriptor]]
//  * @see [[IFactory]]
//  */
// export class Factory implements IFactory {	
// 	private _registrations: Registration[] = [];

// 	/**
// 	 * Registers a component using a factory method.
// 	 * 
// 	 * @param locator 	a locator to identify component to be created.
// 	 * @param factory   a factory function that receives a locator and returns a created component.
// 	 */
// 	public register(locator: any, factory: (locator: any) => any): void {
// 		if (locator == null)
// 			throw new Error("Locator cannot be null");
// 		if (factory == null)
// 			throw new Error("Factory cannot be null");
		
// 		this._registrations.push({
//             locator: locator,
//             factory: factory
//         });
// 	}

// 	/**
// 	 * Registers a component using its type (a constructor function).
// 	 * 
// 	 * @param locator 		a locator to identify component to be created.
// 	 * @param type 			a component type.
// 	 */
// 	public registerAsType(locator: any, type: any): void {
// 		if (locator == null)
// 			throw new Error("Locator cannot be null");
// 		if (type == null)
// 			throw new Error("Factory cannot be null");
		
// 		this._registrations.push({
//             locator: locator,
//             factory: (locator) => { return new type(); }
//         });
// 	}
	
// 	/**
// 	 * Checks if this factory is able to create component by given locator.
// 	 * 
// 	 * This method searches for all registered components and returns
// 	 * a locator for component it is able to create that matches the given locator.
// 	 * If the factory is not able to create a requested component is returns null.
// 	 * 
// 	 * @param locator 	a locator to identify component to be created.
// 	 * @returns			a locator for a component that the factory is able to create.
// 	 */
// 	public canCreate(locator: any): any {
//         for (let index = 0; index < this._registrations.length; index++) {
//             let registration = this._registrations[index];
// 			let thisLocator = registration.locator;
// 			if (thisLocator == locator || (thisLocator.equals && thisLocator.equals(locator)))
//                 return thisLocator;
// 		}
// 		return null;
// 	}

// 	/**
// 	 * Creates a component identified by given locator.
// 	 * 
// 	 * @param locator 	a locator to identify component to be created.
// 	 * @returns the created component.
// 	 * 
// 	 * @throws a CreateException if the factory is not able to create the component.
// 	 */
// 	public create(locator: any): any {
//         for (let index = 0; index < this._registrations.length; index++) {
//             let registration = this._registrations[index];
// 			let thisLocator = registration.locator;

// 			if (thisLocator == locator || (thisLocator.equals && thisLocator.equals(locator)))
// 				try {
// 					return registration.factory(locator);
// 				} catch (ex) {
// 					if (ex instanceof CreateException)
// 						throw ex;
					
// 					throw new CreateException(
// 						null, 
// 						"Failed to create object for " + locator
// 					).withCause(ex);
// 				}
// 		}
// 		return null;
// 	}
	
// }
