class LoginRequestModel {
  final String email;
  final String password;
  final String? deviceId;

  const LoginRequestModel({
    required this.email,
    required this.password,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      if (deviceId != null) 'device_id': deviceId,
    };
  }
}