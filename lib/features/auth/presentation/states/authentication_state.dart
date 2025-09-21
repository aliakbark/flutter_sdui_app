part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

class Authenticated extends AuthenticationState {
  final User user;

  const Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthenticationState {
  final String? message;
  final String? errorCode;

  const Unauthenticated({this.message, this.errorCode});
}
