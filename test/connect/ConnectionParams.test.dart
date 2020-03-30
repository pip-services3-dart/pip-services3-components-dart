// let assert = require('chai').assert;

// import { ConnectionParams } from '../../src/connect/ConnectionParams';

// suite('ConnectionParams', ()=> {

//     test('Gets and sets discovery key', () => {
// 		let connection = new ConnectionParams();
// 		connection.setDiscoveryKey(null);
// 		assert.isNull(connection.getDiscoveryKey());
		
// 		connection.setDiscoveryKey("Discovery key value");
// 		assert.equal(connection.getDiscoveryKey(), "Discovery key value");
// 		assert.isTrue(connection.useDiscovery());
// 	});
	
//     test('Gets and sets protocol', () => {
// 		let connection = new ConnectionParams();
// 		connection.setProtocol(null);
// 		assert.isNull(connection.getProtocol());
// 		assert.isNull(connection.getProtocol(null));
// 		assert.equal(connection.getProtocol("https"), "https");
		
// 		connection.setProtocol("https");
// 		assert.equal(connection.getProtocol(), "https");
// 	});

//     test('Gets and sets host', () => {
// 		let connection = new ConnectionParams();
// 		assert.isNull(connection.getHost());
// 		connection.setHost(null);
// 		assert.isNull(connection.getHost());
		
// 		connection.setHost("localhost");
// 		assert.equal(connection.getHost(), "localhost");
// 	});

//     test('Gets and sets port', () => {
// 		let connection = new ConnectionParams();
// 		assert.isNull(connection.getHost());
		
// 		connection.setPort(3000);
// 		assert.equal(connection.getPort(), 3000);
// 	});

//     test('Gets and sets uri', () => {
// 		let connection = new ConnectionParams();
// 		assert.isNull(connection.getUri());
		
// 		connection.setUri("https://pipgoals:3000");
// 		assert.equal(connection.getUri(), "https://pipgoals:3000");
// 	});

// });