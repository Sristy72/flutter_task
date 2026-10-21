import 'package:get_it/get_it.dart';

import '../../features/auth/data/repository/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/data/repositories/home_repository.dart';
import '../../features/home/presentation/home_bloc/home_bloc.dart';
import '../network/api_client.dart';
import '../network/service/auth_storage_service.dart';
import '../network/service/hive_storage_service.dart';
import '../network/service/secure_storage_service.dart';

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

  getIt.registerLazySingleton<HiveStorageService>(
    () => HiveStorageService(),
  );

  // Network (depends on AuthStorageService for Bearer token injection)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      authStorageService: getIt<AuthStorageService>(),
    ),
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
    ),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(
      homeRepository: getIt<HomeRepository>(),
    ),
  );
}