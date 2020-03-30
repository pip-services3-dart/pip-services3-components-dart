// let assert = require('chai').assert;
// let async = require('async');

// import { ConfigParams } from 'pip-services3-commons-node';
// import { References } from 'pip-services3-commons-node';

// import { CredentialResolver } from '../../src/auth/CredentialResolver';

// suite('CredentialResolver', ()=> {
// 	let RestConfig = ConfigParams.fromTuples(
//         "credential.username", "Negrienko",
//         "credential.password", "qwerty",
//         "credential.access_key", "key",
//         "credential.store_key", "store key"
// 	);

//     test('Configure', (done) => {
// 		let credentialResolver = new CredentialResolver(RestConfig);
// 		let configList = credentialResolver.getAll();
		
//         assert.equal(configList[0].get("username"), "Negrienko");
// 		assert.equal(configList[0].get("password"), "qwerty");
// 		assert.equal(configList[0].get("access_key"), "key");
// 		assert.equal(configList[0].get("store_key"), "store key");

//         done();
//     });    
		
//     test('Lookup', (done) => {
//         async.series([
//             (callback) => {
//                 let credentialResolver = new CredentialResolver();
//                 credentialResolver.lookup("correlationId", (err, credential) => {
//                     assert.isNull(credential);
//                     callback(err);
//                 });
//             },
//             (callback) => {
//                 let RestConfigWithoutStoreKey = ConfigParams.fromTuples(
//                         "credential.username", "Negrienko",
//                         "credential.password", "qwerty",
//                         "credential.access_key", "key"
//                 );
//                 let credentialResolver = new CredentialResolver(RestConfigWithoutStoreKey);
//                 credentialResolver.lookup("correlationId", (err, credential) => {
//                     assert.equal(credential.get("username"), "Negrienko");
//                     assert.equal(credential.get("password"), "qwerty");
//                     assert.equal(credential.get("access_key"), "key");
//                     assert.isNull(credential.get("store_key"));
//                     callback(err);
//                 });
//             },
//             (callback) => {
//                 let credentialResolver = new CredentialResolver(RestConfig);
//                 credentialResolver.lookup("correlationId", (err, credential) => {
//                     assert.isNull(credential);
//                     callback(err);
//                 });
//             },
//             (callback) => {
//                 let credentialResolver = new CredentialResolver(RestConfig);
//                 credentialResolver.setReferences(new References());
//                 credentialResolver.lookup("correlationId", (err, credential) => {
//                     assert.isNotNull(err);
//                     assert.isNull(credential);
//                     callback();
//                 })
//             }
//         ], done);		
//     });

// });