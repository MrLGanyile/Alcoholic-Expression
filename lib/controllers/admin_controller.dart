import 'dart:io';

import '../models/locations/section_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/users/admin.dart';
import 'share_dao_functions.dart';
import 'dart:math';
import 'dart:developer' as debug;

enum AdminSavingStatus {
  incompleteData,
  adminAlreadyExist,
  loginRequired,
  unathourized,
  saved,
}

class AdminController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final functions = FirebaseFunctions.instance;
  final storage = FirebaseStorage.instance
      .refFromURL("gs://alcoholic-expressions.appspot.com/");
  final auth = FirebaseAuth.instance;

  static AdminController instance = Get.find();

  // ignore: prefer_final_fields
  late Rx<File?> _newAdminProfileImage = Rx(null);
  File? get newAdminProfileImage => _newAdminProfileImage.value;

  // ignore: prefer_final_fields
  late Rx<String> _newAdminProfileImageURL = Rx('');
  String get newAdminProfileImageURL => _newAdminProfileImageURL.value;

  // ignore: prefer_final_fields
  late Rx<String?> _newAdminPhoneNumber = Rx(null);
  String? get newAdminPhoneNumber => _newAdminPhoneNumber.value;

  // ignore: prefer_final_fields
  late Rx<SectionName> _newAdminSectionName =
      Rx(SectionName.howardCollegeCampusUKZNDurbanKwaZuluNatalSouthAfrica);
  SectionName get newAdminSectionName => _newAdminSectionName.value;

  // ignore: prefer_final_fields
  late Rx<bool> _newAdminIsFemale = Rx(true);
  bool get newAdminIsFemale => _newAdminIsFemale.value;

  // ignore: prefer_final_fields
  late Rx<Admin?> _currentAdmin = Rx(null);
  Admin? get currentAdmin => _currentAdmin.value;

  void chooseAdminProfileImageFromGallery(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar(
          'Error', 'Phone Number Is Required Before Picking An Image.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImageFile != null) {
        _newAdminProfileImage = Rx<File?>(File(pickedImageFile.path));
        _newAdminProfileImageURL = Rx<String>(await uploadResource(
            _newAdminProfileImage.value!,
            '/admins/profile_images/$phoneNumber'));
        _newAdminPhoneNumber = Rx<String?>(phoneNumber);
        Get.snackbar('Image Status', 'Image File Successfully Picked.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Picked.');
      }
    }
  }

  void captureAdminProfileImageWithCamera(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      Get.snackbar(
          'Error', 'Phone Number Is Required Before Picking An Image.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImageFile != null) {
        _newAdminProfileImage = Rx<File?>(File(pickedImageFile.path));
        _newAdminProfileImageURL = Rx<String>(await uploadResource(
            _newAdminProfileImage.value!,
            '/admins/profile_images/$phoneNumber'));
        _newAdminPhoneNumber = Rx<String?>(phoneNumber);

        Get.snackbar('Image Status', 'Image File Successfully Picked.');
        update();
      } else {
        Get.snackbar('Error', 'Image Wasn\'t Picked.');
      }
    }
  }

  void setNewAdminSectionName(SectionName sectionName) {
    _newAdminSectionName = Rx<SectionName>(sectionName);
    update();
  }

  void setNewAdminIsFemale(bool isFemale) {
    _newAdminIsFemale = Rx<bool>(isFemale);
    update();
  }

  Future<AdminSavingStatus> saveAdmin() async {
    if (_currentAdmin.value == null) {
      return AdminSavingStatus.loginRequired;
    } else if (!_currentAdmin.value!.isSuperiorAdmin) {
      return AdminSavingStatus.unathourized;
    } else if (_newAdminProfileImage.value == null ||
        _newAdminProfileImageURL.value == null ||
        _newAdminPhoneNumber.value == null) {
      return AdminSavingStatus.incompleteData;
    } else {
      DocumentReference adminReference =
          firestore.collection('admins').doc(_newAdminPhoneNumber.value);
      AdminSavingStatus status = AdminSavingStatus.adminAlreadyExist;
      adminReference.snapshots().map((adminDoc) async {
        if (!adminDoc.exists) {
          String characters =
              'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
          Random random = Random();

          String key = '';
          key += characters[random.nextInt(characters.length)];
          key += characters[random.nextInt(characters.length)];
          key += characters[random.nextInt(characters.length)];

          Admin admin = Admin(
            phoneNumber: _newAdminPhoneNumber.value,
            profileImageURL: _newAdminProfileImage.value,
            key: key,
            isFemale: _newAdminIsFemale.value,
            isSuperiorAdmin: false,
          );

          await adminReference.set(admin.toJson());
          _currentAdmin = Rx(admin);
          status = AdminSavingStatus.saved;
        }
      });
      return status;
    }
  }
}
