"use strict";

// [START all]
// [START import]
// The Cloud Functions for Firebase SDK to create Cloud Functions and triggers.
import {logger} from "firebase-functions";

import {onDocumentCreated, onDocumentUpdated}
  from "firebase-functions/v2/firestore";

import { onCall, HttpsError } from 'firebase-functions/v2/https'

import {onRequest} from "firebase-functions/v2/https";

// The Firebase Admin SDK to access Firestore.
import {initializeApp} from "firebase-admin/app";
import {getFirestore, Timestamp} from "firebase-admin/firestore";

import {getStorage} from "firebase-admin/storage";
import { log } from "firebase-functions/logger";

// import {onSchedule} from "firebase-functions/v2/scheduler";

/* const runtimeOpts = {
  timeoutSeconds: 420,
  //memory: "1GiB",
}; */

const queriedStoreDraws = [];

const supportedCountries = new Map();
supportedCountries.set(
    "ZA-South Africa", ["Kwa Zulu Natal"],
);

const supportedProvincesOrStates = new Map();
supportedProvincesOrStates.set(
    "Kwa Zulu Natal", ["Durban", "Pinetown"],
);

const supportedCities = new Map();
supportedCities.set(
    "Durban", ["Mayville", "Umlazi",
      "Durban Central",
      "Manor Gardens", "Westville"],
);
supportedCities.set(
    "Pinetown", ["Westmead"],

);

const supportedSuburbOrTownships = new Map();
supportedSuburbOrTownships.set(
    "Mayville",
    [
      "Cato Crest", "Cato Manor", "Dunbar",
      "Masxha",
      "Bonela", "Sherwood", "Richview",
      "Nsimbini",
      "Manor Gardens",
    ],
);
supportedSuburbOrTownships.set(
    "Umlazi",
    [
      "A Section", "AA Section", "B Section",
      "BB Section", "C Section", "CC Section",
      "D Section", "E Section",
      "F Section", "G Section", "H Section",
      "J Section", "K Section", "L Section",
      "M Section", "N Section",
      "P Section", "Q Section", "R Section",
      "S Section", "U Section", "V Section",
      "W Section", "Y Section",
      "Z Section", "Malukazi", "Philani", "MUT",
    ],
);

supportedSuburbOrTownships.set(
    "Durban Central", ["DUT"],
);

supportedSuburbOrTownships.set(
    "Manor Gardens", ["Haward Campus UKZN"],
);

supportedSuburbOrTownships.set(
    "Westville", ["Westville Campus UKZN"],
);

supportedSuburbOrTownships.set(
    "Westmead", ["Edgewood Campus UKZN"],
);


const supportedAreas = new Map();
supportedAreas.set(
    "Mayville",
    [
      "Cato Crest", "Cato Manor", "Dunbar", "Masxha",
      "Bonela", "Sherwood", "Richview", "Nsimbini",
      "Manor Gardens",
    ],
    "Umlazi",
    [
      "A Section", "AA Section", "B Section", "BB Section",
      "C Section", "CC Section", "D Section", "E Section",
      "F Section", "G Section", "H Section", "J Section",
      "K Section", "L Section", "M Section", "N Section",
      "P Section", "Q Section", "R Section", "S Section",
      "U Section", "V Section", "W Section", "Y Section",
      "Z Section", "Malukazi", "Philani", "MUT",
    ],

    "Durban Central", ["DUT"],
    "Manor Gardens", ["Haward Campus UKZN"],
    "Westville", ["Westville Campus UKZN"],
    "Durban", ["Mayville", "Umlazi", "Durban Central",
      "Manor Gardens", "Westville"],


    "Westmead", ["Edgewood Campus UKZN"],
    "Pinetown", ["Westmead"],

    "Kwa Zulu Natal", ["Durban", "Pinetown"],
    "ZA-South Africa", ["Kwa Zulu Natal"],


);


initializeApp();


// http://127.0.0.1:5001/alcoholic-expressions/us-central1/createSupportedAreas/
// http://127.0.0.1:5001/alcoholic-expressions/us-central1/create5MembersGroups
// http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveStoreAndAdmins

// ###################Production Functions [Start]########################

const pickingMultipleInSeconds = 3;

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveStoreAndAdmins
export const saveStoreAndAdmins = onRequest(async(req, res)=>{
  
  const admins = [
    {
      isSuperior: true,
      key: '000',
      isFemale: false,
      phoneNumber: '+27661813561',
      profileImageURL: '/admins/profile_images/superior/+27661813561.jpg',
    },

    {
      isSuperior: true,
      key: '001',
      isFemale: false,
      phoneNumber: '+27714294940',
      profileImageURL: '/admins/profile_images/superior/+27714294940.jpg',
    },
    {
      isSuperior: false,
      key: '00000',
      isFemale: true,
      phoneNumber: '+27612345678',
      profileImageURL: '/admins/profile_images/superior/+27612345678.jpg',
    },
    {
      isSuperior: false,
      key: '00001',
      isFemale: true,
      phoneNumber: '+27712345678',
      profileImageURL: '/admins/profile_images/superior/+27712345678.jpg',
    },
    {
      isSuperior: false,
      key: '00002',
      isFemale: true,
      phoneNumber: '+27812345678',
      profileImageURL: '/admins/profile_images/superior/+27812345678.jpg',
    },
  ];

  let adminReference;

  for(let adminIndex = 0; adminIndex<admins.length;adminIndex++){
    adminReference = getFirestore().collection('admins').doc(admins[adminIndex].phoneNumber);
    await adminReference.set(admins[adminIndex]);
  } 

  const store = {
    storeOwnerPhoneNumber: '+27661813561',
    storeName: 'Ka Nkuxa',
    storeImageURL: 'store_owners/store_images',
    sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
    storeArea: 'Ringini',
  };

  const storeReference = getFirestore().collection('stores')
  .doc(store.storeOwnerPhoneNumber);
  
  await storeReference.set(store);

   // Send back a message that we've successfully written to the db.
   res.json({result: `All Admins And Store Are Saved.`});
});

/* Each time a new store is created, it has to have a corresponding store name
info document which is responsible for holding information that users
will be seeing, like a store's current state(hasNoCompetition,
hasUpcommingCompetition, etc.) for example. */
export const createStoreNameInfo = onDocumentCreated("/stores/" +
  "{storeOwnerPhoneNumber}", async (event) => {
  // Access the parameter `{storeId}` with `event.params`
  logger.log("From Params Store ID", event.params.storeOwnerPhoneNumber,
      "From Data Store ID", event.data.data().storeOwnerPhoneNumber);

  /* Create a document reference in order to associate it id with the
  stores's id.*/
  const docReference = getFirestore()
      .collection("stores_names_info").doc(event.params.storeOwnerPhoneNumber);

  // Grab the current values of what was written to the stores collection.
  const storeNameInfo = {
    storeNameInfoId: event.data.data().storeOwnerPhoneNumber,
    storeName: event.data.data().storeName,
    storeImageURL: event.data.data().storeImageURL,
    sectionName: event.data.data().sectionName,
    storeArea: event.data.data().storeArea,
    canAddStoreDraw: true,
    latestStoreDrawId: "-",
  };
  logger.log(`About To Add A Store Name Info Object With ID
    ${storeNameInfo.storeNameInfoId} To The Database.`);

  // Push the new store into Firestore using the Firebase Admin SDK.
  return await docReference.set(storeNameInfo);
});

export const createGroup1 = onCall(async(request)=>{

  const param1 = request.data.param1;
  const param2 = request.data.param2;

  log(param1);
  log(param2);

  return {
    'param1': 'one',
    'param2': 'two',
  };
});

export const createGroup = onCall(async(request)=>{
  
  const group = {
    groupName: request.data.groupName,
    groupImageURL: request.data.groupImageURL,
    groupSectionName: request.data.groupSectionName,
    groupSpecificArea: request.data.groupSpecificArea,

    groupCreatorPhoneNumber: request.data.groupCreatorPhoneNumber,
    groupCreatorImageURL: request.data.groupCreatorImageURL,
    groupCreatorUsername: request.data.groupCreatorUsername,
    isActive: true, // A group is active if it has atleast 10 members.
    maxNoOfMembers: 5, // 5

    groupMembers: request.data.groupMembers
  };


  const groupReference = getFirestore().collection('groups').doc(group.groupCreatorPhoneNumber);
    
    // List of group members phone numbers.
    const groupMembersPhoneNumbers = [];

    let alcoholicReference;
    for(let alcoholicIndex = 0; alcoholicIndex < group.groupMembers.length;alcoholicIndex++){
      const alcoholic = group.groupMembers[alcoholicIndex];
      groupMembersPhoneNumbers.push(alcoholic.phoneNumber);
      alcoholicReference = getFirestore().collection('alcoholics').doc(alcoholic.phoneNumber);
      
      await alcoholicReference.set(alcoholic);
    }

    // Replace group members alcoholic object with phone numbers as strings.
    group.groupMembers = groupMembersPhoneNumbers;

    await groupReference.set(group);
    
  

  // Send back a message that we've successfully written to the db.
  res.json({result: `All Groups & Alcoholics Are Saved.`});
});



// declare the function
const shuffle = (array) => {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
};


