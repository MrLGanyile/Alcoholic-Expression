import 'dart:io';

import 'package:alco/controllers/share_dao_functions.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/stores/draw_grand_price.dart';
import '../../models/stores/store_draw.dart';
import '../../models/stores/store_name_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/stores/store.dart';

enum StoreDrawSavingStatus {
  loginRequired,
  incomplete,
  saved,
}

// Branch : store_resources_crud ->  store_resources_crud_data_access
class StoreController extends GetxController {
  final firestore = FirebaseFirestore.instance;

  static StoreController storeController = Get.find();

  late Rx<File?> storePickedFile;
  File? get storeImageFile => storePickedFile.value;

  late Rx<String?> _storeOwnerPhoneNumber;
  String? get storeOwnerPhoneNumber => _storeOwnerPhoneNumber.value;

  late Rx<DateTime?> _drawDate;
  DateTime? get drawDate => _drawDate.value;

  late Rx<File?> _drawGrandPrice1ImageFile;
  File? get drawGrandPrice1ImageFile => _drawGrandPrice1ImageFile.value;
  late Rx<String?> _grandPrice1ImageURL;
  String? get grandPrice1ImageURL => _grandPrice1ImageURL.value;
  late Rx<String?> _description1;
  String? get description1 => _description1.value;

  late Rx<File?> _drawGrandPrice2ImageFile;
  File? get drawGrandPrice2ImageFile => _drawGrandPrice2ImageFile.value;
  late Rx<String?> _grandPrice2ImageURL;
  String? get grandPrice2ImageURL => _grandPrice2ImageURL.value;
  late Rx<String?> _description2;
  String? get description2 => _description2.value;

  late Rx<File?> _drawGrandPrice3ImageFile;
  File? get drawGrandPrice3ImageFile => _drawGrandPrice3ImageFile.value;
  late Rx<String?> _grandPrice3ImageURL;
  String? get grandPrice3ImageURL => _grandPrice3ImageURL.value;
  late Rx<String?> _description3;
  String? get description3 => _description3.value;

  late Rx<File?> _drawGrandPrice4ImageFile;
  File? get drawGrandPrice4ImageFile => _drawGrandPrice4ImageFile.value;
  late Rx<String?> _grandPrice4ImageURL;
  String? get grandPrice4ImageURL => _grandPrice4ImageURL.value;
  late Rx<String?> _description4;
  String? get description4 => _description4.value;

  late Rx<File?> _drawGrandPrice5ImageFile;
  File? get drawGrandPrice5ImageFile => _drawGrandPrice5ImageFile.value;
  late Rx<String?> _grandPrice5ImageURL;
  String? get grandPrice5ImageURL => _grandPrice5ImageURL.value;
  late Rx<String?> _description5;
  String? get description5 => _description5.value;

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

  void chooseGrandPriceProfileImageFromGallery(
      int grandPriceIndex,
      String description,
      int year,
      int month,
      int day,
      int hour,
      int minute) async {
    if (description.isEmpty) {
      Get.snackbar('Error', 'Description Missing.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImageFile != null) {
        String grandPriceId =
            '$year-$month-$day@$hour:$minute-$grandPriceIndex';
        switch (grandPriceIndex) {
          case 1:
            _drawGrandPrice1ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice1ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice1ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description1 = Rx<String?>(description);
            break;
          case 2:
            _drawGrandPrice2ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice2ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice2ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description2 = Rx<String?>(description);
            break;
          case 3:
            _drawGrandPrice3ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice3ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice3ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description3 = Rx<String?>(description);
            break;
          case 4:
            _drawGrandPrice4ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice4ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice4ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description4 = Rx<String?>(description);
            break;
          default:
            _drawGrandPrice5ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice5ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice5ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description5 = Rx<String?>(description);
        }
        Get.snackbar('Image Status', 'Image File Successfully Chosen.');
      }
    }
  }

  void captureGrandPriceProfileImageFromCamera(
      int grandPriceIndex,
      String description,
      int year,
      int month,
      int day,
      int hour,
      int minute) async {
    if (description.isEmpty) {
      Get.snackbar('Error', 'Description Missing.');
    } else {
      final pickedImageFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedImageFile != null) {
        String grandPriceId =
            '$year-$month-$day@$hour:$minute-$grandPriceIndex';
        switch (grandPriceIndex) {
          case 1:
            _drawGrandPrice1ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice1ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice1ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description1 = Rx<String?>(description);
            break;
          case 2:
            _drawGrandPrice2ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice2ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice2ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description2 = Rx<String?>(description);
            break;
          case 3:
            _drawGrandPrice3ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice3ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice3ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description3 = Rx<String?>(description);
            break;
          case 4:
            _drawGrandPrice4ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice4ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice4ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description4 = Rx<String?>(description);
            break;
          default:
            _drawGrandPrice5ImageFile = Rx<File?>(File(pickedImageFile.path));
            _grandPrice5ImageURL = Rx<String?>(await uploadResource(
                _drawGrandPrice5ImageFile.value!,
                'grand_prices_images/$grandPriceId'));
            _description5 = Rx<String?>(description);
        }
        Get.snackbar('Image Status', 'Image File Successfully Captured.');
      }
    }
  }

  bool hasGrandPrice(int memberIndex) {
    switch (memberIndex) {
      case 1:
        return _drawGrandPrice1ImageFile.value != null &&
            _grandPrice1ImageURL.value != null &&
            _description1.value != null;
      case 2:
        return _drawGrandPrice2ImageFile.value != null &&
            _grandPrice2ImageURL.value != null &&
            _description2.value != null;
      case 3:
        return _drawGrandPrice3ImageFile.value != null &&
            _grandPrice3ImageURL.value != null &&
            _description3.value != null;
      case 4:
        return _drawGrandPrice4ImageFile.value != null &&
            _grandPrice4ImageURL.value != null &&
            _description4.value != null;
      default:
        return _drawGrandPrice5ImageFile.value != null &&
            _grandPrice5ImageURL.value != null &&
            _description5.value != null;
    }
  }

  Future<StoreDrawSavingStatus> createStoreDraw() async {
    if (_drawDate.value != null &&
        _storeOwnerPhoneNumber.value != null &&
        _drawGrandPrice1ImageFile.value != null &&
        _grandPrice1ImageURL.value != null &&
        _description1.value != null &&
        _drawGrandPrice2ImageFile.value != null &&
        _grandPrice2ImageURL.value != null &&
        _description2.value != null &&
        _drawGrandPrice3ImageFile.value != null &&
        _grandPrice3ImageURL.value != null &&
        _description3.value != null &&
        _drawGrandPrice4ImageFile.value != null &&
        _grandPrice4ImageURL.value != null &&
        _description4.value != null &&
        _drawGrandPrice5ImageFile.value != null &&
        _grandPrice5ImageURL.value != null &&
        _description5.value != null) {
      /*StoreDraw storeDraw = StoreDraw(
          storeFK: _storeOwnerPhoneNumber.value!,
          drawDateAndTime: _drawDate.value!,
          numberOfGrandPrices: 5,
          storeName: storeName,
          storeImageURL: storeImageURL,
          sectionName: sectionName); */
      DrawGrandPrice drawGrandPrice;
      if (hasGrandPrice(1)) {
        /*drawGrandPrice = DrawGrandPrice(
            storeDrawFK: storeDrawFK,
            imageURL: imageURL,
            description: description,
            grandPriceIndex: grandPriceIndex); */
        return StoreDrawSavingStatus.incomplete;
      } else {
        return StoreDrawSavingStatus.incomplete;
      }
    } else {
      return StoreDrawSavingStatus.incomplete;
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
