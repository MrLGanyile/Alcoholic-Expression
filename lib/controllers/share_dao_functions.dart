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
late Rx<myUser.User?> _currentlyLoggedInUser = Rx(Admin(
    phoneNumber: '0661813561',
    profileImageURL: 'admins/profile_images/superior/0661813561.jpg',
    isFemale: false,
    isSuperiorAdmin: true,
    key: "000"));
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

void loginUser(String userPhoneNumber) {
  DocumentReference reference =
      firestore.collection('alcoholics').doc(userPhoneNumber);

  reference.snapshots().map((alcoholicDoc) {
    // Currently logged in user is an alcoholic
    if (alcoholicDoc.exists) {
      Alcoholic alcoholic = Alcoholic.fromJson(alcoholicDoc.data());
      _currentlyLoggedInUser = Rx(alcoholic);
    } else {
      reference = firestore.collection('admins').doc(userPhoneNumber);

      reference.snapshots().map((adminDoc) {
        if (adminDoc.exists) {
          Admin admin = Admin.fromJson(adminDoc.data());
          _currentlyLoggedInUser = Rx(admin);
        }
      });
    }
  });
}

void logoutUser() {
  _currentlyLoggedInUser = Rx(null);
}

bool isValidPhoneNumber(String phoneNumber) {
  return phoneNumber.isNotEmpty &&
      phoneNumber.length == 10 &&
      phoneNumber.isNumericOnly &&
      (phoneNumber.startsWith('06') ||
          phoneNumber.startsWith('07') ||
          phoneNumber.startsWith('08'));
}
