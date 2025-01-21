import 'supported_country.dart';

// Collection Name /provinces_or_states/{provinceOrStateId}
// Branch : location_models_creation
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
