import { readFileSync } from 'fs';
import {
    assertFails,
    assertSucceeds,
    initializeTestEnvironment,
    
  } from "@firebase/rules-unit-testing";
import { test } from 'mocha';



const PROJECT_ID = 'alcoholic-expressions';

const myUserData = {
  phoneNumber: '+27666354123',
  profileImageURL:'../my_user_image.jpg', 
  sectionName:'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
};

const theirUserData = {
  phoneNumber: '+27725643293',
  profileImageURL:'../their_user_image.jpg', 
  sectionName:'Dunbar-Mayville-Durban-Kwa Zulu-Natal-South Africa',
};

const storeOwnerData = {
  phoneNumber: '+27661813561',
  fullname: 'Lwandile',
  surname:'Ganyile',
  profileImageURL: '../+27661813561.jpg',
  identityDocumentImageURL: '../+27661813561.jpg',
  isAdmin: true,

};

const store1Data = {
  storeOwnerPhoneNumber: storeOwnerData.phoneNumber,
  storeImageURL: '../nkuxa_store_image.jpg',
  storeName: 'Ka Nkuxa',
  sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
};


const theirStoreOwnerData = {
  phoneNumber: '+27654543217',
  fullname: 'Miso',
  surname:'Makhanya',
  profileImageURL: '../+27654543217.jpg',
  identityDocumentImageURL: '..+27654543217.jpg',
  isAdmin: false,
};

const store2Data = {
  storeOwnerPhoneNumber: theirStoreOwnerData.phoneNumber,
  storeImageURL: '../gomora_store_image.jpg',
  storeName: 'Egomora',
  sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
};

const file5MB = Buffer.allocUnsafe(5*1024*1024);
const file6MB = Buffer.allocUnsafe(10*1024*1024);

const someId = '+27865654376';

