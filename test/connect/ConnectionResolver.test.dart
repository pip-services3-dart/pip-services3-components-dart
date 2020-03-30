// let assert = require('chai').assert;
// let async = require('async');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { References } from 'pip-services3-commons-node';

// import { ConnectionParams } from '../../src/connect/ConnectionParams';
// import { ConnectionResolver } from '../../src/connect/ConnectionResolver';

// suite('ConnectionResolver', ()=> {
// 	let RestConfig = ConfigParams.fromTuples(
//         "connection.protocol", "http",
//         "connection.host", "localhost",
//         "connection.port", 3000
// 	);

//     test('Configure', () => {
// 		let connectionResolver = new ConnectionResolver(RestConfig);
// 		let configList = connectionResolver.getAll();
// 		assert.equal(configList[0].get("protocol"), "http");
// 		assert.equal(configList[0].get("host"), "localhost");
// 		assert.equal(configList[0].get("port"), "3000");
//     });    
		
//     test('Register', (done) => {
// 		let connectionParams = new ConnectionParams();
// 		let connectionResolver = new ConnectionResolver(RestConfig);

//         async.series([
//             (callback) => {
//                 connectionResolver.register("correlationId", connectionParams, (err) => {
//                     assert.isNull(err);
//                     let configList = connectionResolver.getAll();
//                     assert.equal(configList.length, 1);

//                     callback();
//                 });
//             },
//             (callback) => {
//                 connectionResolver.register("correlationId", connectionParams, (err) => {
//                     assert.isNull(err);
//                     let configList = connectionResolver.getAll();
//                     assert.equal(configList.length, 1);

//                     callback();
//                 });
//             },
//             (callback) => {
//                 connectionParams.setDiscoveryKey("Discovery key value");
//                 let references = new References();
//                 connectionResolver.setReferences(references);
//                 connectionResolver.register("correlationId", connectionParams, (err) => {
//                     assert.isNull(err);
//                     let configList = connectionResolver.getAll();
//                     assert.equal(configList.length, 2);
//                     assert.equal(configList[0].get("protocol"), "http");
//                     assert.equal(configList[0].get("host"), "localhost");
//                     assert.equal(configList[0].get("port"), "3000");
//                     //assert.equal(configList[0].get("discovery_key"), "Discovery key value");

//                     callback();
//                 });
//             }
//         ], done);		
// 	});
	
//     test('Resolve', (done) => {
//         async.series([
//             (callback) => {
//                 let connectionResolver = new ConnectionResolver(RestConfig);
//                 connectionResolver.resolve("correlationId", (err, connectionParams) => {
//                     assert.isNull(err);

//                     assert.equal(connectionParams.get("protocol"), "http");
//                     assert.equal(connectionParams.get("host"), "localhost");
//                     assert.equal(connectionParams.get("port"), "3000");

//                     callback();
//                 });
//             },
//             (callback) => {
//                 let RestConfigDiscovery = ConfigParams.fromTuples(
//                     "connection.protocol", "http",
//                     "connection.host", "localhost",
//                     "connection.port", 3000,
//                     "connection.discovery_key", "Discovery key value"
//                 );
//                 let references = new References();
//                 let connectionResolver = new ConnectionResolver(RestConfigDiscovery , references);		
//                 connectionResolver.resolve("correlationId", (err, connectionParams) => {
//                     assert.isNotNull(err);
//                     assert.isNull(connectionParams);

//                     callback();
//                 });
//             }
//         ], done);		
// 	});

// });