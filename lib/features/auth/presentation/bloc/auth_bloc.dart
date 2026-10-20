import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/requests/signup_request_model.dart';
import '../../data/models/requests/verify_otp_request_model.dart';
import '../../data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  Timer? _resendTimer;
  Timer? _lockoutTimer;

  AuthBloc({required this.authRepository}) : super(AuthState()) {
    // Sign up
    on<SignUpFormChanged>(_onSignUpFormChanged);
    on<PasswordVisibilityCheck>(_passwordVisibilityCheck);
    on<ConfirmPasswordVisibilityCheck>(_confirmPasswordVisibilityCheck);
    on<TermsAndCondition>(_termsAndCondition);
    on<Signup>(_signUp);

    // Login
    on<LoginFormChanged>(_onLoginFormChanged);
    on<LoginPasswordVisibilityCheck>(_onLoginPasswordVisibilityCheck);
    on<Login>(_login);

    // Status reset
    on<AuthStatusReset>(_onAuthStatusReset);

    // Verify OTP
    on<OtpCodeChanged>(_onOtpCodeChanged);
    on<OtpResendStarted>(_onOtpResendStarted);
    on<OtpResendTicked>(_onOtpResendTicked);
    on<OtpLockoutStarted>(_onOtpLockoutStarted);
    on<OtpLockoutTicked>(_onOtpLockoutTicked);
    on<OtpLockoutExpired>(_onOtpLockoutExpired);
    on<VerifyOtp>(_verifyOtp);
  }

  void _onAuthStatusReset(AuthStatusReset event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: AuthStatus.initial,
      errorMsg: null,
      successMsg: null,
    ));
  }

  // ─── Sign Up Handlers ───────────────────────────────────────────────────────

  void _onSignUpFormChanged(SignUpFormChanged event, Emitter<AuthState> emit) {
    final isValid = event.fullName.trim().isNotEmpty &&
        event.email.trim().isNotEmpty &&
        event.password.trim().isNotEmpty &&
        event.confirmPassword.trim().isNotEmpty &&
        event.termsCondition;

    emit(state.copyWith(
      isSignUpFormValid: isValid,
      isTermsAndConditions: event.termsCondition,
    ));
  }

  void _termsAndCondition(TermsAndCondition event, Emitter<AuthState> emit) {
    emit(state.copyWith(isTermsAndConditions: event.value));
  }

  void _passwordVisibilityCheck(
    PasswordVisibilityCheck event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _confirmPasswordVisibilityCheck(
    ConfirmPasswordVisibilityCheck event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    ));
  }

  Future<void> _signUp(Signup event, Emitter<AuthState> emit) async {
    if (!event.termsCondition) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMsg: 'Please accept the terms and conditions',
        ),
      );
      return;
    }

    if (event.password != event.confirmPassword) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMsg: 'Passwords do not match',
        ),
      );
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final register = SignupRequestModel(
        fullName: event.name.trim(),
        email: event.email.trim(),
        password: event.password,
        confirmPassword: event.confirmPassword,
      );

      final response = await authRepository.signUp(register);

      emit(
        state.copyWith(
          status: AuthStatus.signupSuccess,
          user: response.user,
          successMsg: response.detail.isNotEmpty
              ? response.detail
              : 'Account created successfully! Please verify your email.',
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMsg: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMsg: e.toString(),
        ),
      );
    }
  }

  // ─── Login Handlers ─────────────────────────────────────────────────────────

  void _onLoginFormChanged(LoginFormChanged event, Emitter<AuthState> emit) {
    final isValid = event.email.trim().isNotEmpty && event.password.trim().isNotEmpty;
    emit(state.copyWith(isLoginFormValid: isValid));
  }

  void _onLoginPasswordVisibilityCheck(
    LoginPasswordVisibilityCheck event,
    Emitter<AuthState> emit,
  ) {
    emit(state.copyWith(isLoginPasswordVisible: !state.isLoginPasswordVisible));
  }

  Future<void> _login(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    // Login API implementation if ready
  }

  // ─── OTP Handlers

  void _onOtpCodeChanged(OtpCodeChanged event, Emitter<AuthState> emit) {
    final isComplete = event.code.trim().length == 4;
    emit(state.copyWith(
      status: (state.status == AuthStatus.signupSuccess || state.status == AuthStatus.authenticated)
          ? AuthStatus.initial
          : state.status,
      otpCode: event.code,
      isOtpCodeComplete: isComplete,
    ));
  }

  void _onOtpResendStarted(OtpResendStarted event, Emitter<AuthState> emit) {
    _resendTimer?.cancel();
    emit(state.copyWith(
      otpResendCountdown: 30,
      otpHasError: false,
      otpErrorMessage: '',
      otpRemainingAttempts: 4,
    ));

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state.otpResendCountdown;
      if (current > 1) {
        add(OtpResendTicked(current - 1));
      } else {
        timer.cancel();
        add(OtpResendTicked(0));
      }
    });
  }

  void _onOtpResendTicked(OtpResendTicked event, Emitter<AuthState> emit) {
    emit(state.copyWith(otpResendCountdown: event.secondsRemaining));
  }

  void _onOtpLockoutStarted(OtpLockoutStarted event, Emitter<AuthState> emit) {
    _lockoutTimer?.cancel();
    emit(state.copyWith(
      isOtpLockedOut: true,
      otpLockoutCountdown: 30 * 60,
      otpRemainingAttempts: 0,
    ));

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = state.otpLockoutCountdown;
      if (current > 1) {
        add(OtpLockoutTicked(current - 1));
      } else {
        timer.cancel();
        add(OtpLockoutExpired());
      }
    });
  }

  void _onOtpLockoutTicked(OtpLockoutTicked event, Emitter<AuthState> emit) {
    emit(state.copyWith(otpLockoutCountdown: event.secondsRemaining));
  }

  void _onOtpLockoutExpired(OtpLockoutExpired event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      isOtpLockedOut: false,
      otpLockoutCountdown: 0,
      otpRemainingAttempts: 4,
      otpHasError: false,
      otpErrorMessage: '',
      otpCode: '',
      isOtpCodeComplete: false,
    ));
  }

  Future<void> _verifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    try {
      final request = VerifyOtpRequestModel(
        email: event.email.trim(),
        otp: event.otp.trim(),
        deviceId: event.deviceId,
      );

      final response = await authRepository.verifyOTP(request);

      emit(
        state.copyWith(
          status: AuthStatus.otpVerificationSuccess,
          verifyOtpResponse: response,
          otpHasError: false,
          successMsg: response.detail.isNotEmpty
              ? response.detail
              : 'Email verified successfully!',
        ),
      );
    } on ApiException catch (e) {
      final remaining = state.otpRemainingAttempts - 1;
      if (remaining <= 0) {
        add(OtpLockoutStarted());
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.otpVerificationFailure,
            otpRemainingAttempts: remaining,
            otpHasError: true,
            otpErrorMessage:
                'Incorrect Code : $remaining attempt${remaining == 1 ? '' : 's'} remaining.',
            errorMsg: e.message,
          ),
        );
      }
    } catch (e) {
      final remaining = state.otpRemainingAttempts - 1;
      if (remaining <= 0) {
        add(OtpLockoutStarted());
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.otpVerificationFailure,
            otpRemainingAttempts: remaining,
            otpHasError: true,
            otpErrorMessage:
                'Incorrect Code : $remaining attempt${remaining == 1 ? '' : 's'} remaining.',
            errorMsg: e.toString(),
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    _lockoutTimer?.cancel();
    return super.close();
  }
}
