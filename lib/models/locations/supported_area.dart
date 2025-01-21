import 'supported_suburb_township.dart';

// Collection Name /supported_areas/{supportedAreaId}
// Branch : location_models_creation
class SupportedArea {
  String areaId;
  SupportedSuburbOrTownship suburbOrTownship;
  String areaName;

  SupportedArea({
    required this.areaId,
    required this.suburbOrTownship,
    required this.areaName,
  });

  factory SupportedArea.fromJson(dynamic json) => SupportedArea(
      areaId: json['areaId'],
      suburbOrTownship:
          SupportedSuburbOrTownship.fromJson(json['suburbOrTownship']),
      areaName: json['areaName']);

  @override
  String toString() {
    return '$areaName-${suburbOrTownship.toString()}';
  }
}
