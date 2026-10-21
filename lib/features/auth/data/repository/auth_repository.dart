import 'dart:convert';
import 'package:flutter_task/features/auth/data/models/requests/guest_login_request_model.dart';
import 'package:flutter_task/features/auth/data/models/response/guest_login_response_model.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constant.dart';
import '../../../../core/network/service/auth_storage_service.dart';
import '../models/requests/google_signin_request_model.dart';
import '../models/requests/login_request_model.dart';
import '../models/requests/signup_request_model.dart';
import '../models/requests/verify_otp_request_model.dart';
import '../models/response/login_response_model.dart';
import '../models/response/sign_up_response_model.dart';
import '../models/response/verify_otp_response_model.dart';

class AuthRepository {
  final ApiClient apiClient;
  final AuthStorageService authStorageService;

  AuthRepository({required this.apiClient, required this.authStorageService});

  Map<String, dynamic> _toJsonMap(dynamic rawData) {
    if (rawData is Map<String, dynamic>) {
      return rawData;
    } else if (rawData is Map) {
      return Map<String, dynamic>.from(rawData);
    } else if (rawData is String && rawData.isNotEmpty) {
      try {
        return Map<String, dynamic>.from(jsonDecode(rawData) as Map);
      } catch (_) {
        return <String, dynamic>{};
      }
    }
    return <String, dynamic>{};
  }

  Future<SignupResponseModel> signUp(SignupRequestModel register) async {
    final response = await apiClient.post(
      ApiConstants.register,
      data: register.toJson(),
    );

    final jsonMap = _toJsonMap(response.data);
    final registerResponse = SignupResponseModel.fromJson(jsonMap);

    if (registerResponse.user != null) {
      await authStorageService.saveUserId(registerResponse.user!.id.toString());
      if (registerResponse.user!.fullName.isNotEmpty) {
        await authStorageService.saveUserName(registerResponse.user!.fullName);
      }
      if (registerResponse.user!.email.isNotEmpty) {
        await authStorageService.saveUserEmail(registerResponse.user!.email);
      }
    } else {
      if (register.fullName != null && register.fullName!.isNotEmpty) {
        await authStorageService.saveUserName(register.fullName!);
      }
      await authStorageService.saveUserEmail(register.email);
    }
    await authStorageService.saveIsGuest(false);

    return registerResponse;
  }

  Future<VerifyOtpResponseModel> verifyOTP(VerifyOtpRequestModel request) async {
    final response = await apiClient.post(
      ApiConstants.verifyOtp,
      data: request.toJson(),
    );

    final jsonMap = _toJsonMap(response.data);
    final verifyResponse = VerifyOtpResponseModel.fromJson(jsonMap);

    if (verifyResponse.access.isNotEmpty) {
      await authStorageService.saveAccessToken(verifyResponse.access);
    }
    if (verifyResponse.refresh.isNotEmpty) {
      await authStorageService.saveRefreshToken(verifyResponse.refresh);
    }
    if (verifyResponse.user != null) {
      await authStorageService.saveUserId(verifyResponse.user!.id.toString());
      if (verifyResponse.user!.fullName.isNotEmpty) {
        await authStorageService.saveUserName(verifyResponse.user!.fullName);
      }
      if (verifyResponse.user!.email.isNotEmpty) {
        await authStorageService.saveUserEmail(verifyResponse.user!.email);
      }
    }
    await authStorageService.saveIsGuest(false);

    return verifyResponse;
  }

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await apiClient.post(ApiConstants.login, data: request.toJson());

    final jsonMap = _toJsonMap(response.data);
    final loginResponse = LoginResponseModel.fromJson(jsonMap);

    if (loginResponse.access.isNotEmpty) {
      await authStorageService.saveAccessToken(loginResponse.access);
    }
    if (loginResponse.refresh.isNotEmpty) {
      await authStorageService.saveRefreshToken(loginResponse.refresh);
    }
    if (loginResponse.user != null) {
      await authStorageService.saveUserId(loginResponse.user!.id.toString());
      if (loginResponse.user!.fullName.isNotEmpty) {
        await authStorageService.saveUserName(loginResponse.user!.fullName);
      }
      if (loginResponse.user!.email.isNotEmpty) {
        await authStorageService.saveUserEmail(loginResponse.user!.email);
      }
    }
    await authStorageService.saveIsGuest(false);

    return loginResponse;
  }

  Future<GuestLoginResponseModel> guestLogin(GuestLoginRequestModel request) async {
    final response = await apiClient.post(ApiConstants.guestLogin, data: request.toJson());

    final jsonMap = _toJsonMap(response.data);
    final guestResponse = GuestLoginResponseModel.fromJson(jsonMap);

    if (guestResponse.access.isNotEmpty) {
      await authStorageService.saveAccessToken(guestResponse.access);
    }
    if (guestResponse.refresh.isNotEmpty) {
      await authStorageService.saveRefreshToken(guestResponse.refresh);
    }
    if (guestResponse.user != null) {
      await authStorageService.saveUserId(guestResponse.user!.id.toString());
      if (guestResponse.user!.fullName.isNotEmpty) {
        await authStorageService.saveUserName(guestResponse.user!.fullName);
      }
      if (guestResponse.user!.email != null && guestResponse.user!.email!.isNotEmpty) {
        await authStorageService.saveUserEmail(guestResponse.user!.email!);
      }
    }
    await authStorageService.saveIsGuest(true);

    return guestResponse;
  }

  Future<LoginResponseModel> socialSignIn(FirebaseSignInRequestModel request) async {
    final response = await apiClient.post(
      ApiConstants.socialSignIn,
      data: request.toJson(),
    );

    final jsonMap = _toJsonMap(response.data);
    final loginResponse = LoginResponseModel.fromJson(jsonMap);

    if (loginResponse.access.isNotEmpty) {
      await authStorageService.saveAccessToken(loginResponse.access);
    }
    if (loginResponse.refresh.isNotEmpty) {
      await authStorageService.saveRefreshToken(loginResponse.refresh);
    }
    if (loginResponse.user != null) {
      await authStorageService.saveUserId(loginResponse.user!.id.toString());
      if (loginResponse.user!.fullName.isNotEmpty) {
        await authStorageService.saveUserName(loginResponse.user!.fullName);
      }
      if (loginResponse.user!.email.isNotEmpty) {
        await authStorageService.saveUserEmail(loginResponse.user!.email);
      }
    }
    await authStorageService.saveIsGuest(false);

    return loginResponse;
  }

  Future<LoginResponseModel> socialSignUp(FirebaseSignInRequestModel request) async {
    final response = await apiClient.post(
      ApiConstants.socialSignUp,
      data: request.toJson(),
    );

    final jsonMap = _toJsonMap(response.data);
    final loginResponse = LoginResponseModel.fromJson(jsonMap);

    if (loginResponse.access.isNotEmpty) {
      await authStorageService.saveAccessToken(loginResponse.access);
    }
    if (loginResponse.refresh.isNotEmpty) {
      await authStorageService.saveRefreshToken(loginResponse.refresh);
    }
    if (loginResponse.user != null) {
      await authStorageService.saveUserId(loginResponse.user!.id.toString());
      if (loginResponse.user!.fullName.isNotEmpty) {
        await authStorageService.saveUserName(loginResponse.user!.fullName);
      }
      if (loginResponse.user!.email.isNotEmpty) {
        await authStorageService.saveUserEmail(loginResponse.user!.email);
      }
    }
    await authStorageService.saveIsGuest(false);

    return loginResponse;
  }
}