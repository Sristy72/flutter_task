import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/requests/save_location_request_model.dart';
import '../../data/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(const HomeState()) {
    on<FetchDashboard>(_onFetchDashboard);
    on<SaveLocationAndFetch>(_onSaveLocationAndFetch);
  }

  // ─── Fetch Dashboard ───────────────────────────────────────────────────────

  Future<void> _onFetchDashboard(
    FetchDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    try {
      final data = await homeRepository.getDashboard();
      emit(state.copyWith(status: HomeStatus.loaded, data: data));
    } on LocationRequiredException {
      // Server needs location — kick off the location save flow automatically
      if (!isClosed) {
        add(SaveLocationAndFetch());
      }
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: HomeStatus.failure, errorMsg: e.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: HomeStatus.failure, errorMsg: e.toString()));
      }
    }
  }

  // ─── Save Location then Fetch ──────────────────────────────────────────────

  Future<void> _onSaveLocationAndFetch(
    SaveLocationAndFetch event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.savingLocation));

    try {
      // 1. Check & request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(state.copyWith(
          status: HomeStatus.locationPermissionDenied,
          errorMsg: permission == LocationPermission.deniedForever
              ? 'Location permission permanently denied. Please enable it in app settings.'
              : 'Location permission denied. Please allow access to load prayer times.',
        ));
        return;
      }

      // 2. Check if location service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(state.copyWith(
          status: HomeStatus.failure,
          errorMsg: 'Location services are disabled. Please turn on GPS.',
        ));
        return;
      }

      // 3. Get current GPS position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      // 4. POST coords to backend
      await homeRepository.saveLocation(
        SaveLocationRequestModel(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

      // 5. Re-fetch dashboard now that location is saved
      final data = await homeRepository.getDashboard();
      if (!isClosed) {
        emit(state.copyWith(status: HomeStatus.loaded, data: data));
      }
    } on ApiException catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: HomeStatus.failure, errorMsg: e.message));
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(status: HomeStatus.failure, errorMsg: e.toString()));
      }
    }
  }
}
