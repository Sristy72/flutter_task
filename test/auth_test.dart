import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task/features/auth/data/models/requests/guest_login_request_model.dart';
import 'package:flutter_task/features/auth/data/models/requests/login_request_model.dart';
import 'package:flutter_task/features/auth/data/models/response/guest_login_response_model.dart';
import 'package:flutter_task/features/auth/data/models/response/login_response_model.dart';

void main() {
  group('Auth Models Tests', () {
    test('LoginRequestModel converts to JSON properly', () {
      final model = LoginRequestModel(
        email: 'user@example.com',
        password: 'password123',
        deviceId: 'device-abc',
      );

      final json = model.toJson();
      expect(json['email'], 'user@example.com');
      expect(json['password'], 'password123');
      expect(json['device_id'], 'device-abc');
    });

    test('GuestLoginRequestModel converts to JSON properly', () {
      final model = GuestLoginRequestModel(deviceId: 'guest-uuid-123');
      final json = model.toJson();
      expect(json['device_id'], 'guest-uuid-123');
    });

    test('LoginResponseModel parses wrapped data correctly', () {
      final raw = {
        'status': 'Success',
        'code': 200,
        'data': {
          'detail': 'Login successful',
          'access': 'token_access_123',
          'refresh': 'token_refresh_456',
          'user': {
            'id': 42,
            'email': 'user@example.com',
            'full_name': 'Test User',
            'is_verified': true,
          },
        },
      };

      final response = LoginResponseModel.fromJson(raw);
      expect(response.access, 'token_access_123');
      expect(response.refresh, 'token_refresh_456');
      expect(response.user?.id, 42);
      expect(response.user?.fullName, 'Test User');
      expect(response.user?.email, 'user@example.com');
    });

    test('GuestLoginResponseModel parses correctly', () {
      final raw = {
        'detail': 'Guest session started',
        'access': 'guest_access_token',
        'refresh': 'guest_refresh_token',
        'user': {
          'id': 101,
          'full_name': 'Guest User',
          'is_verified': false,
        },
      };

      final response = GuestLoginResponseModel.fromJson(raw);
      expect(response.access, 'guest_access_token');
      expect(response.refresh, 'guest_refresh_token');
      expect(response.user?.id, 101);
      expect(response.user?.fullName, 'Guest User');
    });
  });
}
