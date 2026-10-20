import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constant.dart';
import '../../../../core/network/service/auth_storage_service.dart';
import '../models/requests/signup_request_model.dart';
import '../models/requests/verify_otp_request_model.dart';
import '../models/response/sign_up_response_model.dart';
import '../models/response/verify_otp_response_model.dart';

class AuthRepository {
  final ApiClient apiClient;
  final AuthStorageService authStorageService;

  AuthRepository({required this.apiClient, required this.authStorageService});

  Future<SignupResponseModel> signUp(SignupRequestModel register) async {
    final response = await apiClient.post(
      ApiConstants.register,
      data: register.toJson(),
    );

    final dynamic rawData = response.data;
    final Map<String, dynamic> jsonMap;
    if (rawData is Map<String, dynamic>) {
      jsonMap = rawData;
    } else if (rawData is Map) {
      jsonMap = Map<String, dynamic>.from(rawData);
    } else if (rawData is String && rawData.isNotEmpty) {
      jsonMap = Map<String, dynamic>.from(jsonDecode(rawData) as Map);
    } else {
      jsonMap = <String, dynamic>{};
    }

    final registerResponse = SignupResponseModel.fromJson(jsonMap);

    return registerResponse;
  }

  Future<VerifyOtpResponseModel> verifyOTP(VerifyOtpRequestModel request) async {
    final response = await apiClient.post(
      ApiConstants.verifyOtp,
      data: request.toJson(),
    );

    final dynamic rawData = response.data;
    final Map<String, dynamic> jsonMap;
    if (rawData is Map<String, dynamic>) {
      jsonMap = rawData;
    } else if (rawData is Map) {
      jsonMap = Map<String, dynamic>.from(rawData);
    } else if (rawData is String && rawData.isNotEmpty) {
      jsonMap = Map<String, dynamic>.from(jsonDecode(rawData) as Map);
    } else {
      jsonMap = <String, dynamic>{};
    }

    final verifyResponse = VerifyOtpResponseModel.fromJson(jsonMap);

    if (verifyResponse.access.isNotEmpty) {
      await authStorageService.saveAccessToken(verifyResponse.access);
    }
    if (verifyResponse.refresh.isNotEmpty) {
      await authStorageService.saveRefreshToken(verifyResponse.refresh);
    }
    if (verifyResponse.user != null) {
      await authStorageService.saveUserId(verifyResponse.user!.id.toString());
    }

    return verifyResponse;
  }
}