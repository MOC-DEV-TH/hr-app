import 'package:get_storage/get_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage.g.dart';

enum SecureDataList {
  token,
  fCMToken,
  isAlreadyLogin,
  isSignedIn,
  authToken,
  baseApiUrl
}

class SecureStorage {
  ///auth flow
  saveAuthStatus(String status) async {
    await GetStorage().write(SecureDataList.isSignedIn.name, status);
  }

  Future<String?> getAuthStatus() async {
    final res = await GetStorage().read(SecureDataList.isSignedIn.name);
    return res;
  }

  ///fcm token
  saveFCMToken(String fcmToken) async {
    await GetStorage().write(SecureDataList.fCMToken.name, fcmToken);
  }

  getFCMToken() {
    return GetStorage().read(SecureDataList.fCMToken.name);
  }

  ///auth token
  saveAuthToken(String authToken) async {
    await GetStorage().write(SecureDataList.authToken.name, authToken);
  }

  getAuthToken() {
    return GetStorage().read(SecureDataList.authToken.name);
  }
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(SecureStorageRef ref) {
  return SecureStorage();
}

@riverpod
Future<String?> getAuthStatus(GetAuthStatusRef ref) {
  final provider = ref.watch(secureStorageProvider);
  return provider.getAuthStatus();
}