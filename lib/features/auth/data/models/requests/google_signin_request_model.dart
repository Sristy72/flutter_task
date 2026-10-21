class FirebaseSignInRequestModel {
  final String idToken;
  final String provider;
  final String? deviceId;

  const FirebaseSignInRequestModel({
    required this.idToken,
    required this.provider,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_token': idToken,
      'provider': provider,
      if (deviceId != null) 'device_id': deviceId,
    };
  }
}