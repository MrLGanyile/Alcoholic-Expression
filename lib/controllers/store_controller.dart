import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/stores/draw_grand_price.dart';
import '../../models/stores/store_draw.dart';
import '../../models/stores/store_name_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/stores/store.dart';

// Branch : store_resources_crud ->  store_resources_crud_data_access
class StoreController extends GetxController {
  static StoreController storeController = Get.find();

  late Rx<File?> storePickedFile;
  File? get storeImageFile => storePickedFile.value;

  // Branch : store_resources_crud ->  store_resources_crud_data_access
  void chooseStoreImageFromGallery() async {
    final storePickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (storePickedImageFile != null) {
      //Get.snackbar('Image Status', 'Image File Successfully Picked.');

    }

    // Share the chosen image file on Getx State Management.
    storePickedFile = Rx<File?>(File(storePickedImageFile!.path));
  }

  // Branch : store_resources_crud ->  store_resources_crud_data_access
  void captureStoreImageWithCamera() async {
    final storePickedImageFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (storePickedImageFile != null) {
      Get.snackbar('Image Status', 'Image File Successfully Captured.');
    }

    // Share the chosen image file on Getx State Management.
    storePickedFile = Rx<File?>(File(storePickedImageFile!.path));
  }

  /*===========================Stores [Start]============================= */

  // Branch : store_resources_crud ->  store_resources_crud_data_access
  Future<Store?> findStore(String storeId) async {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('stores').doc(storeId);

    DocumentSnapshot snapshot = await reference.get();

    if (snapshot.exists) {
      return Store.fromJson(snapshot.data()!);
    }

    return null;
  }

/*===========================Stores [End]============================= */

/*======================Store Name Info [Start]======================== */
  // Branch : store_resources_crud ->  store_resources_crud_data_access
  Stream<DocumentSnapshot> retrieveStoreNameInfo(String storeNameInfoId) {
    return FirebaseFirestore.instance
        .collection("stores_names_info")
        .doc(storeNameInfoId)
        .snapshots();
  }

  // Branch : store_resources_crud ->  store_resources_crud_data_access
  Future<StoreNameInfo?> findStoreNameInfo(String storeNameInfoId) async {
    DocumentReference reference = FirebaseFirestore.instance
        .collection("stores_names_info")
        .doc(storeNameInfoId);

    reference.snapshots().map((referenceDoc) {
      return StoreNameInfo.fromJson(referenceDoc.data());
    });

    return null;
  }

  // Branch : store_resources_crud ->  store_resources_crud_data_access
  Stream<List<StoreNameInfo>> readAllStoreNameInfo() {
    Stream<List<StoreNameInfo>> stream = FirebaseFirestore.instance
        .collection('stores_names_info')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              StoreNameInfo info = StoreNameInfo.fromJson(doc.data());
              return info;
            }).toList());

    return stream;
  }

  /*======================Store Name Info [End]======================== */

  /*=========================Store Draws [Start]========================= */
  // Branch : competition_resources_crud ->  competitions_data_access
  Stream<List<StoreDraw>> findStoreDraws(String storeFK) {
    return FirebaseFirestore.instance
        .collection('stores')
        .doc(storeFK)
        .collection('store_draws')
        .orderBy('drawDateAndTime.year', descending: false)
        .orderBy('drawDateAndTime.month', descending: false)
        .orderBy('drawDateAndTime.day', descending: false)
        .orderBy('drawDateAndTime.hour', descending: false)
        .orderBy('drawDateAndTime.minute', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StoreDraw.fromJson(doc.data()))
            .toList());
  }

  // Branch : competition_resources_crud ->  competitions_data_access
  Stream<DocumentSnapshot<Object?>> retrieveStoreDraw(
      String storeFK, String storeDrawId) {
    DocumentReference reference = FirebaseFirestore.instance
        .collection('stores')
        .doc(storeFK)
        .collection('store_draws')
        .doc(storeDrawId);

    return reference.snapshots();
  }

  // Update - reference.update({'key': 'new value'} or {'param.key': 'new value'})
  // Remove A Field - update({'key': FieldValue.delete())
  void updateIsOpen(String storeFK, String storeDrawId, bool isOpen) {
    FirebaseFirestore.instance
        .collection('stores')
        .doc(storeFK)
        .collection('store_draws')
        .doc(storeDrawId)
        .update({'Is Open': isOpen});
  }

  void updateJoiningFee(String storeFK, String storeDrawId, double joiningFee) {
    if (joiningFee > 0) {
      FirebaseFirestore.instance
          .collection('stores')
          .doc(storeFK)
          .collection('store_draws')
          .doc(storeDrawId)
          .update({'Is Open': joiningFee});
    }
  }

  /*===========================Store Draws [End]====================== */

  /*======================Draw Grand Price[Start]===================== */
  // Branch : competition_resources_crud ->  competitions_data_access
  Stream<List<DrawGrandPrice>> findDrawGrandPrices(
          String storeId, String storeDrawId) =>
      FirebaseFirestore.instance
          .collection('stores')
          .doc(storeId)
          .collection('store_draws')
          .doc(storeDrawId)
          .collection('draw_grand_prices')
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DrawGrandPrice.fromJson(doc.data()))
              .toList());

  /*======================Draw Grand Price[End]============================ */
}
