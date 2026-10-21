import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constant.dart';
import '../models/responses/prayer_dashboard_response_model.dart';

class HomeRepository {
  final ApiClient apiClient;


  HomeRepository({required this.apiClient});

  Future<PrayerResponseModel> getPopular() async {
    final response = await apiClient.get(ApiConstants.home);

    final getResponse = PrayerResponseModel.fromJson(response.data);

    return getResponse;
  }
}