import '../../data/models/response/sign_up_response_model.dart';
import '../../data/models/response/verify_otp_response_model.dart';

enum AuthStatus {
  initial,
  loading,
  signupSuccess,
  authenticated,
  unauthenticated,
  failure,
  forgotPasswordSuccess,
  otpVerificationSuccess,
  otpVerificationFailure,
}

class AuthState {
  final AuthStatus status;

  // Sign Up form state
  final bool isSignUpFormValid;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isTermsAndConditions;

  // Login form state
  final bool isLoginFormValid;
  final bool isLoginPasswordVisible;
  final bool isRememberMe;

  // Verify OTP state
  final bool isOtpCodeComplete;
  final String otpCode;
  final int otpRemainingAttempts;
  final bool otpHasError;
  final String otpErrorMessage;
  final bool isOtpLockedOut;
  final int otpLockoutCountdown;
  final int otpResendCountdown;

  // Models & messages
  final SignupUserModel? user;
  final VerifyOtpResponseModel? verifyOtpResponse;
  final String? errorMsg;
  final String? successMsg;
  final String? otp;

  AuthState({
    this.status = AuthStatus.initial,
    this.isSignUpFormValid = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isTermsAndConditions = false,
    this.isLoginFormValid = false,
    this.isLoginPasswordVisible = false,
    this.isRememberMe = false,
    this.isOtpCodeComplete = false,
    this.otpCode = '',
    this.otpRemainingAttempts = 4,
    this.otpHasError = false,
    this.otpErrorMessage = '',
    this.isOtpLockedOut = false,
    this.otpLockoutCountdown = 0,
    this.otpResendCountdown = 0,
    this.errorMsg,
    this.successMsg,
    this.user,
    this.verifyOtpResponse,
    this.otp,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isSignUpFormValid,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isTermsAndConditions,
    bool? isLoginFormValid,
    bool? isLoginPasswordVisible,
    bool? isRememberMe,
    bool? isOtpCodeComplete,
    String? otpCode,
    int? otpRemainingAttempts,
    bool? otpHasError,
    String? otpErrorMessage,
    bool? isOtpLockedOut,
    int? otpLockoutCountdown,
    int? otpResendCountdown,
    SignupUserModel? user,
    VerifyOtpResponseModel? verifyOtpResponse,
    String? errorMsg,
    String? successMsg,
    String? otp,
  }) {
    return AuthState(
      status: status ?? this.status,
      isSignUpFormValid: isSignUpFormValid ?? this.isSignUpFormValid,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isTermsAndConditions: isTermsAndConditions ?? this.isTermsAndConditions,
      isLoginFormValid: isLoginFormValid ?? this.isLoginFormValid,
      isLoginPasswordVisible:
          isLoginPasswordVisible ?? this.isLoginPasswordVisible,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      isOtpCodeComplete: isOtpCodeComplete ?? this.isOtpCodeComplete,
      otpCode: otpCode ?? this.otpCode,
      otpRemainingAttempts: otpRemainingAttempts ?? this.otpRemainingAttempts,
      otpHasError: otpHasError ?? this.otpHasError,
      otpErrorMessage: otpErrorMessage ?? this.otpErrorMessage,
      isOtpLockedOut: isOtpLockedOut ?? this.isOtpLockedOut,
      otpLockoutCountdown: otpLockoutCountdown ?? this.otpLockoutCountdown,
      otpResendCountdown: otpResendCountdown ?? this.otpResendCountdown,
      user: user ?? this.user,
      verifyOtpResponse: verifyOtpResponse ?? this.verifyOtpResponse,
      errorMsg: errorMsg,
      successMsg: successMsg,
      otp: otp ?? this.otp,
    );
  }
}