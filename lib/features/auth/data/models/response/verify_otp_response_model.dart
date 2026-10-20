class VerifyOtpResponseModel {
  final String detail;
  final VerifyOtpUserModel? user;
  final String access;
  final String refresh;

  const VerifyOtpResponseModel({
    required this.detail,
    this.user,
    required this.access,
    required this.refresh,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    // Check if response is wrapped in { "status": ..., "data": { ... } }
    final payload = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : json);

    return VerifyOtpResponseModel(
      detail: payload['detail']?.toString() ??
          json['detail']?.toString() ??
          json['message']?.toString() ??
          '',
      user: payload['user'] != null && payload['user'] is Map
          ? VerifyOtpUserModel.fromJson(
              Map<String, dynamic>.from(payload['user'] as Map),
            )
          : null,
      access: payload['access']?.toString() ??
          json['access']?.toString() ??
          payload['access_token']?.toString() ??
          '',
      refresh: payload['refresh']?.toString() ??
          json['refresh']?.toString() ??
          payload['refresh_token']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      if (user != null) 'user': user!.toJson(),
      'access': access,
      'refresh': refresh,
    };
  }
}

class VerifyOtpUserModel {
  final int id;
  final String email;
  final String fullName;
  final String? mobile;
  final bool isVerified;
  final String? firebaseUid;

  const VerifyOtpUserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.mobile,
    required this.isVerified,
    this.firebaseUid,
  });

  factory VerifyOtpUserModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpUserModel(
      id: json['id'] is int
          ? json['id'] as int
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      email: json['email']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString() ?? '',
      mobile: json['mobile']?.toString(),
      isVerified: json['is_verified'] is bool
          ? json['is_verified'] as bool
          : (json['is_verified']?.toString().toLowerCase() == 'true'),
      firebaseUid: json['firebase_uid']?.toString() ?? json['firebaseUid']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
      'is_verified': isVerified,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
    };
  }
}
