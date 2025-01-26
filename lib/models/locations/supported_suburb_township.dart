import 'supported_city.dart';

// Collection Name /suburbs_or_townships/{suburbOrTownshipId}
// Branch : supported_locations_resources_crud ->  create_supported_locations_front_end
class SupportedSuburbOrTownship {
  String suburbOrTownshipId;
  SupportedCity city;
  String suburbOrTownshipName;

  SupportedSuburbOrTownship({
    required this.suburbOrTownshipId,
    required this.city,
    required this.suburbOrTownshipName,
  });

  factory SupportedSuburbOrTownship.fromJson(dynamic json) =>
      SupportedSuburbOrTownship(
          suburbOrTownshipId: json['suburbOrTownshipId'],
          city: SupportedCity.fromJson(json['city']),
          suburbOrTownshipName: json['suburbOrTownshipName']);

  @override
  String toString() {
    return '$suburbOrTownshipName-${city.toString()}';
  }
}
