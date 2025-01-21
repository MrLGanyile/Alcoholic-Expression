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

  // Testing /store_owners/stores_images/{storeImageId}
  it('Offline User : Do not allow not logged in users to upload a store image during store registration.', async()=>{
    
    await assertFails(
      noUser.storage().ref()
      .child('/store_owners/stores_images/'+someId).put(file5MB)
      .then()
    );
  }); 

  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to upload store images with doc id different from their uid[1].', async()=>{
    
    await assertFails(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+someId).put(file5MB)
      .then()
    );
  }); 

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

  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to upload store images with huge size[5].', async()=>{
    
    await assertFails(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+myUserData.phoneNumber).put(file6MB)
      .then()
    );
  });

  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Allow logged in users to upload store images.', async()=>{
    
    await assertSucceeds(
      myUser.storage().ref()
      .child('/store_owners/stores_images/'+myUserData.phoneNumber).put(file5MB)
      .then()
    );
  });

  // Testing /store_owners/stores_images/{storeImageId}
  it('Store Owner : Do not allow store owners to upload store images.', async()=>{
    
    await assertFails(
      storeOwnerUser.storage().ref()
      .child('/store_owners/stores_images/'+store1Data.storeOwnerPhoneNumber).put(file5MB)
      .then()
    );
  }); 





  // Testing /store_owners/stores_images/{storeImageId}
  it('Offline User : Allow not logged in users to view store images.', async()=>{
    
    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/${storeOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to view store images.', async()=>{
    
    const storage = myUser.storage();
      const storageRef = storage.ref()
      .child(`/store_owners/stores_images/${storeOwnerData.phoneNumber}`);

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/stores_images/{storeImageId}
  it('Store Owner : Allow store owners to view store images.', async()=>{
    
    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/${storeOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  
  

  // Testing /store_owners/stores_images/{storeImageId}
  it('Offline User : Do not allow not logged in users to delete store images.', async()=>{

    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/store1Id`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/stores_images/{storeImageId}
  it('Online User : Do not allow logged in users to delete store images.', async()=>{

    const storage = myUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/store1Id`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/stores_images/{storeImageId}
  it('Store Owner : Do not allow store owners to delete store images.', async()=>{

    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/stores_images/store1Id`,
      );

    await assertFails(storageRef.delete());
  }); 

  //================================Store Images[End]==================================

 //================================Store Owner Images[Start]==================================
  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Offline User : Do not allow not logged in users to upload a store owner image.', async()=>{
    
    await assertFails(
      noUser.storage().ref()
      .child(`/store_owners/store_owners_images/${someId}`).put(file5MB)
      .then()
    );
  }); 

  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Online User : Do not allow logged in users to upload a store owner image if it document id is not the same as the store owner document id[2].', async()=>{
    
    await assertFails(
      myUser.storage().ref()
      .child(`/store_owners/store_owners_images/${someId}`)
      .put(file5MB).then()
    );
  }); 

  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Online User : Do not allow logged in users to upload a store owner image if the store does not already exist[4].', async()=>{
    
    await assertFails(
      theirUser.storage().ref()
      .child(`/store_owners/store_owners_images/${theirUserData.phoneNumber}`)
      .put(file5MB).then()
    );
  });

  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Online User : Do not allow logged in users to upload a store owner image if the store owner already exist[5].', async()=>{
    
    const ownerData = {
      phoneNumber: myUserData.phoneNumber,
      fullname: 'Nomusa',
      surname:'Sukude',
      profileImageURL: `../${myUserData.phoneNumbe}.jpg`,
      identityDocumentImageURL: `../${myUserData.phoneNumbe}.jpg`,
      isAdmin: false,
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('store_owners')
      .doc(ownerData.phoneNumber).set(ownerData);
    });

    
    await assertFails(
      myUser.storage().ref()
      .child(`/store_owners/store_owners_images/${myUserData.phoneNumber}`)
      .put(file5MB).then()
    );
  });

  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Online User : Do not allow logged in users to upload a store owner image with huge size[6].', async()=>{
    
    const storeData = {
      storeOwnerPhoneNumber: myUserData.phoneNumber,
      storeImageURL: '../mathayini_image.jpg',
      storeName: 'Mathayini',
      sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(storeData.storeOwnerPhoneNumber).set(storeData);
    });

    await assertFails(
      myUser.storage().ref()
      .child(`/store_owners/store_owners_images/${myUserData.phoneNumber}`)
      .put(file6MB).then()
    );
  });

  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Online User : Allow logged in users to upload a store owner image if the store already exist[7].', async()=>{
    
    const storeData = {
      storeOwnerPhoneNumber: theirUserData.phoneNumber,
      storeImageURL: '../mathayini_image.jpg',
      storeName: 'Mathayini',
      sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(storeData.storeOwnerPhoneNumber).set(storeData);
    });

    await assertSucceeds(
      theirUser.storage().ref()
      .child(`/store_owners/store_owners_images/${theirUserData.phoneNumber}`)
      .put(file5MB).then()
    );
  });

  // Testing /store_owners/store_owner_images/{storeOwnerImageId}
  it('Store Owner : Do not allow store owners to upload store owner images.', async()=>{
    
    await assertFails(
      storeOwnerUser.storage().ref()
      .child('/store_owners/store_owners_images/'+storeOwnerData.phoneNumber)
      .put(file5MB).then()
    );
  }); 





  // Testing /store_owners/store_owners_images/{storeOwnerImageId}
  it('Offline User : Allow not logged in users to view store owner images.', async()=>{
    
    const storage = noUser.storage();
      const storageRef = storage.ref(
       `/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/store_owners_images/{storeImageId}
  it('Online User : Allow logged in users to view store owner images.', async()=>{
    
    const storage = myUser.storage();
      const storageRef = storage.ref()
      .child(`/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`);

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/store_owners_images/{storeOwnerImageId}
  it('Store Owner : Allow store owners to view store owner images.', async()=>{
    
    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 




  // Testing /store_owners/stores_images/{storeOwnerImageId}
  it('Offline User : Do not allow not logged in users to delete store images.', async()=>{

    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/store_owners_images/{storeOwnerImageId}
  it('Online User : Do not allow logged in users to delete store owner images.', async()=>{

    const storage = myUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/store_owners_images/{storeImageId}
  it('Store Owner : Do not allow store owners to delete store owners images.', async()=>{

    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_images/${storeOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.delete());
  });

  //================================Store Owner Images[End]==================================

 //================================Store Owner Id Images[Start]==================================

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Offline User : Do not allow not logged in users to upload a store owner identity document image.', async()=>{
    
    await assertFails(
      noUser.storage().ref()
      .child(`/store_owners/store_owners_ids/${someId}`).put(file5MB)
      .then()
    );
  }); 

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to upload a store owner identity document image if it document id is not the same as the store owner document id[1].', async()=>{
    
    await assertFails(
      myUser.storage().ref()
      .child(`/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`)
      .put(file5MB).then()
    );
  }); 

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to upload a store owner identity document image if the store does not already exist[4].', async()=>{
    
    await assertFails(
      theirUser.storage().ref()
      .child(`/store_owners/store_owners_ids/${theirUserData.phoneNumber}`)
      .put(file5MB).then()
    );
  });

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to upload a store owner identity document image if the store owner already exist[5].', async()=>{
    
    const ownerData = {
      phoneNumber: myUserData.phoneNumber,
      fullname: 'Nomusa',
      surname:'Sukude',
      profileImageURL: `../${myUserData.phoneNumbe}.jpg`,
      identityDocumentImageURL: `../${myUserData.phoneNumber}.jpg`,
      isAdmin: false,
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('store_owners')
      .doc(ownerData.phoneNumber).set(ownerData);
    });

    
    await assertFails(
      myUser.storage().ref()
      .child(`/store_owners/store_owners_ids/${myUserData.phoneNumber}`)
      .put(file5MB).then()
    );
  });

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to upload a store owner identity document image with huge size[6].', async()=>{
    
    const storeData = {
      storeOwnerPhoneNumber: myUserData.phoneNumber,
      storeImageURL: '../mathayini_image.jpg',
      storeName: 'Mathayini',
      sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(storeData.storeOwnerPhoneNumber).set(storeData);
    });

    await assertFails(
      myUser.storage().ref()
      .child(`/store_owners/store_owners_ids/${myUserData.phoneNumber}`)
      .put(file6MB).then()
    );
  });

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Allow logged in users to upload a store owner identity document image if the store already exist[7].', async()=>{
    
    const storeData = {
      storeOwnerPhoneNumber: theirUserData.phoneNumber,
      storeImageURL: '../mathayini_image.jpg',
      storeName: 'Mathayini',
      sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu-Natal-South Africa',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('stores')
      .doc(storeData.storeOwnerPhoneNumber).set(storeData);
    });

    await assertSucceeds(
      theirUser.storage().ref()
      .child(`/store_owners/store_owners_ids/${theirUserData.phoneNumber}`)
      .put(file5MB).then()
    );
  });

  // Testing /store_owners/store_owner_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Do not allow store owners to upload store owner identity document images.', async()=>{
    
    await assertFails(
      storeOwnerUser.storage().ref()
      .child('/store_owners/store_owners_ids/'+storeOwnerData.phoneNumber)
      .put(file5MB).then()
    );
  }); 




  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Offline User : Do not allow not logged in users to view store owner identity documents.', async()=>{
    
    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to view store owner identity documents.', async()=>{
    
    const storage = myUser.storage();
      const storageRef = storage.ref()
      .child(`/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`);

    await assertFails(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Do not allow store owners to view store owner identity documents not belogning to them.', async()=>{
    
    const storage = theirStoreOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${storeOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.getDownloadURL());
  });

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Do not allow store owners to view store owner identity documents not belogning to them.', async()=>{
    
    const storage = theirStoreOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${storeOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.getDownloadURL());
  });

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Allow store owners to view their store owner identity document.', async()=>{
    
    const storage = theirStoreOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  });

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Allow store owners who are admins to view any store owner identity document.', async()=>{
    
    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`,
      );

    await assertSucceeds(storageRef.getDownloadURL());
  });



  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Offline User : Do not allow not logged in users to delete store identity document.', async()=>{

    const storage = noUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to delete store owner identity document.', async()=>{

    const storage = myUser.storage();
      const storageRef = storage.ref(
        `/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Do not allow store owners to delete store identity document.', async()=>{

    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
       `/store_owners/store_owners_ids/${theirStoreOwnerData.phoneNumber}`,
      );

    await assertFails(storageRef.delete());
  });

  //================================Store Owner Id Images[End]==================================

  //================================Alcoholic Images[Start]==================================

  // Testing /alcoholics/profile_images/{profileImageId}
  it('Offline User : Do not allow not logged in users to upload a profile image.', async()=>{
    
    await assertFails(
      noUser.storage().ref()
     .child('/alcoholics/profile_images/'+ someId)
      .put(file5MB).then()
    );
  }); 

  // Testing /alcoholics/profile_images/{profileImageId}
  it('Online User : Do not allow logged in users to upload profile images having a different profile image doc id compared to their uid.', async()=>{

    await assertFails(
      myUser.storage().ref()
      .child('/alcoholics/profile_images/'+someId)
      .put(file5MB).then()
    );
  }); 

  // Testing /alcoholics/profile_images/{profileImageId}
  it('Online User : Do not allow logged in users to upload profile images if they have already registered as alcoholics or store owners.', async()=>{

    await assertFails(
      myUser.storage().ref()
      .child('/alcoholics/profile_images/'+myUserData.phoneNumber)
      .put(file5MB).then()
    );
  }); 

  // Testing /alcoholics/profile_images/{profileImageId}
  it('Online User : Allow logged in users to upload profile images if they are not alcoholics already.', async()=>{

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    await assertSucceeds(
      myUser.storage().ref()
      .child('/alcoholics/profile_images/'+myUserData.phoneNumber)
      .put(file5MB).then()
    );
  }); 


  // Testing /alcoholics/profile_images/{profileImageId}
  it('Store Owner : Do not allow store owners to upload an alcoholic image.', async()=>{
    
    await assertFails(
      storeOwnerUser.storage().ref()
      .child('/alcoholics/profile_images/'+storeOwnerData.storeOwnerId)
      .put(file5MB).then()
    );
  });





  // Testing /store_owners/profile_images/{profileImageId}
  it('Offline User : Allow not logged in users to view alcoholic profile images.', async()=>{
    
    const storage = noUser.storage();
      const storageRef = storage.ref(
        '/alcoholics/profile_images/' + theirUserData.phoneNumber
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/profile_images/{profileImageId}
  it('Online User : Allow logged in users to view alcoholic profile images.', async()=>{

    const storage = myUser.storage();
      const storageRef = storage.ref(
        '/alcoholics/profile_images/' + theirUserData.phoneNumber
      );

    await assertSucceeds(storageRef.getDownloadURL());
  }); 

  // Testing /store_owners/profile_images/{profileImageId}
  it('Store Owner : Allow store owners to view alcoholic profile images.', async()=>{

    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        '/alcoholics/profile_images/' + theirUserData.phoneNumber
      );

    await assertSucceeds(storageRef.getDownloadURL());
  });





  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Offline User : Do not allow not logged in users to delete alcoholics profiles.', async()=>{

    const storage = noUser.storage();
      const storageRef = storage.ref(
        '/alcoholics/profile_images/' + theirUserData.phoneNumber,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Online User : Do not allow logged in users to delete alcoholics profiles.', async()=>{

    const storage = myUser.storage();
      const storageRef = storage.ref(
       '/alcoholics/profile_images/' + theirUserData.phoneNumber,
      );

    await assertFails(storageRef.delete());
  }); 

  // Testing /store_owners/store_owners_ids/{storeOwnerIdentityDocumentId}
  it('Store Owner : Do not allow store owners to delete alcoholics profiles.', async()=>{

    const storage = storeOwnerUser.storage();
      const storageRef = storage.ref(
        '/alcoholics/profile_images/' + theirUserData.phoneNumber,
      );

    await assertFails(storageRef.delete());
  });

  //================================Alcoholic Images[End]==================================



});

/*
await testEnv.withSecurityRulesDisabled(async context => {
      const storage = context.storage();
      const storageRef = storage.ref(
        `courses/course1/files/sample.txt`,
      );
      const firestore = context.firestore();
      const firestoreRef = firestore.doc(`courses/course1`);

      await Promise.all([
        storageRef.put(sample()),
        firestoreRef.set({
          editors: { user1: { exists: true } },
        }),
      ]);
    });

    const ref = testEnv
      .authenticatedContext('user1')
      .storage()
      .ref('courses/course1/files/sample.txt');

    await assertSucceeds(ref.getDownloadURL());
*/