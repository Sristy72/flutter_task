import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage storage;

  static const _androidOptions = AndroidOptions(
    resetOnError: true,
  );

  SecureStorageService({
    FlutterSecureStorage? storage,
  }) : storage = storage ?? const FlutterSecureStorage(aOptions: _androidOptions);

  Future<void> write(
      String key,
      String value,
      ) async {
    await storage.write(
      key: key,
      value: value,
    );
  }

  Future<String?> read(String key) async {
    return storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await storage.delete(key: key);
  }

  Future<void> clear() async {
    await storage.deleteAll();
  }
}