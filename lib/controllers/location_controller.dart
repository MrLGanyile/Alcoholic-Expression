import '/models/locations/supported_area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// Branch : supported_locations_resources_crud ->  supported_locations_resources_data_access
class LocationController extends GetxController {
  static LocationController locationController = Get.find();

  Stream<List<SupportedArea>> readAllSupportedAreas() {
    Stream<List<SupportedArea>> stream = FirebaseFirestore.instance
        .collection('supported_areas')
        .orderBy('areaName')
        .orderBy('suburbOrTownship.suburbOrTownshipName')
        .orderBy('suburbOrTownship.city.cityName')
        .orderBy('suburbOrTownship.city.provinceOrState.provinceOrStateName')
        .orderBy('suburbOrTownship.city.provinceOrState.country.countryName')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              SupportedArea info = SupportedArea.fromJson(doc.data());
              return info;
            }).toList());

    return stream;
  }
}
