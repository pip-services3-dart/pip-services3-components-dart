// let assert = require('chai').assert;

// import { ConfigParams } from 'pip-services3-commons-node';

// import { ContextInfo } from '../../src/info/ContextInfo';

// suite('ContextInfo', ()=> {
//     let contextInfo: ContextInfo;

//     beforeEach(() => {
//         contextInfo = new ContextInfo();
//     });

//     test('Name', () => {
//         assert.equal(contextInfo.name, "unknown");

//         let update: string = "new name";
//         contextInfo.name = update;
//         assert.equal(contextInfo.name, update);
//     });    

//     test('Description', () => {
//         assert.isNull(contextInfo.description);

//         let update: string = "new description";
//         contextInfo.description = update;
//         assert.equal(contextInfo.description, update);
//     });    

//     test('ContextId', () => {
//         assert.isNotNull(contextInfo.contextId);

//         let update: string = "new context id";
//         contextInfo.contextId = update;
//         assert.equal(contextInfo.contextId, update);
//     });    

//     test('StartTime', () => {
//         var now = new Date();

//         assert.equal(contextInfo.startTime.getFullYear(), now.getFullYear());
//         assert.equal(contextInfo.startTime.getMonth(), now.getMonth());

//         contextInfo.startTime = new Date(1975, 4, 8);
//         assert.equal(contextInfo.startTime.getFullYear(), 1975);
//         assert.equal(contextInfo.startTime.getMonth(), 4);
//         assert.equal(contextInfo.startTime.getDate(), 8);
//     });    

//     test('FromConfig', () => {
//         let config: ConfigParams = ConfigParams.fromTuples(
//             "name", "new name",
//             "description", "new description",
//             "properties.access_key", "key",
//             "properties.store_key", "store key"
//         );

//         let contextInfo: ContextInfo = ContextInfo.fromConfig(config);
//         assert.equal(contextInfo.name, "new name");
//         assert.equal(contextInfo.description, "new description");
//     });    

// });
