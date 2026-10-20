class GuestLoginRequestModel {
  final String deviceId;

  GuestLoginRequestModel({
    required this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
    };
  }
}