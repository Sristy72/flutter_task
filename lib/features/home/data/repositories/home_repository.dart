import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/constants/api_constant.dart';
import '../models/requests/save_location_request_model.dart';
import '../models/responses/location_response_model.dart';
import '../models/responses/prayer_dashboard_response_model.dart';

class HomeRepository {
  final ApiClient apiClient;

  HomeRepository({required this.apiClient});

  /// Fetches the prayer dashboard.
  /// Throws [LocationRequiredException] if the server requires location setup.
  Future<PrayerResponseModel> getDashboard() async {
    final response = await apiClient.get(ApiConstants.dashboard);

    // The API wraps responses as: { status, code, data: { ... } }
    final body = response.data as Map<String, dynamic>;
    final inner = body['data'];

    if (inner is! Map<String, dynamic>) {
      throw ApiException(
        message: 'Unexpected response format from server.',
        statusCode: response.statusCode,
      );
    }

    // Server returns HTTP 200 but signals that location must be saved first
    final serverStatus = inner['status'] as String?;
    if (serverStatus == 'UPDATE_LOCATION_REQUIRED') {
      throw LocationRequiredException(
        inner['message'] as String? ?? 'Please save your location first.',
      );
    }

    return PrayerResponseModel.fromJson(inner);
  }

  /// Sends the device's GPS coordinates to the backend to save the user location.
  Future<void> saveLocation(SaveLocationRequestModel request) async {
    dynamic response;
    try {
      response = await apiClient.patch(
        ApiConstants.updateLocation,
        data: request.toJson(),
      );
    } on ApiException catch (e) {
      if (e.statusCode == 405) {
        response = await apiClient.post(
          ApiConstants.updateLocation,
          data: request.toJson(),
        );
      } else {
        rethrow;
      }
    }

    if (response.data is Map<String, dynamic>) {
      final body = response.data as Map<String, dynamic>;
      final inner = body['data'];

      if (inner is Map<String, dynamic>) {
        final serverStatus = inner['status'] as String?;
        if (serverStatus != null &&
            serverStatus != 'Success' &&
            serverStatus != 'success') {
          throw ApiException(
            message: inner['message'] as String? ?? 'Failed to save location.',
            statusCode: response.statusCode,
          );
        }
      }
    }
  }

  /// Gets the current saved location from the backend.
  Future<LocationResponseModel> getLocation() async {
    final response = await apiClient.get(ApiConstants.getCurrentLocation);
    final body = response.data as Map<String, dynamic>;
    final inner = body['data'] ?? body;
    return LocationResponseModel.fromJson(inner as Map<String, dynamic>);
  }
}

/// Thrown when the server requires the user to set their location first.
class LocationRequiredException implements Exception {
  final String message;
  const LocationRequiredException(this.message);
}