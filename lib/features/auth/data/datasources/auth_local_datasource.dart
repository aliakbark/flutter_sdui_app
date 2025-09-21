import 'dart:convert';

import 'package:flutter_sdui_app/features/auth/data/datasources/base_auth_datasource.dart';
import 'package:flutter_sdui_app/features/auth/data/models/auth_data.dart';
import 'package:flutter_sdui_app/features/auth/data/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource implements BaseAuthDataSource {
  static const String _tokenKey = 'auth_token';
  static const String _authDataKey = 'auth_data';

  final SharedPreferences _prefs;

  AuthLocalDataSource(this._prefs);

  @override
  Future<void> saveAuthData({required AuthData authData}) async {
    await Future.wait([
      _prefs.setString(_tokenKey, authData.token),
      _prefs.setString(_authDataKey, jsonEncode(authData.toJson())),
    ]);
  }

  @override
  AuthData? getAuthData() {
    final String? authString = _prefs.getString(_authDataKey);
    if (authString != null) {
      return AuthData.fromJson(jsonDecode(authString));
    }

    return null;
  }

  @override
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  @override
  bool isAuthenticated() {
    final String? token = getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> clearAuthData() async {
    await Future.wait([_prefs.remove(_tokenKey), _prefs.remove(_authDataKey)]);
  }

  @override
  User? getUserData() {
    final AuthData? authData = getAuthData();
    if (authData != null) {
      return authData.user;
    }

    return null;
  }
}
