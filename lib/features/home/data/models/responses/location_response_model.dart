class LocationResponseModel {
  final String latitude;
  final String longitude;
  final String address;
  final String city;
  final String countryCode;
  final String timezone;

  const LocationResponseModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.countryCode,
    required this.timezone,
  });

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) {
    return LocationResponseModel(
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      countryCode: json['country_code'] ?? '',
      timezone: json['timezone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country_code': countryCode,
      'timezone': timezone,
    };
  }
}