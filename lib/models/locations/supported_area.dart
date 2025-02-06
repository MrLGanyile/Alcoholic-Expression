// Collection Name /supported_areas/{supportedAreaId}
// Branch : lsupported_locations_resources_crud ->  create_supported_locations_front_end
class SupportedArea {
  String areaNo;
  String townshipOrSuburbFK;
  String areaName;

  SupportedArea({
    required this.areaNo,
    required this.townshipOrSuburbFK,
    required this.areaName,
  });

  factory SupportedArea.fromJson(dynamic json) => SupportedArea(
      areaNo: json['areaNo'],
      townshipOrSuburbFK: json['townshipOrSuburbFK'],
      areaName: json['areaName']);

  @override
  String toString() {
    return areaName;
  }
}
