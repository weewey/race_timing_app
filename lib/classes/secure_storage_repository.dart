import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {
  final _store = FlutterSecureStorage();

  Future<void> set(String key, String value) async {
    await _store.write(key: key, value: value);
  }

  Future<String> get(String key, String value) async {
    return await _store.read(key: key);
  }

  Future<void> delete(String key) async {
    return await _store.delete(key: key);
  }
}