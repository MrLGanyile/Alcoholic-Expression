// Collection Name /suburbs_or_townships/{suburbOrTownshipId}
// Branch : supported_locations_resources_crud ->  create_supported_locations_front_end
class SupportedSuburbOrTownship {
  String townshipOrSuburbNo;
  String cityFK;
  String townshipOrSuburbName;

  SupportedSuburbOrTownship({
    required this.townshipOrSuburbNo,
    required this.cityFK,
    required this.townshipOrSuburbName,
  });

  factory SupportedSuburbOrTownship.fromJson(dynamic json) =>
      SupportedSuburbOrTownship(
          townshipOrSuburbNo: json['townshipOrSuburbNo'],
          cityFK: json['cityFK'],
          townshipOrSuburbName: json['townshipOrSuburbName']);

  @override
  String toString() {
    return townshipOrSuburbName;
  }
}
