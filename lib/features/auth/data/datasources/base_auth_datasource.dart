import 'package:flutter_sdui_app/core/shared/data/base_datasource.dart';
import 'package:flutter_sdui_app/features/auth/data/models/auth_data.dart';
import 'package:flutter_sdui_app/features/auth/data/models/user.dart';

abstract class BaseAuthDataSource extends BaseDataSource {
  /// Save authentication token and user data
  Future<void> saveAuthData({required AuthData authData});

  /// Get authentication data
  AuthData? getAuthData();

  /// Get saved authentication token
  String? getToken();

  /// Check if user is authenticated (has a valid token)
  bool isAuthenticated();

  /// Clear all authentication data (logout)
  Future<void> clearAuthData();

  /// Get all user data as a map
  User? getUserData();
}
