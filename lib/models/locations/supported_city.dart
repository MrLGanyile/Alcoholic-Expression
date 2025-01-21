// Collection Name /supported_cities/{supportedCityId}
// Branch : location_models_creation
import 'supported_province_or_state.dart';

class SupportedCity {
  String cityId;
  SupportedProvinceOrState provinceOrState;
  String cityName;

  SupportedCity(
      {required this.cityId,
      required this.provinceOrState,
      required this.cityName});

  factory SupportedCity.fromJson(dynamic json) => SupportedCity(
      cityId: json['cityId'],
      provinceOrState:
          SupportedProvinceOrState.fromJson(json['provinceOrState']),
      cityName: json['cityName']);

  @override
  String toString() {
    return '$cityName-${provinceOrState.toString()}';
  }
}
