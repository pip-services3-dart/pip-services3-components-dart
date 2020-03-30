// /** @module build */
// /** @hidden */ 
// let _ = require('lodash');

// import { IFactory } from './IFactory';
// import { CreateException } from './CreateException';

// /**
//  * Aggregates multiple factories into a single factory component.
//  * When a new component is requested, it iterates through 
//  * factories to locate the one able to create the requested component.
//  * 
//  * This component is used to conveniently keep all supported factories in a single place.
//  * 
//  * ### Example ###
//  * 
//  *     let factory = new CompositeFactory();
//  *     factory.add(new DefaultLoggerFactory());
//  *     factory.add(new DefaultCountersFactory());
//  *     
//  *     let loggerLocator = new Descriptor("*", "logger", "*", "*", "1.0");
//  *     factory.canCreate(loggerLocator); 		// Result: Descriptor("pip-service", "logger", "null", "default", "1.0")
//  *     factory.create(loggerLocator); 			// Result: created NullLogger
//  */
// export class CompositeFactory implements IFactory {
//     private _factories: IFactory[] = [];
	
// 	/**
// 	 * Creates a new instance of the factory.
// 	 * 
// 	 * @param factories 	a list of factories to embed into this factory.
// 	 */
// 	public constructor(...factories: IFactory[]) {
// 		if (factories != null)
//             this._factories = this._factories.concat(factories);
// 	}
	
// 	/**
// 	 * Adds a factory into the list of embedded factories.
// 	 * 
// 	 * @param factory 	a factory to be added.
// 	 */
// 	public add(factory: IFactory): void {
// 		if (factory == null)
// 			throw new Error("Factory cannot be null");
		
// 		this._factories.push(factory);
// 	}
	
// 	/**
// 	 * Removes a factory from the list of embedded factories.
// 	 * 
// 	 * @param factory 	the factory to remove.
// 	 */
// 	public remove(factory: IFactory): void {
// 		this._factories = _.remove(this._factories, f => f == factory);
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
// 		if (locator == null)
// 			throw new Error("Locator cannot be null");
		
// 		// Iterate from the latest factories
// 		for (let index = this._factories.length - 1; index >= 0; index--) {
// 			let thisLocator = this._factories[index].canCreate(locator);
//             if (thisLocator != null)
// 				return thisLocator;
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
// 		if (locator == null)
// 			throw new Error("Locator cannot be null");
		
// 		// Iterate from the latest factories
// 		for (let index = this._factories.length - 1; index >= 0; index--) {
//             let factory = this._factories[index];
// 			if (factory.canCreate(locator) != null)
// 				return factory.create(locator);
// 		}
		
// 		throw new CreateException(null, locator);
// 	}
	
// }