/* Do not modify application state inside of your transaction functions.
Doing so will introduce concurrency issues, because transaction functions
can run multiple times and are not guaranteed to run on the UI thread.
Instead, pass information you need out of your transaction functions.
onSchedule("25 8 * * SUN", async (event) => {*/
// onSchedule("*/5 * * * *", async (event) => { */
// http://127.0.0.1:5001/alcoholic-expressions/us-central1/convertStoreDrawsToCompetitions
export const convertStoreDrawsToCompetitions =
onRequest(async (req, res)=>{
  try {
    // Consistent timestamp
    //const justNow = admin.firestore.Timestamp.now().toDate();

    const justNow = new Date(); // Retrieve Current Time.

    // Use the get() method for a read and the onSnapshot() for real time read.
    getFirestore().collectionGroup("store_draws").orderBy("storeName")
        .where("drawDateAndTime.year",
            "==", justNow.getFullYear(),
        )
        .where("drawDateAndTime.month",
            "==", justNow.getMonth() + 1, // 1-12
        )
        .where("drawDateAndTime.day",
            "==", justNow.getDate(),
        )
        .where("drawDateAndTime.hour",
            "==", justNow.getHours() + 2, // GTM
        )
        // Can Be A Bit Tricky If You Think About It.
        // As a result competitions shouldn't start at o'clock.
        .where("drawDateAndTime.minute",
            "<=", justNow.getMinutes() + 5,
        )
        .where("drawDateAndTime.minute",
            ">=", justNow.getMinutes(),
        )
        .onSnapshot(async (storeDrawsSnapshot)=>{
          if (storeDrawsSnapshot.size) {
            storeDrawsSnapshot.forEach(async (storeDrawDoc)=>{
              const sectionName = storeDrawDoc.data()["sectionName"];
              /* Only initiate the conversion step if there are
                 groups belonging in a section which is the same
                 as the store draw's.*/
              getFirestore().collection("groups")
              // .where("groupSectionName", "==", sectionName)
                  .onSnapshot(async (groupsSnapshot)=>{
                    if (groupsSnapshot.size>0) {
                      storeDrawDoc.ref.update({isOpen: false,
                        isRemainingTimeVisible: true});
                      const storeDrawId = storeDrawDoc.data()["storeDrawId"];

                      const storeDraw = {
                        isFake: storeDrawDoc.data()["isFake"],
                        storeDrawId: storeDrawDoc.data()["storeDrawId"],
                        storeFK: storeDrawDoc.data()["storeFK"],
                        drawDateAndTime:
                        storeDrawDoc.data()["drawDateAndTime"],
                        joiningFee: storeDrawDoc.data()["joiningFee"],
                        numberOfGrandPrices:
                        storeDrawDoc.data()["numberOfGrandPrices"],
                        numberOfGroupCompetitorsSoFar:
                        storeDrawDoc.data()["numberOfGroupCompetitorsSoFar"],
                        isOpen: storeDrawDoc.data()["isOpen"],
                        storeName: storeDrawDoc.data()["storeName"],
                        storeImageURL:
                        storeDrawDoc.data()["storeImageURL"],
                        sectionName: sectionName,
                      };

                      queriedStoreDraws.push(storeDraw);

                      const reference = getFirestore()
                          .collection("competitions")
                          .doc(storeDrawId);

                      
                      const timeBetweenPricePickingAndGroupPicking = 5;
                      const  displayPeriodAfterWinners = 30;

                      const competition = {
                        competitionId: reference.id,
                        storeFK: storeDraw.storeFK,
                        competitionSectionName: storeDraw.sectionName,
                        isLive: true,
                        dateTime: storeDraw.drawDateAndTime,
                        joiningFee: storeDraw.joiningFee,
                        numberOfGrandPrices: storeDraw.numberOfGrandPrices,
                        isOver: false,
                        isFake: storeDraw.isFake,
                        grandPricesGridId: "-",
                        competitorsGridId: "-",
                        groupPickingStartTime: -1,
                        pickingMultipleInSeconds: pickingMultipleInSeconds,
                        timeBetweenPricePickingAndGroupPicking:  timeBetweenPricePickingAndGroupPicking,
                        displayPeriodAfterWinners:  displayPeriodAfterWinners, // must switch to 5 minute (300)
                        
                        grandPricesOrder: [],
                        isWonGrandPricePicked: false,
                        competitorsOrder: [],
                        isWonCompetitorGroupPicked: false,
                        competitionState: "on-count-down",
                        wonPrice: null,
                        wonGroup: null,

                      };

                      await reference.set(competition);
                      // Change store draw state.
                      storeDrawDoc.ref.update({
                        storeDrawState: "converted-to-competition",
                      });

                      // Update isOpen to false.
                      storeDrawDoc.ref.update({
                        isOpen: false,
                      });
                    }
                  });
            });
          }
        });

    res.json({result: `Done Converting Store Draws Into Competitions.`});
  }
  catch (e) {
    logger.log(e);
  }
});

export const createGrandPricesGrid =
onDocumentCreated("/competitions/" +
  "{competitionId}", async (event) => {
  const competitionId = event.data.data()["competitionId"];
  const numberOfGrandPrices = event.data.data()["numberOfGrandPrices"];
  const storeFK = event.data.data()["storeFK"];
  



  getFirestore()
      .collection("competitions")
      .doc(competitionId)
      .collection("grand_prices_grids")
      .onSnapshot(async (grandPricesGridSnapshot)=>{
      // Only add a new grand price grid if one does not exist yet.
        if (grandPricesGridSnapshot.size==0) {
        /* Convert each drawGrandPrice into a
        grandPriceToken and save it.*/
          const reference = getFirestore()
              .collection("competitions")
              .doc(competitionId)
              .collection("grand_prices_grids")
              .doc();

          // Step 4
          let grandPricesOrder = [];

          // Make sure all grand prices are visited.
          for (let index = 0; index < numberOfGrandPrices;
            index++) {
            grandPricesOrder.push(index);
          }

          // Suffle the list to make sure the order is random.
          grandPricesOrder = shuffle(grandPricesOrder);

          const grandPricesGrid = {
            grandPricesGridId: reference.id,
            competitionFK: competitionId,
            numberOfGrandPrices: numberOfGrandPrices,
            currentlyPointedTokenIndex: 0,
            grandPricesOrder: grandPricesOrder,
            hasStarted: false,
            hasStopped: false,
            storeFK: storeFK,
            isFake: event.data.data()["isFake"],
          };

          await reference.set(grandPricesGrid);

          const competitionReference = getFirestore().collection("competitions").doc(competitionId);
          await competitionReference.update({grandPricesGridId: grandPricesGrid.grandPricesGridId});
          await competitionReference.update({grandPricesOrder: grandPricesGrid.grandPricesOrder});

          const pickingMultipleInSeconds = event.data.data()["pickingMultipleInSeconds"];
          const timeBetweenPricePickingAndGroupPicking= event.data.data()["timeBetweenPricePickingAndGroupPicking"];
          const groupPickingStartTime = grandPricesGrid.grandPricesOrder.length
          *pickingMultipleInSeconds+timeBetweenPricePickingAndGroupPicking;

          await competitionReference.update({groupPickingStartTime: groupPickingStartTime});
        }
      });
});

export const createGrandPricesTokens =
  onDocumentCreated("/competitions/" +
    "{competitionId}/grand_prices_grids/" +
    "{grandPriceGridId}", async (event) => {
    const competitionFK = event.data.data()["competitionFK"];
    const grandPricesGridId = event.data.data()["grandPricesGridId"];
    const storeFK = event.data.data()["storeFK"];

    getFirestore()
        .collection("stores")
        .doc(storeFK)
        .collection("store_draws")
        .doc(competitionFK)
        .collection("draw_grand_prices")
        .onSnapshot(async (drawGrandPricesSnapshot)=>{
          if (drawGrandPricesSnapshot.size>0) {
            drawGrandPricesSnapshot.forEach(
                async (drawGrandPrice)=>{

                  if(drawGrandPrice.data().grandPriceIndex==indexOfWonGrandPrice){
                    getFirestore()
                        .collection("competitions")
                        .doc(competitionFK).onSnapshot(async (competitionDoc)=>{
                          await competitionDoc.ref.update({
                            wonPrice: drawGrandPrice.data()
                          });
                        });
                  }

                  const tokenReference =
                  getFirestore()
                      .collection("competitions")
                      .doc(competitionFK)
                      .collection("grand_prices_grids")
                      .doc(grandPricesGridId)
                      .collection("grand_prices_tokens")
                      .doc();

                  const grandPriceToken ={
                    grandPriceTokenId:
                    tokenReference.id,
                    grandPricesGridFK:
                    grandPricesGridId,
                    tokenIndex:
                    drawGrandPrice.data().grandPriceIndex,
                    isPointed:
                    drawGrandPrice.data().grandPriceIndex==0,
                    imageURL:
                    drawGrandPrice.data().imageURL,
                    description:
                    drawGrandPrice.data().description,
                    isFake: event.data.data()["isFake"],
                  };
                  await tokenReference.set(grandPriceToken);
                });
          }
        });
  });

export const createGroupCompetitiorsGrid =
onDocumentCreated("/competitions/" +
"{competitionId}", async (event) => {
  const competitionId = event.data.data()["competitionId"];
  const storeFK = event.data.data()["storeFK"];
  const competitionSectionName = event.data.data()["competitionSectionName"];

  getFirestore()
      .collection("competitions")
      .doc(competitionId)
      .collection("group_competitors_grids")
      .onSnapshot(async (groupCompetitorsGridSnapshot)=>{
      // Only add a new group competitors grid if one does not exist yet.
        if (groupCompetitorsGridSnapshot.size==0) {
          getFirestore()
              .collection("groups")
              .where("groupSectionName", "==", competitionSectionName)
              .get().then(async (groupsSnapshot)=>{
                // logger.log('No Of Qualifying Groups', groupsSnapshot.size);
                if (groupsSnapshot.size>0) {
                  const reference = getFirestore()
                      .collection("competitions")
                      .doc(competitionId)
                      .collection("group_competitors_grids")
                      .doc();

                  const numberOfGroupCompetitorsSoFar = groupsSnapshot.size;
                  const groupCompetitorsGridId = reference.id;

                  let competitorsOrder = [];

                  // Make sure all competitors are visited.
                  groupsSnapshot.docs.forEach((groupDoc)=>{
                    competitorsOrder.push(groupDoc.id);
                  });

                  // Make sure competitors are visited randomly.
                  competitorsOrder = shuffle(competitorsOrder);

                  const groupCompetitorsGrid = {
                    competitorsGridId: groupCompetitorsGridId,
                    competitionFK: competitionId,
                    numberOfGroupCompetitors:
                    numberOfGroupCompetitorsSoFar,
                    currentlyPointedTokenIndex: 0,
                    competitorsOrder:
                    competitorsOrder,
                    hasStarted: false,
                    hasStopped: false,
                    storeFK: storeFK,
                    competitionSectionName: competitionSectionName,
                    isFake: event.data.data()["isFake"],
                  };

                  await reference.set(groupCompetitorsGrid);

                  const competitionReference = getFirestore().collection("competitions").doc(competitionId);
                  await competitionReference.update({competitorsGridId: groupCompetitorsGrid.competitorsGridId});
                  await competitionReference.update({competitorsOrder: groupCompetitorsGrid.competitorsOrder});
                }
              });
        }
      });
});

export const createGroupCompetitorsTokens =
  onDocumentCreated("/competitions/" +
  "{competitionId}/group_competitors_grids/" +
  "{groudCompetitorGridId}", async (event) => {
    const competitionFK =
    event.data.data()["competitionFK"];
    const competitionSectionName =
    event.data.data()["competitionSectionName"];

    const groupCompetitorsGridId =
    event.data.data()["competitorsGridId"];

    getFirestore()
        .collection("groups")
        .where("groupSectionName", "==", competitionSectionName)
        .onSnapshot(
            async (groupsSnapshot)=>{
              if (groupsSnapshot.size>0) {
                for (let groupIndex = 0; groupIndex <
                  groupsSnapshot.size; groupIndex++) {
                  const groupDoc =
                  groupsSnapshot.docs.at(groupIndex);

                  if(wonGroupCreatorNumber===groupDoc.data().groupCreatorPhoneNumber){
                    getFirestore()
                        .collection("competitions")
                        .doc(competitionFK).onSnapshot((competitionDoc)=>{
                          competitionDoc.ref.update({
                            wonGroup: groupDoc.data()
                          })
                        });
                  }

                  const tokenDocReference =
                    getFirestore()
                        .collection("competitions")
                        .doc(competitionFK)
                        .collection("group_competitors_grids")
                        .doc(groupCompetitorsGridId)
                        .collection("group_competitors_tokens")
                        .doc();

                  const groupCompetitorToken = {
                    groupCompetitorTokenId:
                      tokenDocReference
                          .id,
                    groupCompetitorsGridFK:
                      groupCompetitorsGridId,
                    tokenIndex: groupIndex,
                    // isPointed: groupIndex==0,
                    group: groupDoc.data(),
                    isFake: event.data.data()["isFake"],
                  };

                  await tokenDocReference
                      .set(groupCompetitorToken);
                }
              }
            });
  });

