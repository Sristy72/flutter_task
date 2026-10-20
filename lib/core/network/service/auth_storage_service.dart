import 'dart:convert';
import '../constants/storage_constants.dart';
import 'secure_storage_service.dart';

class AuthStorageService {
  final SecureStorageService secureStorage;

  AuthStorageService(this.secureStorage);

  Future<void> saveAccessToken(String token) async {
    await secureStorage.write(
      StorageConstants.accessToken,
      token,
    );
  }

  Future<String?> getAccessToken() async {
    return secureStorage.read(
      StorageConstants.accessToken,
    );
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await secureStorage.write(
      StorageConstants.refreshToken,
      token,
    );
  }

  Future<String?> getRefreshToken() async {
    return secureStorage.read(
      StorageConstants.refreshToken,
    );
  }

  Future<void> saveUserId(String userId) async {
    await secureStorage.write(
      'user_id',
      userId,
    );
  }

  Future<String?> getUserId() async {
    final stored = await secureStorage.read('user_id');
    if (stored != null && stored.isNotEmpty) {
      return stored;
    }

    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      final id = _extractUserIdFromToken(token);
      if (id != null && id.isNotEmpty) {
        await saveUserId(id);
        return id;
      }
    }
    return null;
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded);
      if (map is Map) {
        return map['id']?.toString() ??
            map['_id']?.toString() ??
            map['userId']?.toString() ??
            map['sub']?.toString();
      }
    } catch (_) {}
    return null;
  }

  Future<void> clearToken() async {
    await secureStorage.delete(StorageConstants.accessToken);
    await secureStorage.delete(StorageConstants.refreshToken);
    await secureStorage.delete('user_id');
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();

    return token != null && token.isNotEmpty;
  }
}