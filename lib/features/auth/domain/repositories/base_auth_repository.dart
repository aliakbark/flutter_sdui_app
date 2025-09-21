import 'package:flutter_sdui_app/features/auth/data/models/user.dart';
import 'package:flutter_sdui_app/features/auth/data/models/auth_data.dart';

/// Base class for the authentication repositories.
abstract class BaseAuthRepository {
  /// Checks if the user is authenticated.
  bool isAuthenticated();

  /// Logs in the user with the given phone number.
  Future<void> login(String phone);

  /// Logs out the current user.
  Future<void> logout();

  /// Retrieves the current user's data.
  User? getCurrentUser();

  /// Retrieves the current account (user + token).
  AuthData? getCurrentAccount();

  /// Save auth data
  Future<void> saveAuthData({required String token, required User user});

  /// Retrieves the token
  String? getToken();
}