/*
const batchWriteTester = (async (remainingTime)=>{
  getFirestore().collection("groups")
      .onSnapshot(async (groupsSnapshot)=>{
        const batch = getFirestore().batch();
        groupsSnapshot.docs.map((groupDoc)=>{
          batch.update(groupDoc.ref, {isActive: false});
          batch.update(groupDoc.ref, {isFake: "No"});
          batch.update(groupDoc.ref, {maxNoOfMembers: 5});
        });

        // logger.debug("batch operation 1...");
        await batch.commit();

        const reference = getFirestore()
            .collection("stores")
            .doc("+27674511121");

        reference.update({isFake: "No"});


        getFirestore().collection("relationships")
            .onSnapshot(async (relationshipsSnapshot)=>{
              const batch = getFirestore().batch();
              relationshipsSnapshot.docs.map((relationshipDoc)=>{
                batch.update(relationshipDoc.ref, {user3DigitToken: "XXX"});
                batch.update(relationshipDoc.ref, {isFake: "No"});
              });

              // logger.debug("batch operation 2...");
              await batch.commit();
              logger.debug(remainingTime);
            });
      });
}); */

/* Make sure all competitions start at an acceptable time,
like 08:30 for instance.*/
export const maintainCountDownClocks =
onDocumentCreated("/competitions/" +
  "{competitionId}", async (event) => {
  const day = event.data.data().dateTime["day"];
  const month = event.data.data().dateTime["month"];
  const year = event.data.data().dateTime["year"];
  const hour = event.data.data().dateTime["hour"];
  const minute = event.data.data().dateTime["minute"];
 
  const grandPricesOrder = event.data.data().grandPricesOrder;
  const timeBetweenPricePickingAndGroupPicking = 
  event.data.data().timeBetweenPricePickingAndGroupPicking;
  const competitorsOrder = event.data.data().competitorsOrder;

  const competitionEndTime = grandPricesOrder.length*pickingMultipleInSeconds +
  timeBetweenPricePickingAndGroupPicking + competitorsOrder.length*pickingMultipleInSeconds;


  const collectionId = `${day}-${month}-${year}-${hour}-${minute}`;

  const reference = getFirestore().collection("count_down_clocks")
      .doc(collectionId);

  reference.onSnapshot(async (snapshot)=>{
    if (!snapshot.exists) {
    // max 300 seconds for picking a won group.
      // max 60 seconds for picking a won price.
      /*
      grand prices picking - max 160 seconds
      group picking - no limit (assuming 100 groups) 500 seconds
      competition over display = at least 300 seconds
      */

      // Remaining seconds should always start at -300.
      const max = pickingMultipleInSeconds*300;
      let second = -100*pickingMultipleInSeconds;

      reference.set({
        remainingTime: second,
      });

      const timerId = setInterval(async ()=>{
        if (second>competitionEndTime) {
          //initiatePicking(collectionId);
          clearInterval(timerId);
        }
        else {
          second += pickingMultipleInSeconds;
        }
        reference.set({
          remainingTime: second,
        });

        // batchWriteTester(second);
        // keepTrackOfReadOnly(collectionId);
      }, 5000);
    }
  });
});

// Enough CPUs, memory and time is needed for this function.
/*
  const keepTrackOfReadOnly = (async (readOnlyId) => {
 */

/* eslint brace-style: ["warn", "stroustrup"]*/
export const setIsLiveForQualifyingCompetitions = onDocumentUpdated("/read_only/" +
  "{readOnlyId}", async (event) => {
  const readOnlyId = event.params.readOnlyId;

  const readOnlyReference = getFirestore().collection("read_only")
      .doc(readOnlyId);


  readOnlyReference.onSnapshot(
      async (doc)=>{
      // The remaining time for competitions to start.
        const remainingTime = doc.data().remainingTime;

        /* Set isLive to true on corresponding competitions*/
        if (remainingTime==0) {
          const datePieces = readOnlyId.split("-");

          const day = datePieces[0];
          const month = datePieces[1];
          const year = datePieces[2];
          const hour = datePieces[3];
          const minute = datePieces[4];

          getFirestore().collection("competitions")
              .onSnapshot(async (competitionsSnapshot)=>{
                if (competitionsSnapshot.size>0) {
                  competitionsSnapshot.docs.map(async (competitionDoc)=>{
                    if (competitionDoc.data().dateTime["day"]==day &&
                  competitionDoc.data().dateTime["month"]==month &&
                  competitionDoc.data().dateTime["year"]==year &&
                  competitionDoc.data().dateTime["hour"]==hour &&
                  competitionDoc.data().dateTime["minute"]==minute) {
                    // Set competition isLive value to true.
                      competitionDoc.ref.update({
                        isLive: true,
                      });
                    }
                  });
                }
              });
        }
      });
});

/* eslint max-len: ["off", { "code", 80, "comments": 80 }] */
export const createWonPriceSummary =
 onDocumentUpdated("/competitions/" +
  "{competitionId}", async (event) => {
// onCall(async (data, context) => {

  // const competitionId  = data.competitionId;

  const reference = getFirestore()
      .collection("competitions")
      .doc(event.params.competitionId);
      //.doc(competitionId);
  reference.onSnapshot((competitionsSnapshot)=>{
    if (competitionsSnapshot.exists) {
      const isOver = competitionsSnapshot.data().isOver;
      const isLive = competitionsSnapshot.data().isLive;
      const isFake = competitionsSnapshot.data().isFake;

      if (isOver && isLive) {
        reference.update({isLive: false});
        const wonPriceSummaryId =
        competitionsSnapshot.data().competitionId;
        const storeFK =
        competitionsSnapshot.data().storeFK;

        const storeReference = getFirestore()
            .collection("stores")
            .doc(storeFK);

        storeReference.onSnapshot((snapshot)=>{
          const storeName = snapshot.data().storeName;
          const storeImageURL = snapshot.data().storeImageURL;
          const storeSection = snapshot.data().sectionName;
          const storeArea = snapshot.data().storeArea;

          let groupName;
          let groupSectionName;
          let groupSpecificLocation;
          let groupMembers;
          let groupCreatorPhoneNumber;

          let grandPriceDescription;
          let grandPriceImageURL;

          let groupCreatorUsername;
          let groupCreatorImageURL;


          getFirestore().collection("competitions")
              .doc(wonPriceSummaryId)
              .collection("group_competitors_grids")
              .onSnapshot((groupCompetitorsGridSnapshot) => {
                if (groupCompetitorsGridSnapshot.size==1) {
                  groupCompetitorsGridSnapshot.forEach(
                      (groupCompetitorsGridDoc)=>{
                        const groupCompetitorsGridId =
                    groupCompetitorsGridDoc.data().competitorsGridId;

                        const competitorsList =
                        groupCompetitorsGridDoc.data().competitorsOrder;
                        logger.log(`${competitorsList}`);
                        const groupCreatorLeaderPhoneNumber =
                        competitorsList[competitorsList.length-1];
                        logger.log(`Group Creator Leader ${groupCreatorLeaderPhoneNumber}`);
                        getFirestore().collection("competitions")
                            .doc(wonPriceSummaryId)
                            .collection("group_competitors_grids")
                            .doc(groupCompetitorsGridId)
                            .collection("group_competitors_tokens")
                            .onSnapshot((groupCompetitorsTokensSnapshot)=>{
                              if (groupCompetitorsTokensSnapshot.size>0) {
                                groupCompetitorsTokensSnapshot.forEach(
                                    (groupCompetitorTokenDoc)=>{
                                      if (groupCreatorLeaderPhoneNumber===
                                        groupCompetitorTokenDoc.data()
                                            .group.groupCreatorPhoneNumber) {
                                        const group =
                                        groupCompetitorTokenDoc.data().group;

                                        groupName =
                                        group.groupName;

                                        groupSectionName =
                                        group.groupSectionName;

                                        groupSpecificLocation =
                                        group.groupSpecificArea;

                                        groupMembers =
                                        group.groupMembers;

                                        groupCreatorPhoneNumber =
                                        group.groupCreatorPhoneNumber;

                                        const alcoholicDocReference =
                                        getFirestore()
                                            .collection("alcoholics")
                                            .doc(groupCreatorPhoneNumber);

                                        alcoholicDocReference.onSnapshot(
                                            (snapshot)=>{
                                              groupCreatorUsername =
                                          snapshot.data().username;
                                              groupCreatorImageURL =
                                          snapshot.data().profileImageURL;

                                              /* finally set the grand price
                                          description. */
                                              getFirestore()
                                                  .collection("competitions")
                                                  .doc(wonPriceSummaryId)
                                                  .collection(
                                                      "grand_prices_grids")
                                                  .onSnapshot(
                                                      (grandPricesGridSnapshot) => {
                                                        if (grandPricesGridSnapshot.size==1) {
                                                          grandPricesGridSnapshot.forEach(
                                                              (grandPriceGridDoc)=>{
                                                                const grandPricesGridId =
                                                                grandPriceGridDoc.data()
                                                                    .grandPricesGridId;
                                                                const grandPricesOrder =
                                                                grandPriceGridDoc.data()
                                                                    .grandPricesOrder;
                                                                const wonGrandPriceIndex =
                                                                grandPricesOrder[grandPricesOrder.length-1];

                                                                logger.log(`${grandPricesOrder}`);
                                                                logger.log(`won price index ${wonGrandPriceIndex}`);

                                                                getFirestore()
                                                                    .collection("competitions")
                                                                    .doc(wonPriceSummaryId)
                                                                    .collection("grand_prices_grids")
                                                                    .doc(grandPricesGridId)
                                                                    .collection("grand_prices_tokens")
                                                                    .onSnapshot(
                                                                        (grandPricesTokensSnapshot)=>{
                                                                          if (grandPricesTokensSnapshot.size>0) {
                                                                            
                                                                            grandPricesTokensSnapshot.forEach(
                                                                                async (grandPriceTokenDoc)=>{
                                                                                  if (wonGrandPriceIndex==
                                                                                  grandPriceTokenDoc.data().tokenIndex) {
                                                                                    
                                                                                    grandPriceDescription =
                                                                                    grandPriceTokenDoc.data().description;
                                                                                    grandPriceImageURL =
                                                                                    grandPriceTokenDoc.data().imageURL;
                                                                                    const wonPriceSummaryReference =
                                                                                    getFirestore()
                                                                                        .collection("won_prices_summaries")
                                                                                        .doc(wonPriceSummaryId);
                                                                                    const wonPriceSummary = {
                                                                                      wonPriceSummaryId:
                                                                                      wonPriceSummaryId,
                                                                                      storeFK: storeFK,
                                                                                      groupName: groupName,
                                                                                      groupSectionName:
                                                                                      groupSectionName,
                                                                                      groupSpecificLocation:
                                                                                      groupSpecificLocation,
                                                                                      groupMembers: groupMembers,
                                                                                      grandPriceDescription:
                                                                                      grandPriceDescription,
                                                                                      wonGrandPriceImageURL: grandPriceImageURL,
                                                                                      storeImageURL: storeImageURL,
                                                                                      storeName: storeName,
                                                                                      storeSection: storeSection,
                                                                                      storeArea: storeArea,
                                                                                      wonDate: competitionsSnapshot.data().dateTime,
                                                                                      groupCreatorUsername: groupCreatorUsername,
                                                                                      groupCreatorImageURL: groupCreatorImageURL,
                                                                                      groupCreatorPhoneNumber: groupCreatorPhoneNumber,
                                                                                      isFake: isFake,
                                                                                    };

                                                                                    // Create won price summary.
                                                                                    await wonPriceSummaryReference
                                                                                        .set(wonPriceSummary);

                                                                                    // Update corresponding store draw.
                                                                                    /* getFirestore()
                                                                                        .collection("stores")
                                                                                        .doc(storeFK)
                                                                                        .collection("store_draws")
                                                                                        .doc(wonPriceSummaryId)
                                                                                        .update({
                                                                                          storeDrawState:"competition-finished"
                                                                                        });; */
                                                                                  }
                                                                                });
                                                                          }
                                                                        });
                                                              });
                                                        }
                                                      });
                                            });
                                      }
                                    });
                              }
                            });
                      });
                }
              });
        });
      }
    }
  });
});

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/createSupportedAreas/
export const createSupportedAreas = onRequest(async (req, res)=>{
  let reference;

  supportedCountries.forEach(async (countryValue, countryKey, country)=>{
    reference = getFirestore()
        .collection("supported_countries")
        .doc();


    const countryCodeAndName = countryKey.split("-");

    const countryObject = {
      countryId: reference.id,
      countryCode: countryCodeAndName[0],
      countryName: countryCodeAndName[1],
    };
    await reference.set(countryObject, {merge: true});

    supportedProvincesOrStates.forEach(async (provinceOrStateValue, provinceOrStateKey, provinceOrState)=>{
      reference = getFirestore()
          .collection("supported_provinces_or_states")
          .doc();

      const provinceOrStateObject = {
        provinceOrStateId: reference.id,
        provinceOrStateName: provinceOrStateKey,
        country: countryObject,
      };
      await reference.set(provinceOrStateObject, {merge: true});

      supportedCities.forEach(async (cityValue, cityKey, city)=>{
        reference = getFirestore()
            .collection("supported_cities")
            .doc();

        const cityObject = {
          cityId: reference.id,
          cityName: cityKey,
          provinceOrState: provinceOrStateObject,
        };
        await reference.set(cityObject, {merge: true});

        supportedSuburbOrTownships.forEach(async (suburbOrTownshipValue, suburbOrTownshipKey, suburbOrTownship)=>{
          reference = getFirestore()
              .collection("supported_suburbs_or_townships")
              .doc();
          const suburbOrTownshipObject = {
            suburbOrTownshipId: reference.id,
            suburbOrTownshipName: suburbOrTownshipKey,
            city: cityObject,
          };
          await reference.set(suburbOrTownshipObject, {merge: true});

          for (let areaIndex = 0; areaIndex < suburbOrTownshipValue.length; areaIndex++) {
            reference = getFirestore()
                .collection("supported_areas")
                .doc();
            const areaObject = {
              areaId: reference.id,
              areaName: suburbOrTownshipValue[areaIndex],
              suburbOrTownship: suburbOrTownshipObject,
            };
            await reference.set(areaObject, {merge: true});
          }
        });
      });
    });
  });

  res.json({result: `Supported Areas Created Successfully.`});
});

