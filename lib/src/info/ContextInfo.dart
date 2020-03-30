// /** @module info */
// /** @hidden */ 
// let os = require('os');

// import { StringValueMap } from 'pip-services3-commons-node';
// import { ConfigParams } from 'pip-services3-commons-node';
// import { IReconfigurable } from 'pip-services3-commons-node';

// /**
//  * Context information component that provides detail information
//  * about execution context: container or/and process.
//  * 
//  * Most often ContextInfo is used by logging and performance counters
//  * to identify source of the collected logs and metrics.
//  * 
//  * ### Configuration parameters ###
//  * 
//  * - name: 					the context (container or process) name
//  * - description: 		   	human-readable description of the context
//  * - properties: 			entire section of additional descriptive properties
//  * - ...
//  * 
//  * ### Example ###
//  * 
//  *     let contextInfo = new ContextInfo();
//  *     contextInfo.configure(ConfigParams.fromTuples(
//  *         "name", "MyMicroservice",
//  *         "description", "My first microservice"
//  *     ));
//  *     
//  *     context.name;			// Result: "MyMicroservice"
//  *     context.contextId;		// Possible result: "mylaptop"
//  *     context.startTime;		// Possible result: 2018-01-01:22:12:23.45Z
//  *     context.uptime;			// Possible result: 3454345
//  */
// export class ContextInfo implements IReconfigurable {	
// 	private _name: string = "unknown";
// 	private _description: string = null;
// 	private _contextId: string = os.hostname(); // IdGenerator.nextLong();
// 	private _startTime: Date = new Date();
// 	private _properties: StringValueMap = new StringValueMap();

// 	/**
// 	 * Creates a new instance of this context info.
// 	 * 
// 	 * @param name  		(optional) a context name.
// 	 * @param description 	(optional) a human-readable description of the context.
// 	 */
// 	public constructor(name?: string, description?: string) {
// 		this._name = name || "unknown";
// 		this._description = description || null;
// 	}

// 	/**
//      * Configures component by passing configuration parameters.
//      * 
//      * @param config    configuration parameters to be set.
// 	 */
// 	public configure(config: ConfigParams): void {
// 		this.name = config.getAsStringWithDefault("name", this.name);
// 		this.description = config.getAsStringWithDefault("description", this.description);		
// 		this.properties = config.getSection("properties");
// 	}
	
// 	/**
// 	 * Gets the context name.
// 	 * 
// 	 * @returns the context name 
// 	 */
// 	public get name(): string { return this._name; }

// 	/** 
// 	 * Sets the context name.
// 	 *  
// 	 * @param value		a new name for the context.
// 	 */
// 	public set name(value: string) { this._name = value || "unknown"; }
	
// 	/**
// 	 * Gets the human-readable description of the context.
// 	 * 
// 	 * @returns the human-readable description of the context.
// 	 */
// 	public get description(): string { return this._description; }

// 	/**
// 	 * Sets the human-readable description of the context.
// 	 * 
// 	 * @param value a new human readable description of the context.
// 	 */
// 	public set description(value: string) { this._description = value; }
	
// 	/**
// 	 * Gets the unique context id.
// 	 * Usually it is the current host name.
// 	 * 
// 	 * @returns the unique context id.
// 	 */
// 	public get contextId(): string { return this._contextId; }

// 	/**
// 	 * Sets the unique context id.
// 	 * 
// 	 * @param value a new unique context id.
// 	 */
// 	public set contextId(value: string) { this._contextId = value; }
	
// 	/**
// 	 * Gets the context start time.
// 	 * 
// 	 * @returns the context start time.
// 	 */
// 	public get startTime(): Date { return this._startTime; }

// 	/**
// 	 * Sets the context start time.
// 	 * 
// 	 * @param value a new context start time.
// 	 */
// 	public set startTime(value: Date) { this._startTime = value || new Date(); }

// 	/**
// 	 * Calculates the context uptime as from the start time.
// 	 * 
// 	 * @returns number of milliseconds from the context start time.
// 	 */
// 	public get uptime(): number {
// 		return new Date().getTime() - this._startTime.getTime();
// 	}

// 	/**
// 	 * Gets context additional parameters.
// 	 * 
// 	 * @returns a JSON object with additional context parameters.
// 	 */
// 	public get properties(): any { return this._properties; }

// 	/** 
// 	 * Sets context additional parameters.
// 	 * 
// 	 * @param properties 	a JSON object with context additional parameters
// 	*/
// 	public set properties(properties: any) {
// 		this._properties = StringValueMap.fromValue(properties);
// 	}
	
// 	/**
// 	 * Creates a new ContextInfo and sets its configuration parameters.
// 	 * 
// 	 * @param config 	configuration parameters for the new ContextInfo.
// 	 * @returns a newly created ContextInfo
// 	 */
// 	public static fromConfig(config: ConfigParams): ContextInfo {
// 		let result = new ContextInfo();
// 		result.configure(config);
// 		return result;
// 	}
// }
