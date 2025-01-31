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

  //================================Alcoholic [Start]===================================
  //==============alcoholic_crud ->  alcoholic_crud_firestore_unit_testing==============
  
  // Testing /alcoholics/{alcoholicId} 
  it('Offline User : Do not allow not logged in users to become alcoholics.', async()=>{

    const alcoholic = {
      phoneNumber: '+27635453456',
      profileImageURL: '../image.png',
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = noUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to become alcoholics if they provide incomplete info[1].', async()=>{

    // Start by deleting myUser from the alcoholics collection.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: '../image.png',
      sectionName: null,
    };

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to become alcoholics if they provide incomplete info[2].', async()=>{

    // Start by deleting myUser from the alcoholics collection.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: '../image.png',
      sectionName: "",
    };

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 
  
  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to become alcoholics if they provide incomplete info[3].', async()=>{

    // Start by deleting myUser from the alcoholics collection.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: null,
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to become alcoholics if they provide incomplete info[4].', async()=>{

    // Start by deleting myUser from the alcoholics collection.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: '',
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to become alcoholics if they provide not supported section name[5].', async()=>{

    // Start by deleting myUser from the alcoholics collection.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: '../image.png',
      sectionName: 'Ka L-Mashu-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to become alcoholics if they already have.', async()=>{

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: '../image.png',
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics').doc(alcoholic.phoneNumber).set(alcoholic);
    });

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set({alcoholic, merge:true}));
  }); 

  it('Online User : Allow logged in users to become alcoholics if they provide complete info.', async()=>{

    // Start by deleting myUser from the alcoholics collection.
    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('alcoholics')
      .doc(myUserData.phoneNumber).delete();
    });

    const alcoholic = {
      phoneNumber: myUserData.phoneNumber,
      profileImageURL: '../image.png',
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = myUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertSucceeds(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Normal Admin : Do not allow normal admins to become alcoholics.', async()=>{

    const alcoholic = {
      phoneNumber: '+27635453456',
      profileImageURL: '../image.png',
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = normalAdminUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Superior Admin : Do not allow superior admins to become alcoholics.', async()=>{

    const alcoholic = {
      phoneNumber: '+27635453456',
      profileImageURL: '../image.png',
      sectionName: 'Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa',
    };

    const doc = superiorAdminUser.firestore().collection('alcoholics')
    .doc(alcoholic.phoneNumber);
    await assertFails(doc.set(alcoholic));
  }); 
  


  // Testing /alcoholics/{alcoholicId} 
  it('Offline User : Allow not logged in users to view alcoholics.', async()=>{

    const doc = noUser.firestore().collection('alcoholics')
    .doc(someId);
    await assertSucceeds(doc.get());
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Allow logged in users to view alcoholics.', async()=>{

    const doc = myUser.firestore().collection('alcoholics')
    .doc(myUserData.userId);
    await assertSucceeds(doc.get());
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Normal Admin : Allow normal admins to view alcoholics.', async()=>{

    const doc = normalAdminUser.firestore().collection('alcoholics')
    .doc(someId);
    await assertSucceeds(doc.get());
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Superior Admin : Allow superior admins to view alcoholics.', async()=>{

    const doc = superiorAdminUser.firestore().collection('alcoholics')
    .doc(someId);
    await assertSucceeds(doc.get());
  }); 



  // Testing /alcoholics/{alcoholicId} 
  it('Offline User : Do not allow not logged in users to update alcoholics.', async()=>{

    const doc = noUser.firestore().collection('alcoholics')
    .doc(theirUserData.phoneNumber);
    await assertFails(doc.update({profileImageURL:'new data'}));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to update alcoholics\'data.', async()=>{

    const doc = myUser.firestore().collection('alcoholics')
    .doc(myUserData.phoneNumber);
    await assertFails(doc.update({profileImageURL:'new data'}));
  }); 

  // Testing /alcoholics/{alcoholicId} 
  it('Normal Admin : Do not allow normal admins to update any alcoholic account.', async()=>{

    const doc = normalAdminUser.firestore().collection('alcoholics')
    .doc(myUserData.phoneNumber);
    await assertFails(doc.update({profileImageURL:'new data'}));
  });
  
  // Testing /alcoholics/{alcoholicId} 
  it('Superior Admin : Do not allow superior admins to update any alcoholic account.', async()=>{

    const doc = superiorAdminUser.firestore().collection('alcoholics')
    .doc(myUserData.phoneNumber);
    await assertFails(doc.update({profileImageURL:'new data'}));
  });



  // Testing /alcoholics/{alcoholicId} 
  it('Offline User : Do not allow not logged in users to delete an alcoholic account.', async()=>{

    const doc = noUser.firestore().collection('alcoholics').doc(someId);
    await assertFails(doc.delete());
  }); 
  
  // Testing /alcoholics/{alcoholicId} 
  it('Online User : Do not allow logged in users to delete an alcoholic account.', async()=>{

    const doc = myUser.firestore().collection('alcoholics').doc(someId);
    await assertFails(doc.delete());
  }); 
  
  // Testing /alcoholics/{alcoholicId}  
  it('Normal Admin : Do not allow normal admins to delete an alcoholic account.', async()=>{

    const doc = normalAdminUser.firestore().collection('alcoholics').doc(someId);
    await assertFails(doc.delete());
  });
  
  // Testing /alcoholics/{alcoholicId}  
  it('Superior Admin : Do not allow superior admins to delete an alcoholic account.', async()=>{

    const doc = superiorAdminUser.firestore().collection('alcoholics').doc(someId);
    await assertFails(doc.delete());
  });

  //=============alcoholic_crud ->  alcoholic_crud_firestore_unit_testing=============
  //================================Alcoholic [End]===================================

  

  //================================Group [Start]===================================
  //================group_crud ->  group_crud_firestore_unit_testing================

  // /groups/{groupCreatorPhoneNumber} 
  it('Offline User : Do not allow not logged in users to create groups.', async()=>{

    const group = {
      groupName: 'xxx-for-life',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = noUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[1].', async()=>{

    const group = {
      groupName: null,
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

   // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[2].', async()=>{

    const group = {
      groupName: 'ab',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[3].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: null,
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[4].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: '',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[5].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Getto-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[6].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: null,

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[7].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: '',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[9].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: myUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[10].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: null,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[11].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: '',
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[12].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: '',
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[13].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 6,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[14].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: []
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  });

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to create groups if they provide incomplete info[15].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: true, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  });

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Allow logged in users to create groups if they provide correct info.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertSucceeds(doc.set(group));
  });

  // /groups/{groupCreatorPhoneNumber} 
  it('Normal Admin : Do not allow normal admins to create groups.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = normalAdminUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Superior Admin : Do not allow superior admins to create groups.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    const doc = superiorAdminUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.set(group));
  }); 

  

  // /groups/{groupCreatorPhoneNumber} 
  it('Offline User : Allow not logged in users to view groups.', async()=>{

    const doc = noUser.firestore().collection('groups')
    .doc(someId);
    await assertSucceeds(doc.get());
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Online User : Allow logged in users to view groups.', async()=>{

    const doc = myUser.firestore().collection('groups')
    .doc(myUserData.userId);
    await assertSucceeds(doc.get());
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Normal Admin : Allow normal admins to view groups.', async()=>{

    const doc = normalAdminUser.firestore().collection('groups')
    .doc(someId);
    await assertSucceeds(doc.get());
  }); 

  // /groups/{groupCreatorPhoneNumber} 
  it('Superior Admin : Allow superior admins to view groups.', async()=>{

    const doc = superiorAdminUser.firestore().collection('groups')
    .doc(someId);
    await assertSucceeds(doc.get());
  }); 



  
  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Offline User : Do not allow not logged in users to update groups.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).collection(group.groupCreatorPhoneNumber);
    });

    const doc = noUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupMembers: [theirUserData.phoneNumber, '+27834542536']}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [1].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupName: 'xxx'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [2].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupImageURL: 'xxxxxx'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [3].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupSectionName: 'Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [4].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupSpecificArea: 'xxxxxx'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [5].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupCreatorPhoneNumber: 'xxxxxx'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [6].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupCreatorImageURL: 'xxx'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [7].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupCreatorUsername: 'xxx'}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [7].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({isActive: true}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [8].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({maxNoOfMembers: 6}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to update unacceptable group fields [9].', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupMembers: []}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Allow logged in users to update groups.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = theirUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertSucceeds(doc.update({groupMembers: [theirUserData.phoneNumber, '+27834765673']}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Normal Admin : Do not allow normal admins to update groups.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = normalAdminUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupMembers: [theirUserData.phoneNumber, '+27834765673']}));
  });

  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Superior Admin : Do not allow superior admins to update groups.', async()=>{

    const group = {
      groupName: '24-7',
      groupImageURL: 'xxx',
      groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
      groupSpecificArea: 'xxx',

      groupCreatorPhoneNumber: theirUserData.phoneNumber,
      groupCreatorImageURL: theirUserData.profileImageURL,
      groupCreatorUsername: theirUserData.name,
      isActive: false, // A group is active if it has atleast 3 members.
      maxNoOfMembers: 5,
      groupMembers: [theirUserData.phoneNumber]
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('groups')
      .doc(group.groupCreatorPhoneNumber).set(group);
    });

    const doc = superiorAdminUser.firestore().collection('groups')
    .doc(group.groupCreatorPhoneNumber);
    await assertFails(doc.update({groupMembers: [theirUserData.phoneNumber, '+27834765673']}));
  });



  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Offline User : Do not allow not logged in users to delete groups.', async()=>{

    const doc = noUser.firestore().collection('groups').doc(someId);
    await assertFails(doc.delete());
  }); 
  
  // Testing /groups/{groupCreatorPhoneNumber} 
  it('Online User : Do not allow logged in users to delete groups.', async()=>{

    const doc = myUser.firestore().collection('groups').doc(someId);
    await assertFails(doc.delete());
  }); 
  
  // Testing /groups/{groupCreatorPhoneNumber}  
  it('Normal Admin : Do not allow normal admins to delete groups.', async()=>{

    const doc = normalAdminUser.firestore().collection('groups').doc(someId);
    await assertFails(doc.delete());
  });
  
  // Testing /groups/{groupCreatorPhoneNumber}  
  it('Superior Admin : Do not allow superior admins to delete groups.', async()=>{

    const doc = superiorAdminUser.firestore().collection('groups').doc(someId);
    await assertFails(doc.delete());
  });
  //================group_crud ->  group_crud_firestore_unit_testing================
  //================================Group [End]===================================

   //================================Admin [Start]===================================
  //================admin_crud ->  admin_crud_firestore_unit_testing================

  // Testing /admins/{adminPhoneNumber}
  it('Offline User : Do not allow not logged in users to register an admin.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
    }

    const doc = noUser.firestore().collection('admins').doc(admin.phoneNumber);
    await assertFails(doc.set(admin));
  }); 

  // Testing /admins/{adminPhoneNumber}
  it('Online User : Do not allow logged in users to register an admin.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
    }

    const doc = myUser.firestore().collection('admins').doc(admin.phoneNumber);
    await assertFails(doc.set(admin));
  });
  
  // Testing /admins/{adminPhoneNumber}
  it('Normal Admin : Do not allow normal admins to register an admin.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
    }

    const doc = normalAdminUser.firestore().collection('admins').doc(admin.phoneNumber);
    await assertFails(doc.set(admin));
  });

  // Testing /admins/{adminPhoneNumber}
  it('Superior Admin : Do not allow superior admins to register a superior admin.', async()=>{

    const admin = {
      isSuperiorAdmin: true,
      phoneNumber: someId,
    }

    const doc = superiorAdminUser.firestore().collection('admins').doc(admin.phoneNumber);
    await assertFails(doc.set(admin));
  });

  // Testing /admins/{adminPhoneNumber}
  it('Superior Admin : Allow superior admins to register an admin.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
    }

    const doc = superiorAdminUser.firestore().collection('admins').doc(admin.phoneNumber);
    await assertSucceeds(doc.set(admin));
  });



  // Testing /admins/{adminPhoneNumber}
  it('Offline User : Do not allow not logged in users to update admins.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
      key: 'key 123',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins')
      .doc(admin.phoneNumber).set(admin);
    });

    const doc = noUser.firestore().collection('admins')
    .doc(admin.phoneNumber);
    await assertFails(doc.update({key:'foo'}));
  }); 

  // Testing /admins/{adminPhoneNumber}
  it('Online User : Do not allow logged in users to update admins.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
      key: 'key 123',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins')
      .doc(admin.phoneNumber).set(admin);
    });

    const doc = myUser.firestore().collection('admins')
    .doc(admin.phoneNumber);
    await assertFails(doc.update({key:'foo'}));
  }); 

  // Testing /admins/{adminPhoneNumber}
  it('Normal Admin : Do not allow normal admins to view data not belonging to them.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
      key: 'key 123',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins')
      .doc(admin.phoneNumber).set(admin);
    });

    const doc = normalAdminUser.firestore().collection('admins')
    .doc(admin.phoneNumber);
    await assertFails(doc.get());
  }); 

  // Testing /admins/{adminPhoneNumber}
  it('Normal Admin : Allow normal admins to view data belonging to them.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: normalAdminData.phoneNumber,
      key: 'key 123',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins')
      .doc(admin.phoneNumber).set(admin);
    });

    const doc = normalAdminUser.firestore().collection('admins')
    .doc(admin.phoneNumber);
    await assertSucceeds(doc.get());
  }); 

  // Testing /admins/{adminPhoneNumber}
  it('Superior Admin : Allow superior admins to view admins.', async()=>{

    const admin = {
      isSuperiorAdmin: false,
      phoneNumber: someId,
      key: 'key 123',
    };

    await testEnv.withSecurityRulesDisabled(context=>{
      return context.firestore().collection('admins')
      .doc(admin.phoneNumber).set(admin);
    });

    const doc = superiorAdminUser.firestore().collection('admins')
    .doc(admin.phoneNumber);
    await assertSucceeds(doc.get());
  }); 
  



  // Testing /admins/{adminPhoneNumber} 
  it('Offline User : Do not allow not logged in users to update admins.', async()=>{

    const doc = noUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.update({profileImageURL: '...'}));
  });

  // Testing /admins/{adminPhoneNumber} 
  it('Online User : Do not allow logged in users to update admins.', async()=>{

    const doc = myUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.update({profileImageURL: '...'}));
  });

  // Testing /admins/{adminPhoneNumber} 
  it('Normal Admin : Do not allow normal admins to update admins.', async()=>{

    const doc = normalAdminUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.update({profileImageURL: '...'}));
  });

  // Testing /admins/{adminPhoneNumber} 
  it('Superior Admin : Do not allow superior admins to update admins.', async()=>{

    const doc = superiorAdminUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.update({profileImageURL: '...'}));
  });




  // Testing /admins/{adminPhoneNumber} 
  it('Offline User : Do not allow not logged in users to delete normal admins.', async()=>{

    const doc = noUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.delete());
  });

  // Testing /admins/{adminPhoneNumber} 
  it('Online User : Do not allow logged in users to delete normal admins.', async()=>{

    const doc = myUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.delete());
  });

  // Testing /admins/{adminPhoneNumber} 
  it('Normal Admin : Do not allow normal admins to delete normal admins.', async()=>{

    const doc = normalAdminUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertFails(doc.delete());
  });

  // Testing /admins/{adminPhoneNumber} 
  it('Superior Admin : Do not allow superior admins to delete superior admins.', async()=>{

    const doc = superiorAdminUser.firestore().collection('admins')
    .doc(superiorAdminData.phoneNumber);
    await assertFails(doc.delete());
  }); 

  // Testing /admins/{adminPhoneNumber} 
  it('Superior Admin : Allow superior admins to delete normal admins.', async()=>{

    const doc = superiorAdminUser.firestore().collection('admins')
    .doc(normalAdminData.phoneNumber);
    await assertSucceeds(doc.delete());
  });

  //================admin_crud ->  admin_crud_firestore_unit_testing================
  //================================Admin [End]===================================

});
