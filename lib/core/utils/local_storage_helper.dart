import 'package:interpreter_app/core/utils/session_storage.dart';

class LocalStorageHelper {
  LocalStorageHelper({SessionStorage? sessionStorage})
      : _sessionStorage = sessionStorage ?? SessionStorage();

  final SessionStorage _sessionStorage;

  Future<String> getToken() {
    return _sessionStorage.getToken();
  }

  Future<String> getUserRole() {
    return _sessionStorage.getUserRole();
  }

  Future<void> clearAll() {
    return _sessionStorage.clearSession();
  }
}