describe('Our Alcoholic App',()=>{
  
  let testEnv = null;
  let myUser = null;
  let theirUser = null;
  let noUser = null;

  let storeOwnerUser = null;
  let theirStoreOwnerUser = null;
  
  beforeEach(async () => {
        
    testEnv = await initializeTestEnvironment({
      projectId: PROJECT_ID,
      // gs://alcoholic-expressions.appspot.co
      storage: {
        rules: readFileSync("../storage.rules", "utf8"),
        host: "127.0.0.1",
        port: "9199"
      },
      firestore: {
        rules: readFileSync("../firestore.rules", "utf8"),
          host: "127.0.0.1",
          port: "8080"
      },

    });
    
    // clear datastore
    await testEnv.clearStorage();
    await testEnv.clearFirestore();
    //await testEnv.cleanup();

    myUser = testEnv.authenticatedContext(myUserData.phoneNumber);
    theirUser = testEnv.authenticatedContext(theirUserData.phoneNumber);
    noUser = testEnv.unauthenticatedContext();

    storeOwnerUser = testEnv.authenticatedContext(storeOwnerData.phoneNumber);
    theirStoreOwnerUser = testEnv.authenticatedContext(theirStoreOwnerData.phoneNumber);
    
    
    // Initialize stores images
    await testEnv.withSecurityRulesDisabled(async context=>{

      return context.storage().ref()
      .child('/store_owners/stores_images/+27661813561')
      .put(file5MB).then()
    });
    await testEnv.withSecurityRulesDisabled(async context=>{

      return context.storage().ref()
      .child('/store_owners/stores_images/+27654543217')
      .put(file5MB).then()
    });

    // Initialize store owner images
    await testEnv.withSecurityRulesDisabled(async context=>{

      return context.storage().ref()
      .child(`/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`)
      .put(file5MB).then()
    });
    await testEnv.withSecurityRulesDisabled(async context=>{

      return context.storage().ref()
      .child(`/store_owners/store_owners_images/${theirStoreOwnerData.phoneNumber}`)
      .put(file5MB).then()
    });

    // Initialize store owner identity documents images
    await testEnv.withSecurityRulesDisabled(async context=>{
      return context.storage().ref()
      .child(`/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`)
      .put(file5MB).then()
    });

    await testEnv.withSecurityRulesDisabled(async context=>{
      return context.storage().ref()
      .child(`/store_owners/store_owners_ids/${storeOwnerData.phoneNumber}`)
      .put(file5MB).then()
    });

    // Initialize alcoholics profile images
    await testEnv.withSecurityRulesDisabled(async context=>{

      return context.storage().ref()
      .child(`/alcoholics/profile_images/${myUserData.phoneNumber}`)
      .put(file5MB).then()
    });

    await testEnv.withSecurityRulesDisabled(async context=>{

      return context.storage().ref()
      .child(`/alcoholics/profile_images/${theirUserData.phoneNumber}`)
      .put(file5MB).then()
    });


    // Initialize stores in the database.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(store1Data.storeOwnerPhoneNumber).set(store1Data);
    });
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(store2Data.storeOwnerPhoneNumber).set(store2Data);
    });

    // Initialize stores owners in the database.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('store_owners')
      .doc(storeOwnerData.phoneNumber).set(storeOwnerData);
    });
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('store_owners')
      .doc(theirStoreOwnerData.phoneNumber).set(theirStoreOwnerData);
    });

    // Initialize alcoholics in the database.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).set(myUserData);
    });
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(theirUserData.phoneNumber).set(theirUserData);
    });
 });

  afterEach(async () => {

    await testEnv.cleanup();
    
  });

  // ref.listAll()

  // const image = fs.readFileSync('./icon.png')
  // await assertSucceeds(
  // ref.put(image, { contentType: 'image/png' }).then()
  // )

  // await assertFails(ref.updateMetadata({})
  //================================Store Images [Start]====================================

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Offline User : Do not allow not logged in users to upload a store image during store registration.', async()=>{
    
    await assertFails(
      noUser.storage().ref()
      .child('/store_owners/stores_images/'+someId).put(file5MB)
      .then()
    );
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to upload store images with doc id different from their uid[1].', async()=>{
    
    await assertFails(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+someId).put(file5MB)
      .then()
    );
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to upload store images if they are already store owners[3].', async()=>{
    
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('store_owners')
      .doc(myUserData.phoneNumber).set(myUserData);
    });

    await assertFails(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+myUserData.phoneNumber).put(file5MB)
      .then()
    );
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to upload store images if they have already[4].', async()=>{
    
    const storeData = {
      storeOwnerPhoneNumber: myUserData.phoneNumber,
      storeImageURL: '../XXX_image.jpg',
      storeName: 'XXX',
      sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
    };
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(storeData.storeOwnerPhoneNumber).set(storeData);
    });

    await assertFails(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+myUserData.phoneNumber).put(file5MB)
      .then()
    );
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to upload store images with huge size[5].', async()=>{
    
    await assertFails(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+myUserData.phoneNumber).put(file6MB)
      .then()
    );
  });

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Allow logged in users to upload store images.', async()=>{
    
    await assertSucceeds(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+myUserData.phoneNumber).put(file5MB)
      .then()
    );
  });

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Store Owner : Do not allow store owners to upload store images.', async()=>{
    
    await assertFails(
      storeOwnerUser.storage().ref()
      .child('/store_owners/stores_images/'+store1Data.storeOwnerPhoneNumber).put(file5MB)
      .then()
    );
  }); 




  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Offline User : Allow not logged in users to view store images.', async()=>{
    
    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/${storeOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to view store images.', async()=>{
    
    const storage = myUser.storage();
      const storageRef = storage.ref()
      .child(`/store_owners/stores_images/${storeOwnerData.phoneNumber}`);

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Store Owner : Allow store owners to view store images.', async()=>{
    
    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/${storeOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  
  
  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Offline User : Do not allow not logged in users to delete store images.', async()=>{

    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/store1Id`,
      );

    await assertFails(storageRef.delete());
  }); 
  
  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to delete store images.', async()=>{

    const storage = myUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/store1Id`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Branch : store_resources_crud ->  store_resources_crud_storage_security_unit_testing
  // Testing /store_owners/stores_images/{storeImageId}
  it('Store Owner : Do not allow store owners to delete store images.', async()=>{

    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/store1Id`,
      );

    await assertFails(storageRef.delete());
  }); 

  //================================Store Images[End]==================================

});