// ##################Production Functions [End]########################

// ########Development Functions [Start]###############

/*
===============================================================
http://127.0.0.1:5001/alcoholic-expressions/us-central1/createSupportedAreas/
http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeAlcoholics
http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeGroups
http://127.0.0.1:5001/alcoholic-expressions/us-central1/createFakeStoreOwners
http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeStores
http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeStoreDraw
http://127.0.0.1:5001/alcoholic-expressions/us-central1/convertStoreDrawsToCompetitions


https://us-central1-alcoholic-expressions.cloudfunctions.net/createSupportedAreas/
https://us-central1-alcoholic-expressions.cloudfunctions.net/saveFakeAlcoholics
https://us-central1-alcoholic-expressions.cloudfunctions.net/saveFakeGroups
https://us-central1-alcoholic-expressions.cloudfunctions.net/createFakeStoreOwners
https://us-central1-alcoholic-expressions.cloudfunctions.net/saveFakeStores
http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeStoreDraw
https://us-central1-alcoholic-expressions.cloudfunctions.net/convertStoreDrawsToCompetitions
==============================================================
*/
// ========Create Alcoholic Data[Start]=============
// Create Fake Alcoholics Usernames.
const alcoholicsUsernames = [
  // Cato Crest
  "Snathi", "Thami", "Mbuso", "Mdu", "Sam", "Vusi", "Sadam",
  "Toto", "Javas", "Mlimi", "Maliyeqolo", "Sihle", "Mtho",
  "Mazweni", "Yninini", "Sphiwe", "Mazeze", "Theniza", "Jam Jam",
  "Radebe",

  // Umlazi H
  "Zakes", "Jimmy", "Mabotsa", "Ntulo", "Snoopy", "Lizwi",
  "Joshua", "Msizi", "Ntwarhayi", "Mbeko", "Bashuthe", "Crouch",
  "Nkazozo", "George", "Madombolo", "Gxabhashe", "Mabhunu",
  "Tho", "Mthoko Mrawu", "Khumkula",

  "Wa", "Swazi", "Cebo", "Ningi", "Sendy", "Ningi", "Kwanele",
  "Lindiwe", "Sindiswa", "Anele", "Zizipho", "Nonhle", "Amanda",
  "Candice", "Sya", "Sandile", "Zethu", "Ankel Sam", "Thalente",
  "Sipho Esihle",

  "L Msomi", "P Majozi", "Z Mnguni", "Mrs Mtshali", "Mr Brown",
  "Mrs Johnson", "P Green", "Zanele", "Zenzele", "JJ Zondo",
  "Nhlaka", "Simo", "Senzo", "Sli", "Sne", "Sma", "Xoli", "Lindo",
  "Aya", "Ayo", "Mini", "Sisi", "Mpe", "Nqo",

  // UKZN Haward
  "Clinton", "Mfundo", "Popayi", "Sfiso Black", "Njabulo", "Msa",
  "Mtapile", "Zambane", "Dakhi", "Khetha", "Mabhiza", "Zulu", "Mlaba",
  "Rosh", "Mngwane", "Ben", "Malimela", "Mkhari", "Mahomed", "Malimela",

  // DUT Durban Central
  "Cindy", "Nkosi",

];
// Create Fake Alcoholics Images.
const alcoholicsImages = [
  // Cato Crest
  "/alcoholics/profile_images/+27848746353.jpg",
  "/alcoholics/profile_images/+27848741215.jpg",
  "/alcoholics/profile_images/+27848743411.jpg",
  "/alcoholics/profile_images/+27765446353.jpg",
  "/alcoholics/profile_images/+27848740000.jpg",
  "/alcoholics/profile_images/+27848746350.jpg",
  "/alcoholics/profile_images/+27668743411.jpg",
  "/alcoholics/profile_images/+27625446353.jpg",
  "/alcoholics/profile_images/+27811740000.jpg",
  "/alcoholics/profile_images/+27788746350.jpg",
  "/alcoholics/profile_images/+27848746311.jpg",
  "/alcoholics/profile_images/+27848741333.jpg",
  "/alcoholics/profile_images/+27848744324.jpg",
  "/alcoholics/profile_images/+27765454543.jpg",
  "/alcoholics/profile_images/+27848740212.jpg",
  "/alcoholics/profile_images/+27848746456.jpg",
  "/alcoholics/profile_images/+27668743000.jpg",
  "/alcoholics/profile_images/+27625446322.jpg",
  "/alcoholics/profile_images/+27811740113.jpg",
  "/alcoholics/profile_images/+27744446350.jpg",

  // Umlazi H
  "/alcoholics/profile_images/+27732540980.jpg",
  "/alcoholics/profile_images/+27657635410.jpg",
  "/alcoholics/profile_images/+27832553370.jpg",
  "/alcoholics/profile_images/+27642312958.jpg",
  "/alcoholics/profile_images/+27672123090.jpg",
  "/alcoholics/profile_images/+27832674900.jpg",
  "/alcoholics/profile_images/+27657788900.jpg",
  "/alcoholics/profile_images/+27781213455.jpg",
  "/alcoholics/profile_images/+27621234765.jpg",
  "/alcoholics/profile_images/+27842390870.jpg",
  "/alcoholics/profile_images/+27638947650.jpg",
  "/alcoholics/profile_images/+27863423400.jpg",
  "/alcoholics/profile_images/+27656736820.jpg",
  "/alcoholics/profile_images/+27812305870.jpg",
  "/alcoholics/profile_images/+27732540986.jpg",
  "/alcoholics/profile_images/+27657635412.jpg",
  "/alcoholics/profile_images/+27832553371.jpg",
  "/alcoholics/profile_images/+27642312957.jpg",
  "/alcoholics/profile_images/+27672123097.jpg",
  "/alcoholics/profile_images/+27832674901.jpg",

  "/alcoholics/profile_images/+27732540983.jpg",
  "/alcoholics/profile_images/+27657635413.jpg",
  "/alcoholics/profile_images/+27832553373.jpg",
  "/alcoholics/profile_images/+27642312953.jpg",
  "/alcoholics/profile_images/+27672123093.jpg",
  "/alcoholics/profile_images/+27832674903.jpg",
  "/alcoholics/profile_images/+27657788903.jpg",
  "/alcoholics/profile_images/+27781213453.jpg",
  "/alcoholics/profile_images/+27621234763.jpg",
  "/alcoholics/profile_images/+27842390873.jpg",
  "/alcoholics/profile_images/+27638947653.jpg",
  "/alcoholics/profile_images/+27863423403.jpg",
  "/alcoholics/profile_images/+27656736823.jpg",
  "/alcoholics/profile_images/+27812305873.jpg",
  "/alcoholics/profile_images/+27732540985.jpg",
  "/alcoholics/profile_images/+27657635414.jpg",
  "/alcoholics/profile_images/+27832553374.jpg",
  "/alcoholics/profile_images/+27642312954.jpg",
  "/alcoholics/profile_images/+27672123094.jpg",
  "/alcoholics/profile_images/+27832674904.jpg",

  "/alcoholics/profile_images/+27674533328.jpg",
  "/alcoholics/profile_images/+27674563548.jpg",
  "/alcoholics/profile_images/+27674563118.jpg",
  "/alcoholics/profile_images/+27674563228.jpg",
  "/alcoholics/profile_images/+27675099018.jpg",
  "/alcoholics/profile_images/+27787653548.jpg",
  "/alcoholics/profile_images/+27674511128.jpg",
  "/alcoholics/profile_images/+27674567778.jpg",
  "/alcoholics/profile_images/+27674533329.jpg",
  "/alcoholics/profile_images/+27674563549.jpg",
  "/alcoholics/profile_images/+27674563119.jpg",
  "/alcoholics/profile_images/+27674563229.jpg",
  "/alcoholics/profile_images/+27675099019.jpg",
  "/alcoholics/profile_images/+27787653549.jpg",
  "/alcoholics/profile_images/+27674511129.jpg",
  "/alcoholics/profile_images/+27674567779.jpg",
  "/alcoholics/profile_images/+27674533320.jpg",
  "/alcoholics/profile_images/+27674563540.jpg",
  "/alcoholics/profile_images/+27674563110.jpg",
  "/alcoholics/profile_images/+27674563220.jpg",
  "/alcoholics/profile_images/+27675099010.jpg",
  "/alcoholics/profile_images/+27787653540.jpg",
  "/alcoholics/profile_images/+27674511120.jpg",
  "/alcoholics/profile_images/+27674567770.jpg",

  // UKZN Haward
  "/alcoholics/profile_images/+27657788909.jpg",
  "/alcoholics/profile_images/+27781213450.jpg",
  "/alcoholics/profile_images/+27621234760.jpg",
  "/alcoholics/profile_images/+27842390875.jpg",
  "/alcoholics/profile_images/+27638947652.jpg",
  "/alcoholics/profile_images/+27863423409.jpg",
  "/alcoholics/profile_images/+27656736829.jpg",
  "/alcoholics/profile_images/+27812305879.jpg",
  "/alcoholics/profile_images/+27731540981.jpg",
  "/alcoholics/profile_images/+27651635411.jpg",
  "/alcoholics/profile_images/+27831553371.jpg",
  "/alcoholics/profile_images/+27641312951.jpg",
  "/alcoholics/profile_images/+27672123091.jpg",
  "/alcoholics/profile_images/+27832674902.jpg",
  "/alcoholics/profile_images/+27657788909.jpg",
  "/alcoholics/profile_images/+27781213452.jpg",
  "/alcoholics/profile_images/+27621234762.jpg",
  "/alcoholics/profile_images/+27842390872.jpg",
  "/alcoholics/profile_images/+27638947653.jpg",
  "/alcoholics/profile_images/+27863423403.jpg",

  // DUT Durban Central
  "/alcoholics/profile_images/+27656736823.jpg",
  "/alcoholics/profile_images/+27812305873.jpg",

];

