
class VerifyOtpRequestModel {
  final String email;
  final String otp;
  final String? deviceId;

  const VerifyOtpRequestModel({
    required this.email,
    required this.otp,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'otp': otp,
      if (deviceId != null) 'device_id': deviceId,
    };
  }
}
