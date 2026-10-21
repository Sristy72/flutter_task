import '../../data/models/responses/prayer_dashboard_response_model.dart';

enum HomeStatus {
  initial,
  loading,
  savingLocation, // getting GPS + posting to backend
  loaded,
  failure,
  locationPermissionDenied,
}

class HomeState {
  final HomeStatus status;
  final PrayerResponseModel? data;
  final String? errorMsg;

  const HomeState({
    this.status = HomeStatus.initial,
    this.data,
    this.errorMsg,
  });

  HomeState copyWith({
    HomeStatus? status,
    PrayerResponseModel? data,
    String? errorMsg,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMsg: errorMsg,
    );
  }
}