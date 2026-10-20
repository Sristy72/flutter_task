class SignupRequestModel {
  final String? fullName;
  final String email;
  final String password;
  final String confirmPassword;

  const SignupRequestModel({
    this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'full_name': fullName,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}