// Create Fake Alcoholics Phone Numbers
const alcoholicsPhoneNumbers = [
  // Cato Crest
  "+27848746353",
  "+27848741215",
  "+27848743411",
  "+27765446353",
  "+27848740000",
  "+27848746350",
  "+27668743411",
  "+27625446353",
  "+27811740000",
  "+27788746350",
  "+27848746311",
  "+27848741333",
  "+27848744324",
  "+27765454543",
  "+27848740212",
  "+27848746456",
  "+27668743000",
  "+27625446322",
  "+27811740113",
  "+27744446350",

  // Umlazi H
  "+27732540980",
  "+27657635410",
  "+27832553370",
  "+27642312958",
  "+27672123090",
  "+27832674900",
  "+27657788900",
  "+27781213455",
  "+27621234765",
  "+27842390870",
  "+27638947650",
  "+27863423400",
  "+27656736820",
  "+27812305870",
  "+27732540986",
  "+27657635412",
  "+27832553371",
  "+27642312957",
  "+27672123097",
  "+27832674901",

  "+27732541113",
  "+27657635413",
  "+27832553373",
  "+27642312953",
  "+27672123093",
  "+27832674903",
  "+27657788903",
  "+27781213453",
  "+27621234763",
  "+27842390873",
  "+27638947653",
  "+27863423403",
  "+27656736823",
  "+27812305873",
  "+27732540984",
  "+27657635414",
  "+27832553374",
  "+27642312954",
  "+27672123094",
  "+27832674904", // 60

  "+27674533328",
  "+27674563548",
  "+27674563118",
  "+27674563228",
  "+27675099018",
  "+27787653548",
  "+27674511128",
  "+27674567778",
  "+27674533329",
  "+27674563549",
  "+27674563119",
  "+27674563229",
  "+27675099019",
  "+27787653549",
  "+27674511129",
  "+27674567779",
  "+27674533320",
  "+27674563540",
  "+27674563110",
  "+27674563220", // 80

  "+27675099010",
  "+27787653540",
  "+27674511120",
  "+27674567770", // 84

  // UKZN Haward
  "+27657788909",
  "+27781213450",
  "+27621234760", // up to here group specific location image exist.
  "+27842390875",
  "+27638947652",
  "+27863423409",
  "+27656736829",
  "+27812305879",
  "+27731540981",
  "+27651635411",
  "+27831553371",
  "+27641312951",
  "+27672123091",
  "+27832674902",
  "+27652328909",
  "+27781213452",
  "+27621234762",
  "+27842390872",
  "+27631117653",
  "+27863777403", // 104

  // DUT Durban Central
  "+27655556823",
  "+27844405873",
];
// ==========Create Alcoholic Data[End]===============


// ===========Create Stores Owners Data[Start]=================
// Create Fake Store Owner Phone Numbers.
const storeOwnersPhoneNumbers = [
  "+27674533323",
  "+27674563542",
  "+27674563111",
  "+27674563222",
  "+27675099012",
  "+27787653542",
  "+27674511121",
  "+27674567777",
  "UKZN [Haward College]",
  "DUT [Steve Biko]",
];
// Create Fake Store Owners Profile Images.
const storeOwnersProfileImages = [
  "/store_owners/store_owners_images/+27674533323.jpg",
  "/store_owners/store_owners_images/+27674563542.jpg",
  "/store_owners/store_owners_images/+27674563111.jpg",
  "/store_owners/store_owners_images/+27674563222.jpg",
  "/store_owners/store_owners_images/+27675099012.jpg",
  "/store_owners/store_owners_images/+27787653542.jpg",
  "/store_owners/store_owners_images/+27674511121.jpg",
  "/store_owners/store_owners_images/+27674567777.jpg",
  "N/A",
  "N/A",
];
// Create Fake Store Owner Names.
const storeOwnerFullnames = [
  "Sandile James",
  "Thandanani Lungelo",
  "Sizwe",
  "Vusimuzi",
  "Sbongakonke Emmanual",
  "Sihle",
  "Mhlengi",
  "Thabiso Innocent Njabulo",
  "N/A",
  "N/A",
];
// Create Fake Store Owner Names.
const storeOwnerSurnames = [
  "Mkhize",
  "Zondi",
  "Masango",
  "Memela",
  "Khanyile",
  "Mbeje",
  "Mazibuko",
  "Mokoena",
  "N/A",
  "N/A",
];
// Create Fake Identity Documents
const identityDocuments = [
  "/store_owners/store_owners_ids/+27674533323.jpg",
  "/store_owners/store_owners_ids/+27674563542.jpg",
  "/store_owners/store_owners_ids/+27674563111.jpg",
  "/store_owners/store_owners_ids/+27674563222.jpg",
  "/store_owners/store_owners_ids/+27675099012.jpg",
  "/store_owners/store_owners_ids/+27787653542.jpg",
  "/store_owners/store_owners_ids/+27674511121.jpg",
  "/store_owners/store_owners_ids/+27674567777.jpg",
  "N/A",
  "N/A",
];
// ===========================================Create Stores Owners Data[End]===========================================

// ==============================================Create Stores Data[Start]==============================================
// Create Fake Store Names.
const storeNames = [
  // Cato Crest
  "Ka Nkuxa",
  "Ziyasha",
  "6 To 6", // 2

  // Umlazi H
  "Ka Msanga",
  "Emakhehleni",
  "Ka Bhakabhaka",
  "Ka Mjey",
  "Lungelo's Tavern", // 7

  // Haward UKZN
  "UKZN [Haward]", // 8

  // DUT
  "DUT [Steve Biko]", // 9
];

// Create Fake Store Names
const sectionNames = [
  "Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa", // 0
  "Cato Manor-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Dunbar-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Masxha-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Bonela-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Sherwood-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Richview-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa",
  "Manor Gardens-Mayville-Durban-Kwa Zulu Natal-South Africa",

  "A Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "AA Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "B Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "BB Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "C Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "CC Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "D Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "E Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "F Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "G Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "H Section-Umlazi-Durban-Kwa Zulu Natal-South Africa", // 19
  "J Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "K Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "L Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "M Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "N Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "P Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "Q Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "R Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "S Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "U Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "V Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "W Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "Y Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "Z Section-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "Malukazi-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "Philani-Umlazi-Durban-Kwa Zulu Natal-South Africa",
  "MUT-Umlazi-Kwa Zulu Natal-South Africa",

  "Haward College Campus-UKZN-Durban-Kwa Zulu Natal-South Africa", // 37
  "Westville Campus-UKZN-Durban-Kwa Zulu Natal-South Africa",
  "Edgewood Campus-UKZN-Pinetown-Kwa Zulu Natal-South Africa",

  "Steve Biko Campus-DUT-Durban-Kwa Zulu Natal-South Africa", // 40

];
// Create Fake Store images.
const storeImages = [
  "/store_owners/stores_images/+27674533323.jpg",
  "/store_owners/stores_images/+27674563542.jpg",
  "/store_owners/stores_images/+27674563111.jpg",
  "/store_owners/stores_images/+27674563222.jpg",
  "/store_owners/stores_images/+27675099012.jpg",
  "/store_owners/stores_images/+27787653542.jpg",
  "/store_owners/stores_images/+27674511121.jpg",
  "/store_owners/stores_images/+27674567777.jpg",
  "/store_owners/stores_images/+27690900542.jpg", // Haward Image
  "/store_owners/stores_images/+27832121223.jpg", // DUT Image
];
// ==============================================Create Stores Data[End]==============================================

