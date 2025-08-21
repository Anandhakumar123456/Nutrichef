part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class Authenticated extends AuthState {
  final String userId;

  Authenticated({required this.userId});
}

final class UnAuthenticated extends AuthState {}

final class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});
  @override
  List<Object> get props => [error];
}

final class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess({required this.message});
  @override
  List<Object> get props => [message];
}
