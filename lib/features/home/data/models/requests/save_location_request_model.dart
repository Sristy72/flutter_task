class SaveLocationRequestModel {
  final double latitude;
  final double longitude;

  const SaveLocationRequestModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'latitude': double.parse(latitude.toStringAsFixed(6)),
        'longitude': double.parse(longitude.toStringAsFixed(6)),
      };
}
