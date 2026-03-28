import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const _tokenKey = 'auth_token';
  static const _loginTimeKey = 'login_time';
  static const _userRoleKey = 'user_role';

  Future<void> saveLoginSession({
    required String token,
    required DateTime loginTime,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_loginTimeKey, loginTime.toIso8601String());
    await prefs.setString(_userRoleKey, role);
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  Future<DateTime?> getLoginTime() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_loginTimeKey);
    if (stored == null || stored.isEmpty) return null;
    return DateTime.tryParse(stored);
  }

  Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey) ?? '';
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_loginTimeKey);
    await prefs.remove(_userRoleKey);
  }
}
