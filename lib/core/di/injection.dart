import 'package:get_it/get_it.dart';

import 'package:flutter_task/features/auth/data/repository/auth_repository.dart';
import 'package:flutter_task/features/auth/data/services/google_auth_service.dart';
import 'package:flutter_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_task/core/network/api_client.dart';
import 'package:flutter_task/core/network/service/auth_storage_service.dart';
import 'package:flutter_task/core/network/service/hive_storage_service.dart';
import 'package:flutter_task/core/network/service/secure_storage_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Network
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(),
  );

  // Storage
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageService(),
  );

  getIt.registerLazySingleton<AuthStorageService>(
    () => AuthStorageService(
      getIt<SecureStorageService>(),
    ),
  );

  getIt.registerLazySingleton<HiveStorageService>(
    () => HiveStorageService(),
  );

  // Services
  getIt.registerLazySingleton<GoogleAuthService>(
    () => GoogleAuthService(),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      apiClient: getIt<ApiClient>(),
      authStorageService: getIt<AuthStorageService>(),
    ),
  );

  // Blocs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      authRepository: getIt<AuthRepository>(),
      googleAuthService: getIt<GoogleAuthService>(),
    ),
  );
}