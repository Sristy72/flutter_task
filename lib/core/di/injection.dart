import 'package:flutter_task/features/home/data/repositories/home_repository.dart';
import 'package:flutter_task/features/home/presentation/home_bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_task/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_task/features/auth/data/services/google_auth_service.dart';
import 'package:flutter_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_task/core/network/api_client.dart';
import 'package:flutter_task/core/network/service/auth_storage_service.dart';
import 'package:flutter_task/core/network/service/secure_storage_service.dart';
import 'package:flutter_task/core/notification/notification_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Storage (must be registered before ApiClient)
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<AuthStorageService>(
    () => AuthStorageService(
      getIt<SecureStorageService>(),
    ),
  );

  // Network
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      authStorageService: getIt<AuthStorageService>(),
    ),
  );

  // Services
  getIt.registerLazySingleton<GoogleAuthService>(
    () => GoogleAuthService(),
  );
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService.instance,
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiClient: getIt<ApiClient>(),
      authStorageService: getIt<AuthStorageService>(),
    ),
  );
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepository(
      apiClient: getIt<ApiClient>(),
    ),
  );

  // Blocs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      googleAuthService: getIt<GoogleAuthService>(),
    ),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(homeRepository: getIt<HomeRepository>()
    ),
  );
}