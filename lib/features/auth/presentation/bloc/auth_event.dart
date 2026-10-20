abstract class AuthEvent {}

// ─── Sign Up Events ──────────────────────────────────────────────────────────

class SignUpFormChanged extends AuthEvent {
  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final bool termsCondition;

  SignUpFormChanged({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.termsCondition,
  });
}

class PasswordVisibilityCheck extends AuthEvent {}

class ConfirmPasswordVisibilityCheck extends AuthEvent {}

class TermsAndCondition extends AuthEvent {
  final bool value;

  TermsAndCondition(this.value);
}

class Signup extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool termsCondition;

  Signup({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.termsCondition,
  });
}

// ─── Login Events ────────────────────────────────────────────────────────────

class LoginFormChanged extends AuthEvent {
  final String email;
  final String password;

  LoginFormChanged({
    required this.email,
    required this.password,
  });
}

class LoginPasswordVisibilityCheck extends AuthEvent {}

class Login extends AuthEvent {
  final String email;
  final String password;
  final String? deviceId;

  Login({
    required this.email,
    required this.password,
    this.deviceId,
  });
}

class GuestLogin extends AuthEvent {
  final String? deviceId;

  GuestLogin({this.deviceId});
}

// ─── OTP Verification Events ─────────────────────────────────────────────────

class OtpCodeChanged extends AuthEvent {
  final String code;

  OtpCodeChanged(this.code);
}

class OtpResendStarted extends AuthEvent {}

class OtpResendTicked extends AuthEvent {
  final int secondsRemaining;

  OtpResendTicked(this.secondsRemaining);
}

class OtpLockoutStarted extends AuthEvent {}

class OtpLockoutTicked extends AuthEvent {
  final int secondsRemaining;

  OtpLockoutTicked(this.secondsRemaining);
}

class OtpLockoutExpired extends AuthEvent {}

class VerifyOtp extends AuthEvent {
  final String email;
  final String otp;
  final String? deviceId;

  VerifyOtp({
    required this.email,
    required this.otp,
    this.deviceId,
  });
}

// ─── Other Events ────────────────────────────────────────────────────────────

class ForgotPass extends AuthEvent {
  final String email;

  ForgotPass({required this.email});
}

class Logout extends AuthEvent {}

class AuthStatusReset extends AuthEvent {}
