import 'supported_country.dart';

// Collection Name /provinces_or_states/{provinceOrStateId}
// Branch : supported_locations_resources_crud ->  create_supported_locations_front_end
class SupportedProvinceOrState {
  String provinceOrStateId;
  String provinceOrStateName;
  SupportedCountry country;

  SupportedProvinceOrState({
    required this.provinceOrStateId,
    required this.provinceOrStateName,
    required this.country,
  });

  factory SupportedProvinceOrState.fromJson(dynamic json) =>
      SupportedProvinceOrState(
        provinceOrStateId: json['provinceOrStateId'],
        provinceOrStateName: json['provinceOrStateName'],
        country: SupportedCountry.fromJson(json['country']),
      );

  @override
  String toString() {
    return '$provinceOrStateName-${country.toString()}';
  }
}
