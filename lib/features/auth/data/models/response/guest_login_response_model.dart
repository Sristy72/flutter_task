class GuestLoginResponseModel {
  final String detail;
  final String access;
  final String refresh;
  final GuestUserModel? user;

  GuestLoginResponseModel({
    required this.detail,
    required this.access,
    required this.refresh,
    this.user,
  });

  factory GuestLoginResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : json);

    return GuestLoginResponseModel(
      detail: payload['detail']?.toString() ??
          json['detail']?.toString() ??
          json['message']?.toString() ??
          '',
      access: payload['access']?.toString() ??
          json['access']?.toString() ??
          payload['access_token']?.toString() ??
          '',
      refresh: payload['refresh']?.toString() ??
          json['refresh']?.toString() ??
          payload['refresh_token']?.toString() ??
          '',
      user: payload['user'] != null && payload['user'] is Map
          ? GuestUserModel.fromJson(Map<String, dynamic>.from(payload['user'] as Map))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'access': access,
      'refresh': refresh,
      if (user != null) 'user': user!.toJson(),
    };
  }
}

class GuestUserModel {
  final int id;
  final String? email;
  final String fullName;
  final String? mobile;
  final bool isVerified;
  final String? firebaseUid;

  GuestUserModel({
    required this.id,
    this.email,
    required this.fullName,
    this.mobile,
    required this.isVerified,
    this.firebaseUid,
  });

  factory GuestUserModel.fromJson(Map<String, dynamic> json) {
    return GuestUserModel(
      id: json['id'] is int
          ? json['id'] as int
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      email: json['email']?.toString(),
      fullName: json['full_name']?.toString() ?? json['fullName']?.toString() ?? 'Guest',
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
      if (email != null) 'email': email,
      'full_name': fullName,
      if (mobile != null) 'mobile': mobile,
      'is_verified': isVerified,
      if (firebaseUid != null) 'firebase_uid': firebaseUid,
    };
  }
}