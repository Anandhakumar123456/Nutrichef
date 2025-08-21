part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;

  SignUpRequested(this.username, {required this.email, required this.password});
  @override
  List<Object> get props => [email, password, username];
}

class LogoutRequested extends AuthEvent {
  LogoutRequested();
  @override
  List<Object> get props => [];
}
