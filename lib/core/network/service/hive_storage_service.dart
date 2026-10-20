import 'package:hive_flutter/hive_flutter.dart';

class HiveStorageService {
  Future<void> init() async {
    await Hive.initFlutter();
  }

  Future<void> openBox(String name) async {
    await Hive.openBox(name);
  }

  Future<void> write(
      String boxName,
      String key,
      dynamic value,
      ) async {
    final box = Hive.box(boxName);

    await box.put(key, value);
  }

  T? read<T>(
      String boxName,
      String key,
      ) {
    final box = Hive.box(boxName);

    return box.get(key) as T?;
  }

  Future<void> delete(
      String boxName,
      String key,
      ) async {
    final box = Hive.box(boxName);

    await box.delete(key);
  }

  Future<void> clear(String boxName) async {
    final box = Hive.box(boxName);

    await box.clear();
  }
}