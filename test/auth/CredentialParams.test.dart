// let assert = require('chai').assert;

// import { CredentialParams } from '../../src/auth/CredentialParams';

// suite('CredentialParams', ()=> {

//     test('Gets and sets store key', (done) => {
// 		let сredential = new CredentialParams();
// 		сredential.setStoreKey(null);
// 		assert.isNull(сredential.getStoreKey());
		
// 		сredential.setStoreKey("Store key");
// 		assert.equal(сredential.getStoreKey(), "Store key");
// 		assert.isTrue(сredential.useCredentialStore());

//         done();
//     });    

//     test('Gets and sets username', (done) => {
// 		let сredential = new CredentialParams();
// 		сredential.setUsername(null);
// 		assert.isNull(сredential.getUsername());
		
// 		сredential.setUsername("Kate Negrienko");
// 		assert.equal(сredential.getUsername(), "Kate Negrienko");

//         done();
//     });    

//     test('Gets and sets password', (done) => {
// 		let сredential = new CredentialParams();
// 		сredential.setPassword(null);
// 		assert.isNull(сredential.getPassword());
		
// 		сredential.setPassword("qwerty");
// 		assert.equal(сredential.getPassword(), "qwerty");

//         done();
//     });    

//     test('Gets and sets access key', (done) => {
// 		let сredential = new CredentialParams();
// 		сredential.setAccessKey(null);
// 		assert.isNull(сredential.getAccessKey());
		
// 		сredential.setAccessKey("key");
// 		assert.equal(сredential.getAccessKey(), "key");

//         done();
//     });    


// });