// Collection Name /supported_countries/{supportedCountryId}
// Branch : location_models_creation
class SupportedCountry {
  String countryId;
  String countryName;
  String countryCode;
  SupportedCountry({
    required this.countryId,
    required this.countryName,
    required this.countryCode,
  });

  factory SupportedCountry.fromJson(dynamic json) => SupportedCountry(
        countryId: json['countryId'],
        countryName: json['countryName'],
        countryCode: json['countryCode'],
      );

  @override
  String toString() {
    return countryName;
  }
}
