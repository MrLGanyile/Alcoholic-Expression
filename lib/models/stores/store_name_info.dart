import '../locations/converter.dart';

import '../locations/section_name.dart';

// Branch : store_resources_crud ->  create_store_resources_store_front_end
class StoreNameInfo implements Comparable<StoreNameInfo> {
  String storeNameInfoId;
  String storeName;
  SectionName sectionName;
  String storeArea;
  String storeImageURL;
  bool canAddStoreDraw;
  late String latestStoreDrawId;

  StoreNameInfo({
    required this.storeNameInfoId,
    this.latestStoreDrawId = '-',
    required this.storeName,
    required this.sectionName,
    required this.storeArea,
    required this.storeImageURL,
    required this.canAddStoreDraw,
  });

  factory StoreNameInfo.fromJson(dynamic json) => StoreNameInfo(
      storeNameInfoId: json['storeNameInfoId'],
      storeName: json['storeName'],
      sectionName: Converter.toSectionName(json['sectionName']),
      storeArea: json['storeArea'],
      storeImageURL: json['storeImageURL'],
      latestStoreDrawId: json['latestStoreDrawId'],
      canAddStoreDraw: json['canAddStoreDraw']);

  @override
  int compareTo(StoreNameInfo other) {
    return other.storeArea.compareTo(storeArea);
  }
}
