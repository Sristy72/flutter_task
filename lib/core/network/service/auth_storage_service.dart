import 'dart:convert';
import 'dart:math';
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

  Future<void> saveUserName(String name) async {
    await secureStorage.write('user_name', name);
  }

  Future<String?> getUserName() async {
    return secureStorage.read('user_name');
  }

  Future<void> saveUserEmail(String email) async {
    await secureStorage.write('user_email', email);
  }

  Future<String?> getUserEmail() async {
    return secureStorage.read('user_email');
  }

  Future<void> saveIsGuest(bool isGuest) async {
    await secureStorage.write('is_guest', isGuest.toString());
  }

  Future<bool> isGuest() async {
    final stored = await secureStorage.read('is_guest');
    return stored == 'true';
  }

  Future<String> getOrCreateDeviceId() async {
    final existing = await secureStorage.read('device_id');
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).toList();
    final newId =
        '${hex.sublist(0, 4).join()}-${hex.sublist(4, 6).join()}-${hex.sublist(6, 8).join()}-${hex.sublist(8, 10).join()}-${hex.sublist(10, 16).join()}';

    await secureStorage.write('device_id', newId);
    return newId;
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
    await secureStorage.delete('is_guest');
    await secureStorage.delete('user_name');
    await secureStorage.delete('user_email');
  }
  bool isTokenExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final map = jsonDecode(decoded);
      if (map is Map && map.containsKey('exp')) {
        final exp = map['exp'];
        final expSeconds =
            (exp is num) ? exp.toInt() : int.tryParse(exp.toString());
        if (expSeconds != null) {
          final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          return nowSeconds >= expSeconds;
        }
      }
    } catch (_) {}
    return false;
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      if (isTokenExpired(token)) {
        await clearToken();
        return false;
      }
      return true;
    }
    return isGuest();
  }
}