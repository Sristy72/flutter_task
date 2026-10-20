class SignupResponseModel {
  final String detail;
  final SignupUserModel? user;

  const SignupResponseModel({
    required this.detail,
    this.user,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    // Backend wraps response in { "status": "Success", "code": 201, "data": { ... } }
    final payload = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : json);

    return SignupResponseModel(
      detail: payload['detail']?.toString() ??
          json['detail']?.toString() ??
          json['message']?.toString() ??
          '',
      user: payload['user'] != null && payload['user'] is Map
          ? SignupUserModel.fromJson(
              Map<String, dynamic>.from(payload['user'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

class SignupUserModel {
  final int id;
  final String email;
  final String fullName;
  final String? mobile;
  final bool isVerified;
  final String? firebaseUid;

  const SignupUserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.mobile,
    required this.isVerified,
    this.firebaseUid,
  });

  factory SignupUserModel.fromJson(Map<String, dynamic> json) {
    return SignupUserModel(
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