import 'package:equatable/equatable.dart';

/// User model representing a user.
class User extends Equatable {
  /// Creates a [User].
  const User({required this.userId, required this.phone, this.fullName});

  /// The unique identifier of the user.
  final String userId;

  /// The phone number of the user.
  final String phone;

  /// The full name of the user.
  final String? fullName;

  /// Creates a [User] from a JSON object.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'] as String,
      phone: json['phone'] as String,
      fullName: json['fullName'] as String?,
    );
  }

  /// Converts the [User] to a JSON object.
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'phone': phone, 'fullName': fullName};
  }

  /// Creates a copy of this user with the given fields replaced with new values.
  User copyWith({String? userId, String? phone, String? fullName}) {
    return User(
      userId: userId ?? this.userId,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
    );
  }

  @override
  List<Object?> get props => [userId, phone, fullName];
}
