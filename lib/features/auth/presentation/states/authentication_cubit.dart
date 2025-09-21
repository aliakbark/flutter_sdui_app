import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdui_app/features/auth/data/models/auth_data.dart';
import 'package:flutter_sdui_app/features/auth/data/models/user.dart';
import 'package:flutter_sdui_app/features/auth/domain/repositories/base_auth_repository.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final BaseAuthRepository _authRepository;

  AuthenticationCubit(this._authRepository)
    : super(const AuthenticationLoading());

  /// Check authentication status on app startup
  Future<void> checkAuthStatus() async {
    emit(const AuthenticationLoading());

    try {
      if (_authRepository.isAuthenticated()) {
        final account = _authRepository.getCurrentAccount();

        if (account != null) {
          emit(Authenticated(user: account.user));
        } else {
          // Invalid stored data, logout
          await _authRepository.logout();
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(
        Unauthenticated(
          message: 'Failed to check authentication status: ${e.toString()}',
          errorCode: 'AUTH_CHECK_ERROR',
        ),
      );
    }
  }

  /// Login user (called after successful OTP verification)
  Future<void> login(String phone) async {
    emit(const AuthenticationLoading());

    try {
      await _authRepository.login(phone);

      final account = _authRepository.getCurrentAccount();

      if (account != null) {
        emit(Authenticated(user: account.user));
      } else {
        // Login succeeded but couldn't retrieve account data
        emit(
          const Unauthenticated(
            message: 'Login succeeded but failed to retrieve user data',
            errorCode: 'USER_DATA_ERROR',
          ),
        );
      }
    } catch (e) {
      emit(
        Unauthenticated(
          message: 'Login failed: ${e.toString()}',
          errorCode: 'LOGIN_ERROR',
        ),
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(const Unauthenticated());
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  /// Get current user data (only if authenticated)
  User? getCurrentUser() {
    return _authRepository.getCurrentUser();
  }

  /// Get current auth data (only if authenticated)
  AuthData? getCurrentAccount() {
    return _authRepository.getCurrentAccount();
  }

  /// Check if user is currently authenticated
  bool get isAuthenticated => state is Authenticated;

  /// Retry authentication check (useful for error recovery)
  Future<void> retryAuthCheck() async {
    await checkAuthStatus();
  }

  /// Clear error state and go to unauthenticated
  void clearError() {
    emit(const Unauthenticated());
  }
}
