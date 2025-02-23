import 'dart:io';
import 'dart:developer' as debug;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/locations/converter.dart';
import '../models/locations/section_name.dart';
import '../models/users/alcoholic.dart';
import 'share_dao_functions.dart';

enum AlcoholicSavingStatus {
  incompleteData,
  adminAlreadyExist,
  loginRequired,
  unathourized,
  saved,
}

class AlcoholicController extends GetxController {
  static AlcoholicController alcoholicController = Get.find();

  final firestore = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instance;
  final storage = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");

  late Rx<File?> _newAlcoholicProfileImageFile;
  File? get newAlcoholicProfileImageFile => _newAlcoholicProfileImageFile.value;
  // ignore: prefer_final_fields
  late Rx<String?> _newAlcoholicImageURL = Rx('');
  String? get newAlcoholicImageURL => _newAlcoholicImageURL.value;
  // ignore: prefer_final_fields
  late Rx<String?> _newAlcoholicPhoneNumber = Rx('');
  String? get newAlcoholicPhoneNumber => _newAlcoholicPhoneNumber.value;
  // ignore: prefer_final_fields
  late Rx<String?> _newAlcoholicUsername = Rx('');
  String? get newAlcoholicUsername => _newAlcoholicUsername.value;

  // ignore: prefer_final_fields
  late Rx<String> _newAlcoholicPassword = Rx('');
  String get newAlcoholicPassword => _newAlcoholicPassword.value;

  // ignore: prefer_final_fields
  late Rx<SectionName> _newAlcoholSectionName =
      Rx(SectionName.howardCollegeCampusUKZNDurbanKwaZuluNatalSouthAfrica);
  SectionName get newAlcoholSectionName => _newAlcoholSectionName.value;

  Rx<SectionName?> locateableSectionName = Rx<SectionName>(
      SectionName.dutDurbanCentralDurbanKwaZuluNatalSouthAfrica);
  SectionName? get searchedSectionName => locateableSectionName.value;

  void captureAlcoholicProfileImageWithCamera(
      String phoneNumber, String username) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar(
          'Error', 'Phone Number Is Required Before Capturing An Image.');
    } else if (username.isEmpty) {
      Get.snackbar('Error', 'Username Is Required Before Capturing An Image.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImageFile != null) {
        _newAlcoholicProfileImageFile = Rx<File?>(File(pickedImageFile.path));
        _newAlcoholicImageURL = Rx<String?>(await uploadResource(
            _newAlcoholicProfileImageFile.value!,
            '/alcoholics/profile_images/$phoneNumber'));
        _newAlcoholicPhoneNumber = Rx<String?>(phoneNumber);
        _newAlcoholicUsername = Rx<String?>(username);
        Get.snackbar('Image Status', 'Image File Successfully Captured.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Captured.');
      }
    }
  }

  void chooseAlcoholicProfileImageFromGallery(
      String phoneNumber, String username) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar(
          'Error', 'Phone Number Is Required Before Capturing An Image.');
    } else if (username.isEmpty) {
      Get.snackbar('Error', 'Username Is Required Before Capturing An Image.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImageFile != null) {
        _newAlcoholicProfileImageFile = Rx<File?>(File(pickedImageFile.path));
        _newAlcoholicImageURL = Rx<String?>(await uploadResource(
            _newAlcoholicProfileImageFile.value!,
            '/alcoholics/profile_images/$phoneNumber'));
        _newAlcoholicPhoneNumber = Rx<String?>(phoneNumber);
        _newAlcoholicUsername = Rx<String?>(username);
        Get.snackbar('Image Status', 'Image File Successfully Captured.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Captured.');
      }
    }
  }

  String trimmedImageURL() {
    return _newAlcoholicImageURL.value!
        .substring(_newAlcoholicImageURL.value!.indexOf('/alcoholics'),
            _newAlcoholicImageURL.value!.indexOf('?'))
        .replaceAll('%2F', '/');
  }

  Stream<List<Alcoholic>> readAlcoholics() {
    Stream<List<Alcoholic>> stream;
    if (locateableSectionName.value == null) {
      stream = firestore
          .collection('alcoholics')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Alcoholic alcoholic = Alcoholic.fromJson(doc.data());
                return alcoholic;
              }).toList());
    } else {
      stream = firestore
          .collection('alcoholics')
          .where('sectionName',
              isEqualTo: Converter.asString(locateableSectionName.value!))
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Alcoholic alcoholic = Alcoholic.fromJson(doc.data());
                return alcoholic;
              }).toList());
    }

    return stream;
  }

  void setSearchedSectionName(String chosenSectionName) {
    locateableSectionName =
        Rx<SectionName?>(Converter.toSectionName(chosenSectionName));
    update();
  }

  Future<AlcoholicSavingStatus> saveAlcoholic() async {
    if (newAlcoholicProfileImageFile != null &&
        _newAlcoholicImageURL.value != null &&
        _newAlcoholicPhoneNumber.value != null &&
        isValidPhoneNumber(_newAlcoholicPhoneNumber.value!) &&
        _newAlcoholicUsername.value != null) {
      try {
        DocumentReference reference = firestore
            .collection('alcoholics')
            .doc(_newAlcoholicPhoneNumber.value);

        Alcoholic alcoholic = Alcoholic(
            password: _newAlcoholicPassword.value,
            phoneNumber: reference.id,
            profileImageURL: trimmedImageURL(),
            username: _newAlcoholicUsername.value!,
            sectionName: _newAlcoholSectionName.value);

        await firestore
            .collection('alcoholics')
            .doc(alcoholic.phoneNumber)
            .set(alcoholic.toJson());
        showProgressBar = false;
        return AlcoholicSavingStatus.saved;
      } catch (error) {
        Get.snackbar("Saving Error", "Alcoholic Couldn'\t Be Saved.");
        debug.log(error.toString());
        showProgressBar = false;
        return AlcoholicSavingStatus.unathourized;
      }
    } else {
      return AlcoholicSavingStatus.incompleteData;
    }
  }
}
