class GoogleSignUpResponseModel {
  final String detail;
  final String access;
  final String refresh;
  final LoginUserModel user;

  GoogleSignUpResponseModel({
    required this.detail,
    required this.access,
    required this.refresh,
    required this.user,
  });

  factory GoogleSignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return GoogleSignUpResponseModel(
      detail: json['detail'] ?? '',
      access: json['access'] ?? '',
      refresh: json['refresh'] ?? '',
      user: LoginUserModel.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail': detail,
      'access': access,
      'refresh': refresh,
      'user': user.toJson(),
    };
  }
}

class LoginUserModel {
  final int id;
  final String email;
  final String fullName;
  final String? mobile;
  final bool isVerified;
  final String firebaseUid;
  final bool isNew;

  LoginUserModel({
    required this.id,
    required this.email,
    required this.fullName,
    this.mobile,
    required this.isVerified,
    required this.firebaseUid,
    required this.isNew,
  });

  factory LoginUserModel.fromJson(Map<String, dynamic> json) {
    return LoginUserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? '',
      mobile: json['mobile'],
      isVerified: json['is_verified'] ?? false,
      firebaseUid: json['firebase_uid'] ?? '',
      isNew: json['is_new'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'mobile': mobile,
      'is_verified': isVerified,
      'firebase_uid': firebaseUid,
      'is_new': isNew,
    };
  }
}