// ========================================Create Draw Grand Prices Data[Start]========================================
// Outer Array Or Rows - Represent stores
// Inner Array Or Columns - Represent store draws
// Cells - Represent no of draw grand prices
const fakeGrandPricesData = [
  [4, 7, 5, 4, 6, 8, 7],
  [5, 8, 5],
  [4, 4, 8, 8, 6],
  [4, 7, 4, 5, 4, 5, 4, 6, 8, 7],
  [5, 8, 4, 5, 7, 5],
  [],
  [4, 5, 5, 5, 8, 7, 7],
  [5, 7],
  [4],
  [],
];

// Create Fake Grand Prices Images
const grandPricesImages = [
  "/grand_prices_images/1.jpeg",
  "/grand_prices_images/2.jpeg",
  "/grand_prices_images/3.jpeg",
  "/grand_prices_images/4.jpeg",
  "/grand_prices_images/5.jpeg",
  "/grand_prices_images/6.jpeg",
  "/grand_prices_images/7.jpeg",
  "/grand_prices_images/8.jpeg",
  "/grand_prices_images/9.jpeg",
  "/grand_prices_images/10.jpeg",
  "/grand_prices_images/11.jpeg",
  "/grand_prices_images/12.jpeg",
  "/grand_prices_images/13.jpeg",
  "/grand_prices_images/14.jpeg",
  "/grand_prices_images/15.jpeg",
  "/grand_prices_images/16.jpeg",
  "/grand_prices_images/17.jpeg",
  "/grand_prices_images/18.jpeg",
  "/grand_prices_images/19.jpeg",
  "/grand_prices_images/20.jpeg",
  "/grand_prices_images/21.jpeg",
  "/grand_prices_images/22.jpeg",
  "/grand_prices_images/23.jpeg",
  "/grand_prices_images/24.jpeg",
  "/grand_prices_images/25.jpeg",
  "/grand_prices_images/26.jpeg",
  "/grand_prices_images/27.jpeg",
  "/grand_prices_images/28.jpeg",
  "/grand_prices_images/29.jpeg",
  "/grand_prices_images/30.jpeg",
  "/grand_prices_images/31.jpeg",
  "/grand_prices_images/32.jpeg",
  "/grand_prices_images/33.jpeg",
  "/grand_prices_images/34.jpeg",
  "/grand_prices_images/35.jpeg",
  "/grand_prices_images/36.jpeg",
  "/grand_prices_images/37.jpeg",
  "/grand_prices_images/38.jpeg",
  "/grand_prices_images/39.jpeg",
  "/grand_prices_images/40.jpeg",
  "/grand_prices_images/41.jpeg",
  "/grand_prices_images/42.jpeg",
  "/grand_prices_images/43.jpeg",
  "/grand_prices_images/44.jpeg",
  "/grand_prices_images/45.jpeg",
  "/grand_prices_images/46.jpeg",
  "/grand_prices_images/47.jpeg",
  "/grand_prices_images/48.jpeg",
  "/grand_prices_images/49.jpeg",
  "/grand_prices_images/50.jpeg",
  "/grand_prices_images/51.jpeg",
  "/grand_prices_images/52.jpeg",
  "/grand_prices_images/53.jpeg",
  "/grand_prices_images/54.jpeg",
  "/grand_prices_images/55.jpeg",
  "/grand_prices_images/56.jpeg",
  "/grand_prices_images/57.jpeg",
  "/grand_prices_images/58.jpeg",
  "/grand_prices_images/59.jpeg",
  "/grand_prices_images/60.jpeg",


];
// Create Fake Grand Prices Descriptions
const descriptions = [
  "alcohol 1- name-volume in ml-quantity",
  "alcohol 2- name-volume in ml-quantity",
  "alcohol 3- name-volume in ml-quantity",
  "alcohol 4- name-volume in ml-quantity",
  "alcohol 5- name-volume in ml-quantity",
  "alcohol 6- name-volume in ml-quantity",
  "alcohol 7- name-volume in ml-quantity",
  "alcohol 8- name-volume in ml-quantity",
  "alcohol 9- name-volume in ml-quantity",
  "alcohol 10- name-volume in ml-quantity",
  "alcohol 11- name-volume in ml-quantity",
  "alcohol 12- name-volume in ml-quantity",
  "alcohol 13- name-volume in ml-quantity",
  "alcohol 14- name-volume in ml-quantity",
  "alcohol 15- name-volume in ml-quantity",
  "alcohol 16- name-volume in ml-quantity",
  "alcohol 17- name-volume in ml-quantity",
  "alcohol 18- name-volume in ml-quantity",
  "alcohol 19- name-volume in ml-quantity",
  "alcohol 20- name-volume in ml-quantity",
  "alcohol 21- name-volume in ml-quantity",
  "alcohol 22- name-volume in ml-quantity",
  "alcohol 23- name-volume in ml-quantity",
  "alcohol 24- name-volume in ml-quantity",
  "alcohol 25- name-volume in ml-quantity",
  "alcohol 26- name-volume in ml-quantity",
  "alcohol 27- name-volume in ml-quantity",
  "alcohol 28- name-volume in ml-quantity",
  "alcohol 29- name-volume in ml-quantity",
  "alcohol 30- name-volume in ml-quantity",
  "alcohol 31- name-volume in ml-quantity",
  "alcohol 32- name-volume in ml-quantity",
  "alcohol 33- name-volume in ml-quantity",
  "alcohol 34- name-volume in ml-quantity",
  "alcohol 35- name-volume in ml-quantity",
  "alcohol 36- name-volume in ml-quantity",
  "alcohol 37- name-volume in ml-quantity",
  "alcohol 38- name-volume in ml-quantity",
  "alcohol 39- name-volume in ml-quantity",
  "alcohol 40- name-volume in ml-quantity",
  "alcohol 41- name-volume in ml-quantity",
  "alcohol 42- name-volume in ml-quantity",
  "alcohol 43- name-volume in ml-quantity",
  "alcohol 44- name-volume in ml-quantity",
  "alcohol 45- name-volume in ml-quantity",
  "alcohol 46- name-volume in ml-quantity",
  "alcohol 47- name-volume in ml-quantity",
  "alcohol 48- name-volume in ml-quantity",
  "alcohol 49- name-volume in ml-quantity",
  "alcohol 50- name-volume in ml-quantity",
  "alcohol 51- name-volume in ml-quantity",
  "alcohol 52- name-volume in ml-quantity",
  "alcohol 53- name-volume in ml-quantity",
  "alcohol 54- name-volume in ml-quantity",
  "alcohol 55- name-volume in ml-quantity",
  "alcohol 56- name-volume in ml-quantity",
  "alcohol 57- name-volume in ml-quantity",
  "alcohol 58- name-volume in ml-quantity",
  "alcohol 59- name-volume in ml-quantity",
  "alcohol 60- name-volume in ml-quantity",

];
let imageAndDescriptionIndex;
// ========================================Create Draw Grand Prices Data[End]========================================

// ========================================Create Groups Data[Start]========================================
const fakeGroupNames = [

  // Cato Crest
  "Izinja Madoda",
  "Abanqobi",
  "Real Madrid", // 2

  // Umlazi H
  "The Angels",
  "Sisonke",
  "Maxican",
  "Millionaires",
  "Abathakathi",
  "Iybotho",
  "Rich Gang",
  "Brazilians",
  "Izichomane",
  "MMM",
  "Abathandazi",
  "Abathwele",
  "Geniuses",
  "Nerds", // 16

  // UKZN Haward
  "Ezinemali",
  "Omabuyengayanga", // 18

  // DUT Durban Central
  "Lucky Ones", //  19
];

// Create Fake Grand Prices Images
const fakeGroupImages = [
  // Cato Crest
  "/groups_specific_locations/+27848746350.jpeg",
  "/groups_specific_locations/+27848740000.jpeg",
  "/groups_specific_locations/+27765454543.jpeg",

  // Umlazi H
  "/groups_specific_locations/+27732540986.jpeg",
  "/groups_specific_locations/+27812305870.jpeg",
  "/groups_specific_locations/+27657788900.jpeg",
  "/groups_specific_locations/+27842390870.jpeg",
  "/groups_specific_locations/+27863423400.jpeg",
  "/groups_specific_locations/+27656736820.jpeg",
  "/groups_specific_locations/+27781213455.jpeg",
  "/groups_specific_locations/+27621234765.jpeg",
  "/groups_specific_locations/+27638947650.jpeg",
  "/groups_specific_locations/+27672123097.jpeg",
  "/groups_specific_locations/+27832674900.jpeg",
  "/groups_specific_locations/+27642312958.jpeg",
  "/groups_specific_locations/+27672123090.jpeg",
  "/groups_specific_locations/+27732540980.jpeg",


  // UKZN Haward
  "/groups_specific_locations/+27848740212.jpeg",
  "/groups_specific_locations/+27848746456.jpeg",

  // DUT Durban Central
  "/groups_specific_locations/+27811740113.jpeg",

];

/* Each row represent a single group and
the first element of that row is the creator's number. */
const groupsMembers = [

  // Cato Crest
  ["+27765446353", "+27848746353", "+27848740000", "+27848746456", "+27668743000", "+27811740113"],
  ["+27744446350", "+27848743411", "+27848741215"],
  ["+27765454543", "+27625446353", "+27811740000", "+27788746350", "+27848741333", "+27848744324", "+27625446322"],

  // Umlazi H
  ["+27732540986", "+27642312957", "+27732540983", "+27657635413", "+27832553373", "+27642312954", "+27672123094", "+27832674904"],
  ["+27812305870", "+27842390873"],
  ["+27657788900", "+27863423403", "+27787653549"],
  ["+27842390870", "+27832674901", "+27674563118", "+27674511129"],
  ["+27863423400", "+27621234763", "+27674563548"],
  ["+27656736820", "+27657635412", "+27832553371", "+27674511128", "+27674533320"],
  ["+27781213455", "+27781213453", "+27674533328"],
  ["+27621234765", "+27674563220", "+27674563110", "+27832553374", "+27638947653", "+27674511120", "+27787653540", "+27675099010", "+27812305873", "+27674533329", "+27674563549", "+27674563119", "+27674563540"],
  ["+27638947650", "+27657788903", "+27787653548"],
  ["+27672123097", "+27832674903", "+27656736823"],
  ["+27832674900", "+27672123093"],
  ["+27642312958", "+27732540983", "+27657635413", "+27674567778", "+27675099018", "+27674563228", "+27674567770"],
  ["+27672123090", "+27642312953"],
  ["+27732540980", "+27657635410", "+27832553370", "+27674563229", "+27675099019"],

  // UKZN Haward
  ["+27848740212", "+27657788909", "+27781213450", "+27621234760",
    "+27842390875", "+27638947652", "+27863423409", "+27656736829",
    "+27812305879", "+27731540981", "+27651635411",
  ],
  ["+27848746456", "+27831553371", "+27641312951", "+27672123091",
    "+27832674902", "+27657788909", "+27781213452", "+27621234762",
    "+27842390872", "+27638947653", "+27863423403",
  ],

  // DUT Durban Central
  ["+27811740113", "+27656736823", "+27812305873"],

];

