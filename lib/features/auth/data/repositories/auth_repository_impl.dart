import 'package:flutter_sdui_app/features/auth/data/datasources/base_auth_datasource.dart';
import 'package:flutter_sdui_app/features/auth/domain/repositories/base_auth_repository.dart';
import 'package:flutter_sdui_app/features/auth/data/models/user.dart';
import 'package:flutter_sdui_app/features/auth/data/models/auth_data.dart';

class AuthRepositoryImpl implements BaseAuthRepository {
  final BaseAuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  bool isAuthenticated() {
    return _authDataSource.isAuthenticated();
  }

  @override
  Future<void> login(String phone) async {
    // In a real app, you would get these from the API response
    // For now, we'll generate mock values
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    final userId = 'user_${phone.replaceAll(RegExp(r'[^\d]'), '')}';

    await _authDataSource.saveAuthData(
      authData: AuthData(
        token: token,
        user: User(userId: userId, phone: phone, fullName: null),
      ),
    );
  }

  @override
  Future<void> logout() async {
    await _authDataSource.clearAuthData();
  }

  @override
  User? getCurrentUser() {
    final User? userData = _authDataSource.getUserData();

    if (userData != null) {
      return userData;
    }
    return null;
  }

  @override
  AuthData? getCurrentAccount() {
    final AuthData? currentAccount = _authDataSource.getAuthData();

    if (currentAccount != null) {
      return currentAccount;
    }
    return null;
  }

  @override
  Future<void> saveAuthData({required String token, required User user}) async {
    await _authDataSource.saveAuthData(
      authData: AuthData(token: token, user: user),
    );
  }

  @override
  String? getToken() {
    return _authDataSource.getToken();
  }
}
