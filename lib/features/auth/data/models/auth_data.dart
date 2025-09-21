import 'package:equatable/equatable.dart';
import 'package:flutter_sdui_app/features/auth/data/models/user.dart';

/// This class represents a user auth details.
class AuthData extends Equatable {
  const AuthData({required this.token, required this.user});

  final String token;
  final User user;

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
    token: json['token'] as String,
    user: User.fromJson(json['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {'token': token, 'user': user.toJson()};

  /// Creates a copy of this auth with the given fields replaced with new values.
  AuthData copyWith({String? token, User? user}) {
    return AuthData(token: token ?? this.token, user: user ?? this.user);
  }

  @override
  List<Object?> get props => [token];
}
