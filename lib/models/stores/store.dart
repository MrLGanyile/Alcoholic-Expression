import '../locations/converter.dart';
import '../locations/section_name.dart';

// Collection Name /stores/storeId
// Branch : store_resources_crud ->  create_store_resources_store_front_end
class Store {
  String storeOwnerPhoneNumber;
  String storeName;
  String storeImageURL;
  SectionName sectionName;
  String storeArea;

  Store({
    required this.storeOwnerPhoneNumber,
    required this.storeName,
    required this.storeImageURL,
    required this.sectionName,
    required this.storeArea,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'storeName': storeName,
      'storeOwnerPhoneNumber': storeOwnerPhoneNumber,
      'storeImageURL': storeImageURL,
      'sectionName': sectionName,
      'storeArea': storeArea,
    });
    return map;
  }

  factory Store.fromJson(dynamic json) {
    return Store(
        storeOwnerPhoneNumber: json['storeOwnerPhoneNumber'],
        storeName: json['storeName'],
        storeImageURL: json['storeImageURL'],
        sectionName: Converter.toSectionName(json['sectionName']),
        storeArea: json['storeArea']);
  }

  @override
  String toString() {
    return 'Store Name: $storeName '
        'Section Name: $sectionName  ';
  }
}
