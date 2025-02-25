import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../models/users/admin.dart';
import '../models/users/alcoholic.dart';
import '../models/users/user.dart' as myUser;
import 'package:get/get.dart';

bool showProgressBar = false;
final firestore = FirebaseFirestore.instance;
final functions = FirebaseFunctions.instance;
final storage = FirebaseStorage.instance
    .refFromURL("gs://alcoholic-expressions.appspot.com/");
final auth = FirebaseAuth.instance;

// ignore: prefer_final_fields
Rx<myUser.User?> _currentlyLoggedInUser = Rx(
    null /*Admin(
    phoneNumber: '0661813561',
    profileImageURL: 'admins/profile_images/superior/0661813561.jpg',
    isFemale: false,
    isSuperiorAdmin: true,
    key: "000")*/
    );
myUser.User? get currentlyLoggedInUser => _currentlyLoggedInUser.value;

// Upload an image into a particular firebase storage bucket.
Future<String> uploadResource(File resource, String storagePath) async {
  Reference reference = FirebaseStorage.instance.ref().child(storagePath);

  final metadata = SettableMetadata(contentType: "image/jpeg");

  UploadTask uploadTask = reference.putFile(resource, metadata);
  TaskSnapshot taskSnapshot = await uploadTask;

  String downloadURL = await taskSnapshot.ref.getDownloadURL();
  return downloadURL;
}

Future<String> findFullImageURL(String imageURL) async {
  Reference storageReference = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  return await storageReference.child(imageURL).getDownloadURL();
}

bool isCredentialsCorrect(String phoneNumber, String password, bool forAdmin) {
  return true;
}

void loginUser(String userPhoneNumber, bool forAdmin) {
  DocumentReference reference;
  if (forAdmin) {
    reference = firestore.collection('admins').doc(userPhoneNumber);

    reference.snapshots().map((adminDoc) {
      if (adminDoc.exists) {
        Admin admin = Admin.fromJson(adminDoc.data());
        _currentlyLoggedInUser = Rx(admin);
      }
    });
  } else {
    reference = firestore.collection('alcoholics').doc(userPhoneNumber);
    reference.snapshots().map((alcoholicDoc) {
      // Currently logged in user is an alcoholic
      if (alcoholicDoc.exists) {
        Alcoholic alcoholic = Alcoholic.fromJson(alcoholicDoc.data());
        _currentlyLoggedInUser = Rx(alcoholic);
      }
    });
  }
}

void logoutUser() {
  _currentlyLoggedInUser = Rx(null);
}

bool containsNumbersOnly(String phoneNumber) {
  for (var charIndex = 0; charIndex < phoneNumber.length; charIndex++) {
    if (!(phoneNumber[charIndex] == '0' ||
        phoneNumber[charIndex] == '1' ||
        phoneNumber[charIndex] == '2' ||
        phoneNumber[charIndex] == '3' ||
        phoneNumber[charIndex] == '4' ||
        phoneNumber[charIndex] == '5' ||
        phoneNumber[charIndex] == '6' ||
        phoneNumber[charIndex] == '7' ||
        phoneNumber[charIndex] == '8' ||
        phoneNumber[charIndex] == '9')) {
      return false;
    }
  }
  return true;
}

bool isValidPhoneNumber(String phoneNumber) {
  return phoneNumber.isNotEmpty &&
      phoneNumber.length == 10 &&
      phoneNumber.isNumericOnly &&
      (phoneNumber.startsWith('06') ||
          phoneNumber.startsWith('07') ||
          phoneNumber.startsWith('08'));
}