const groupsLocations = [
  ["Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa", "Ringini", "Stop 2", "Ko 2 Room", "E-Crash"],
  ["H Section-Umlazi-Durban-Kwa Zulu Natal-South Africa", "Estez", "Bhorabhora", "E-Station", "Emarasteni"],
  ["Haward College Campus-UKZN-Durban-Kwa Zulu Natal-South Africa", "Res 1", "Res 2", "Res 3", "Res 4"],
  ["Steve Biko Campus-DUT-Durban-Kwa Zulu Natal-South Africa", "Res 1", "Res 2", "Res 3", "Res 4"],
];

// ========================================Create Groups Data[End]========================================

// req.body.param;
// http://127.0.0.1:5001/alcoholic-expressions/us-central1/create5MembersGroups
export const create5MembersGroups = onRequest(async(req, res)=>{
  
  const group1 = {
    groupName: 'Izinja',
    groupImageURL: '/groups_specific_locations/+27621234765.jpg',
    groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
    groupSpecificArea: 'Ringini',

    groupCreatorPhoneNumber: '+27621234765',
    groupCreatorImageURL: '/alcoholics/profile_images/+27621234765.jpg',
    groupCreatorUsername: 'Sanele',
    isActive: true, // A group is active if it has atleast 10 members.
    maxNoOfMembers: 5, // 5

    groupMembers: [
      {
        phoneNumber: '+27674533329',
        profileImageURL: '/alcoholics/profile_images/+27674533329.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Popi',
        groupFK: '+27621234765',
      },
      {
        phoneNumber: '+27674563110',
        profileImageURL: '/alcoholics/profile_images/+27674563110.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Popi',
        groupFK: '+27621234765',
      },
      {
        phoneNumber: '+27674511120',
        profileImageURL: '/alcoholics/profile_images/+27674511120.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Zinhle',
        groupFK: '+27621234765',
      },
      {
        phoneNumber: '+27621234765',
        profileImageURL: '/alcoholics/profile_images/+27621234765.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Sanele',
        groupFK: '+27621234765',
      },
      {
        phoneNumber: '+27638947653',
        profileImageURL: '/alcoholics/profile_images/+27638947653.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Zee',
        groupFK: '+27621234765',
      },
      
    ]
  };

  const group2 = {
    groupName: 'Faka Phansi',
    groupImageURL: '/groups_specific_locations/+27638947650.jpg',
    groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
    groupSpecificArea: 'Emakhontena',

    groupCreatorPhoneNumber: '+27638947650',
    groupCreatorImageURL: '/alcoholics/profile_images/+27638947650.jpg',
    groupCreatorUsername: 'Cindy',
    isActive: true, // A group is active if it has atleast 10 members.
    maxNoOfMembers: 5, // 5

    groupMembers: [
      {
        phoneNumber: '+27638947650',
        profileImageURL: '/alcoholics/profile_images/+27638947650.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Cindy',
        groupFK: '+27638947650',
      },
      {
        phoneNumber: '+27657788903',
        profileImageURL: '/alcoholics/profile_images/+27657788903.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Popayi',
        groupFK: '+27638947650',
      },
    ]
  };

  const group3 = {
    groupName: 'Fuseg Go 1',
    groupImageURL: '/groups_specific_locations/+27642312958.jpg',
    groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
    groupSpecificArea: 'STOP 9',

    groupCreatorPhoneNumber: '+27642312958',
    groupCreatorImageURL: '/alcoholics/profile_images/+27642312958.jpg',
    groupCreatorUsername: 'Izi',
    isActive: true, // A group is active if it has atleast 10 members.
    maxNoOfMembers: 5, // 5

    groupMembers: [

      {
        phoneNumber: '+27642312958',
        profileImageURL: '/alcoholics/profile_images/+27642312958.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Izi',
        groupFK: '+27642312958',
      },
      {
        phoneNumber: '+27674563228',
        profileImageURL: '/alcoholics/profile_images/+27674563228.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Thembani',
        groupFK: '+27642312958',
      },
      {
        phoneNumber: '+27657635413',
        profileImageURL: '/alcoholics/profile_images/+27657635413.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Soh',
        groupFK: '+27642312958',
      },
    ]
  };

  const group4 = {
    groupName: 'Abomayo',
    groupImageURL: '/groups_specific_locations/+27656736820.jpg',
    groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
    groupSpecificArea: 'Green Land',

    groupCreatorPhoneNumber: '+27656736820',
    groupCreatorImageURL: '/alcoholics/profile_images/+27656736820.jpg',
    groupCreatorUsername: 'Izi',
    isActive: true, // A group is active if it has atleast 10 members.
    maxNoOfMembers: 5, // 5

    groupMembers: [
      {
        phoneNumber: '+27656736820',
        profileImageURL: '/alcoholics/profile_images/+27656736820.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Izi',
        groupFK: '+27656736820',
      },
      {
        phoneNumber: '+27674511128',
        profileImageURL: '/alcoholics/profile_images/+27674511128.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Zakhele',
        groupFK: '+27656736820',
      },
      {
        phoneNumber: '+27674533320',
        profileImageURL: '/alcoholics/profile_images/+27674533320.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Thula',
        groupFK: '+27656736820',
      },
      {
        phoneNumber: '+27657635412',
        profileImageURL: '/alcoholics/profile_images/+27657635412.jpg',
        sectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Sihle',
        groupFK: '+27656736820',
      },
    ]
  };

  const group5 = {
    groupName: 'Excluded',
    groupImageURL: '/groups_specific_locations/+27674563119.jpg',
    groupSectionName: 'Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa',
    groupSpecificArea: 'Stop Street',

    groupCreatorPhoneNumber: '+27674563119',
    groupCreatorImageURL: '/alcoholics/profile_images/+27674563119.jpg',
    groupCreatorUsername: 'Jiro',
    isActive: true, // A group is active if it has atleast 10 members.
    maxNoOfMembers: 5, // 5

    groupMembers: [
      {
        phoneNumber: '+27674563119',
        profileImageURL: '/alcoholics/profile_images/+27674563119.jpg',
        sectionName: 'Nsimbini-Mayville-Durban-Kwa Zulu Natal-South Africa',
        username: 'Mandla',
        groupFK: '+27674563119',
      },
    ]
  };

  const groups = [group1, group2, group3, group4, group5];


  let groupReference;
  let groupMembersPhoneNumbers;

  for(let groupIndex = 0; groupIndex < groups.length; groupIndex++){
    const group = groups[groupIndex];
    groupReference = getFirestore().collection('groups').doc(group.groupCreatorPhoneNumber);
    
    // List of group members phone numbers.
    groupMembersPhoneNumbers = [];


    let alcoholicReference;
    for(let alcoholicIndex = 0; alcoholicIndex < group.groupMembers.length;alcoholicIndex++){
      const alcoholic = group.groupMembers[alcoholicIndex];
      groupMembersPhoneNumbers.push(alcoholic.phoneNumber);
      alcoholicReference = getFirestore().collection('alcoholics').doc(alcoholic.phoneNumber);
      
      await alcoholicReference.set(alcoholic);
    }

    // Replace group members alcoholic object with phone numbers as strings.
    group.groupMembers = groupMembersPhoneNumbers;

    await groupReference.set(group);
    
  }

  // Send back a message that we've successfully written to the db.
  res.json({result: `All Groups & Alcoholics Are Saved.`});
});

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeAlcoholics
// If your function should be openly available,set the cors policy to true.
// region: ["us-west1", "us-east1"]}
export const saveFakeAlcoholics = onRequest(
  {cors: false},
  async (req, res)=>{
    let alcoholicDocReference;
    for (let alcoholicIndex = 0; alcoholicIndex < alcoholicsPhoneNumbers.length; alcoholicIndex++) {
      // Create a document reference in order to associate it id with the stores's id.
      alcoholicDocReference = getFirestore()
          .collection("alcoholics").doc(alcoholicsPhoneNumbers[alcoholicIndex]);

      let sectionName;

      if (alcoholicIndex<20) {
        sectionName = sectionNames[0];
      }
      else if (alcoholicIndex<84) {
        sectionName = sectionNames[19];
      }
      else if (alcoholicIndex<104) {
        sectionName = sectionNames[37];
      }
      else {
        sectionName = sectionNames[40];
      }

      // Grab all parameters, then use them create a alcoholic object.
      const alcoholic = {
        phoneNumber: alcoholicDocReference.id,
        profileImageURL: alcoholicsImages[alcoholicIndex],
        sectionName: sectionName,
        username: alcoholicsUsernames[alcoholicIndex],
        isFake: "Yes",
      };

      // Push the new alcoholic into Firestore using the Firebase Admin SDK.
      await alcoholicDocReference.set(alcoholic);
    }


    // Send back a message that we've successfully written the store
    res.json({result: `All Alcoholics Are Added And They Leave In Cato Crest.`});
  });

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeGroups
export const saveFakeGroups = onRequest(async (req, res)=>{
  for (let groupIndex = 0; groupIndex < groupsMembers.length; groupIndex++) {
    let sectionName;
    let groupLocationIndex;

    if (groupIndex<3) {
      groupLocationIndex = 0;
      sectionName = groupsLocations[groupLocationIndex][0];
    }
    else if (groupIndex<17) {
      groupLocationIndex = 1;
      sectionName = groupsLocations[groupLocationIndex][0];
    }
    else if (groupIndex<19) {
      groupLocationIndex = 2;
      sectionName = groupsLocations[groupLocationIndex][0];
    }
    else {
      groupLocationIndex = 3;
      sectionName = groupsLocations[groupLocationIndex][0];
    }

    const creatorPhoneNumber = groupsMembers[groupIndex][0];
    const groupReference = getFirestore()
        .collection("groups")
        .doc(creatorPhoneNumber);

    const group = {
      groupName: fakeGroupNames[groupIndex],
      groupImageURL: fakeGroupImages[groupIndex],
      groupSectionName: sectionName,
      groupSpecificArea:
        groupsLocations[groupLocationIndex][1 + Math.floor(Math.random()*4)],
      groupCreatorImageURL: alcoholicsImages[groupIndex],
      groupMembers: groupsMembers[groupIndex],
      groupCreatorUsername: alcoholicsUsernames[groupIndex],
      groupCreatorPhoneNumber: groupReference.id,
      isActive: true,
      maxNoOfMembers: 12,
      isFake: "Yes",
    };

    logger.log("Saving group ", groupReference.id);
    await groupReference.set(group);
  }

  // Send back a message that we've successfully written the store
  res.json({result: `All Groups Are Added.`});
});

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/createFakeStoreOwners
export const createFakeStoreOwners = onRequest(async (req, res) => {
  let storeOwnerDocReference;

  for (let storeOwnerIndex = 0; storeOwnerIndex < storeOwnersPhoneNumbers.length; storeOwnerIndex++) {
    // Haward & DUT do not have store owner.
    if (storeOwnerIndex<8) {
      // Create a document reference in order to associate it id with the stores's id.
      storeOwnerDocReference = getFirestore()
          .collection("store_owners").doc(storeOwnersPhoneNumbers[storeOwnerIndex]);

      const storeOwner = {
        phoneNumber: storeOwnersPhoneNumbers[storeOwnerIndex],
        profileImageURL: storeOwnersProfileImages[storeOwnerIndex],
        fullname: storeOwnerFullnames[storeOwnerIndex],
        surname: storeOwnerSurnames[storeOwnerIndex],
        identityDocumentImageURL: identityDocuments[storeOwnerIndex],
        isAdmin: storeOwnerIndex==0,
        isFake: "Yes",
      };

      await storeOwnerDocReference.set(storeOwner);
    }
  }
  res.json({result: `All Store Owners Added Successfully`});
});

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeStore
export const saveFakeStores = onRequest(async (req, res)=>{
  let storeDocReference;

  let storeDrawId;
  let storeDraw;
  let storeDrawReference;

  const justNow = new Date();

  for (let storeIndex = 0; storeIndex < storeNames.length; storeIndex++) {
  // Create a document reference in order to associate it id with the stores's id.
    storeDocReference = getFirestore()
        .collection("stores").doc(storeOwnersPhoneNumbers[storeIndex]);

    let groupLocationIndex;
    if (storeIndex<=2) {
      groupLocationIndex = 0;
    }
    else if (storeIndex<=7) {
      groupLocationIndex = 1;
    }
    else if (storeIndex==8) {
      groupLocationIndex = 2;
    }
    else {
      groupLocationIndex = 3;
    }

    // Grab all parameters, then use them create a store object.
    const store = {
      storeOwnerPhoneNumber: storeOwnersPhoneNumbers[storeIndex],
      storeName: storeNames[storeIndex],
      storeImageURL: storeImages[storeIndex],
      sectionName: groupsLocations[groupLocationIndex][0],
      isFake: "Yes",
      storeArea: groupsLocations[groupLocationIndex][1+Math.floor(Math.random()*(groupsLocations[groupLocationIndex].length-1))],
    };

    // Push the new store into Firestore using the Firebase Admin SDK.
    await storeDocReference.set(store);

    // Create a certain number of store draws.
    for (let storeDrawNo = 0; storeDrawNo < fakeGrandPricesData[storeIndex].length; storeDrawNo++) {
      // Point where to save a store draw.
      storeDrawReference = getFirestore()
          .collection("/stores/").doc(storeOwnersPhoneNumbers[storeIndex])
          .collection("/store_draws/")
          .doc();

      // storeDrawId = `${storeNames[storeIndex]} ${justNow.getDate()}-${justNow.getMonth()+1}-${justNow.getFullYear()} ${justNow.getHours()+2}:${justNow.getMinutes()+3} [${storeDrawFK}]`;
      storeDrawId = storeDrawReference.id;

      // Create a single store draw.
      storeDraw = {
        isFake: "Yes",
        storeDrawId: storeDrawId,
        storeFK: storeOwnersPhoneNumbers[storeIndex],
        drawDateAndTime: {
          "year": justNow.getFullYear() - 1,
          "month": justNow.getMonth() +1, // 1-12
          "day": justNow.getDate(),
          "hour": justNow.getHours() +2, // GMT
          "minute": justNow.getMinutes(),
        },
        joiningFee: Math.random()*2,
        numberOfGrandPrices: fakeGrandPricesData[storeIndex][storeDrawNo],
        isOpen: true,
        storeName: storeNames[storeIndex],
        storeImageURL: storeImages[storeIndex],
        sectionName: store.sectionName,
        storeDrawState: "not-converted-to-competition",
      };


      // Save a store draw into the database.
      await storeDrawReference.set(storeDraw);

      let drawGrandPrice;
      let drawGrandPriceReference;

      // Create grand prices for a particular store draw.
      for (let grandPriceNo = 0; grandPriceNo < storeDraw.numberOfGrandPrices; grandPriceNo++) {
        imageAndDescriptionIndex = Math.floor(Math.random()*grandPricesImages.length);

        // Point where to save a store draw grand price.
        drawGrandPriceReference = getFirestore()
            .collection("stores").doc(storeOwnersPhoneNumbers[storeIndex])
            .collection("store_draws").doc(storeDrawId)
            .collection("draw_grand_prices").doc();

        // Create a grand price
        drawGrandPrice = {
          isFake: "Yes",
          grandPriceId: drawGrandPriceReference.id,
          storeDrawFK: storeDrawId,
          description: descriptions[imageAndDescriptionIndex],
          imageURL: grandPricesImages[imageAndDescriptionIndex],
          grandPriceIndex: grandPriceNo,
        };

        // Save a draw grand price
        await drawGrandPriceReference.set(drawGrandPrice);
      }
    }
  }
  // Send back a message that we've successfully written the store
  res.json({result: `All Fake Stores Added Successfully.`});
  // [END adminSdkAdd]
});

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/saveFakeStoreDraw
export const saveFakeStoreDraw = onRequest(async (req, res)=>{
  const storeIndex = 1; 
  // Point where to save a store draw.
  const storeDrawReference = getFirestore()
      .collection("/stores/").doc('+27661813561')
      .collection("/store_draws/")
      .doc();

  const storeDrawId = storeDrawReference.id;
  
  const justNow = Timestamp.now().toDate();

  // Create a single store draw.
  const storeDraw = {
    isFake: "Yes",
    storeDrawId: storeDrawId,
    storeFK: '+27661813561',
    drawDateAndTime: {
      "year": justNow.getFullYear() + 1,
      "month": justNow.getMonth() +1, // 1-12
      "day": justNow.getDate(),
      "hour": justNow.getHours() +2, // GMT
      "minute": justNow.getMinutes(),
    },
    joiningFee: Math.random()*2,
    numberOfGrandPrices: 5,
    isOpen: true,
    storeName: 'Ka Nkuxa',
    storeImageURL: '/store_owners/store_images/+27661813561.jpg',
    sectionName: "Cato Crest-Mayville-Durban-Kwa Zulu Natal-South Africa",
    storeDrawState: "not-converted-to-competition",
  };

  // Save a store draw into the database.
  await storeDrawReference.set(storeDraw);

  let drawGrandPrice;
  let drawGrandPriceReference;

  // Create grand prices for a particular store draw.
  for (let grandPriceNo = 0; grandPriceNo < storeDraw.numberOfGrandPrices; grandPriceNo++) {
    imageAndDescriptionIndex = Math.floor(Math.random()*grandPricesImages.length);

    // Point where to save a store draw grand price.
    drawGrandPriceReference = getFirestore()
        .collection("stores").doc(storeOwnersPhoneNumbers[storeIndex])
        .collection("store_draws").doc(storeDrawId)
        .collection("draw_grand_prices").doc();

    // Create a grand price
    drawGrandPrice = {
      isFake: "Yes",
      grandPriceId: drawGrandPriceReference.id,
      storeDrawFK: storeDrawId,
      description: descriptions[imageAndDescriptionIndex],
      imageURL: grandPricesImages[imageAndDescriptionIndex],
      grandPriceIndex: grandPriceNo,
    };

    // Save a draw grand price
    await drawGrandPriceReference.set(drawGrandPrice);
  }

  const storeNameInfoReference = getFirestore()
      .collection("/stores_names_info/").doc(storeOwnersPhoneNumbers[storeIndex]);

  await storeNameInfoReference.update({latestStoreDrawId: storeDraw.storeDrawId});

  res.json({result: `Single Store Draw Added Successfully`});
});

