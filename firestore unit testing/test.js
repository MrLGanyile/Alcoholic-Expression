import { readFileSync } from 'fs';
import {
    assertFails,
    assertSucceeds,
    initializeTestEnvironment,
    
  } from "@firebase/rules-unit-testing";



const PROJECT_ID = 'alcoholic-expressions';

const myUserData = {
  phoneNumber: '+27713498754',
  name:'Lwandile', 
  email:'lwa@gmail.com',
  profileImageURL: '../../nkuxa.jpg',
};

const theirUserData = {
  phoneNumber: '+27778908754',
  name:'Ntuthuko', 
  email:'gasa@gmail.com',
  profileImageURL: '../../ntuthuko.jpg',
};

const superiorAdminData = {
  phoneNumber: '+27834321212',
  profileImageURL: '../../image.jpg',
  isSuperiorAdmin: true,
};

const storeData = {
  storeOwnerPhoneNumber: superiorAdminData.phoneNumber,
  storeName: 'Nkuxa',
  sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
  imageURL: '../../image1.jpg',
  
};

const normalAdminData = {
  phoneNumber: '+27854567812',
  isAdmin: false,
  isSuperiorAdmin: false,
};

const someId = '+27826355532';

describe('Our Alcoholic App',()=>{
  
  let testEnv = null;
  let myUser = null;
  let theirUser = null;
  let noUser = null;

  let superiorAdminUser = null;
  let normalAdminUser = null;
  
  beforeEach(async () => {
        
    testEnv = await initializeTestEnvironment({
      projectId: "alcoholic-expressions",
      firestore: {
        rules: readFileSync("../firestore.rules", "utf8"),
          host: "127.0.0.1",
          port: "8080"
      },
    });
    
    // clear datastore
    await testEnv.clearFirestore();
    //await testEnv.cleanup();

    myUser = testEnv.authenticatedContext(myUserData.phoneNumber);
    theirUser = testEnv.authenticatedContext(theirUserData.phoneNumber);
    noUser = testEnv.unauthenticatedContext();

    superiorAdminUser = testEnv.authenticatedContext(superiorAdminData.phoneNumber);
    normalAdminUser = testEnv.authenticatedContext(normalAdminData.phoneNumber);
    

    // Initial alcoholics
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics').doc(myUserData.phoneNumber).set(myUserData);
    });
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics').doc(theirUserData.phoneNumber).set(theirUserData);
    });

    // Initialize admins
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins').doc(superiorAdminData.phoneNumber).set(superiorAdminData);
    });
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins').doc(normalAdminData.phoneNumber).set(normalAdminData);
    });

    // Initialize stores
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores').doc(storeData.storeOwnerPhoneNumber).set(storeData);
    });
    
 });

  afterEach(async () => {

    //await testEnv.clearFirestore();
    await testEnv.cleanup();
    
  });

});