// http://127.0.0.1:5001/alcoholic-expressions/us-central1/createFakeComments/
export const createFakeComments = onRequest(async (req, res)=>{
  getFirestore()
      .collection("won_prices_summaries")
      .onSnapshot((wonPricesSummarySnapshop)=>{
        wonPricesSummarySnapshop.docs.forEach(async (wonPriceSummaryDoc)=>{
          if (wonPriceSummaryDoc.exists) {
            const noOfComments = Math.floor(Math.random()*20);

            for (let commentNo = 0; commentNo < noOfComments; commentNo++) {
              const commentRerence = wonPriceSummaryDoc
                  .ref.collection("comments").doc();

              const end = 10 + Math.floor(Math.random()*(commentsSource.length-10));
              const start = Math.floor(Math.random()*(end));
              const creatorIndex = Math.floor(Math.random()*alcoholicsPhoneNumbers.length);

              const wonPriceSummaryComment = {
                commentId: wonPriceSummaryDoc.id,
                wonPriceSummaryFK: wonPriceSummaryDoc.data().wonPriceSummaryId,
                message: commentsSource.substring(start, end),
                creatorImageURL: alcoholicsImages[creatorIndex],
                creatorUsername: alcoholicsUsernames[creatorIndex],
                creatorFK: alcoholicsPhoneNumbers[creatorIndex],
                dateCreated: {
                  year: 2024,
                  month: 10,
                  day: 1 + Math.floor(Math.random()*28),
                  hour: Math.floor(Math.random()*24),
                  minute: Math.floor(Math.random()*60),
                },
                isFake: "Yes",
              };

              await commentRerence.set(wonPriceSummaryComment);
            }
          }
        });
      });

  res.json({result: `Done Saving Fake Won Prices Summaries Comments.`});
});

export const listFruit = onCall((data, context) => {
  return ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"];
}); 

export const writeMessage = onCall(async (data, context) => {
  // Grab the text parameter.
  const original = data.text;
  //Returns the text received
  return `Successfully received: ${original}`;
}); 

const commentsSource =
"JavaScript has become the standard for creating dynamic user interfaces";
"for the web. Pretty much any time you visit a web page with animation, live";
"data, a button that changes when you hover over it, or a drop‐down menu,";
"JavaScript is at work. Because of its power and ability to run in any web";
"browser, JavaScript coding is the most popular and necessary skill for a";
"modern web developer to have. Keep in mind that programming languages were ";
"created in order to give people a simple way to talk to computers and tell ";
"them what to do. Compared with machine language, the language that the ";
"computer’s CPU speaks, every programming language is easy and understandable. ";
"To give right as the program is being run. Programmers who write interpreted ";
"languages don’t need to go through the step of compiling their code prior to ";
"handing it off to the computer to run. The benefit of programming in an interpreted ";
"language is that it’s easy to make changes to the program at any time. The downside, ";
"however, is that compiling code as it’s being run creates another step in the process ";
"and can slow down the performance of programs.Partially because of this performance ";
"factor, interpreted languages have gotten a reputation for being less than serious ";
"programming languages. However, because of better just‐in‐time compilers and faster ";
"computer processors, this perception is rapidly changing. JavaScript is having a big ";
"impact in this regard. Examples of interpreted programming languages include PHP, Perl, ";
"Haskell, Ruby and of course, JavaScript";

// ########################################Development Functions [End]#######################################################


