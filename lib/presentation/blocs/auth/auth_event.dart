import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthRegister extends AuthEvent {
  final String email;
  final String password;
  final String role;
  final String documentType;
  final String documentNumber;

  const AuthRegister({
    required this.email,
    required this.password,
    required this.role,
    required this.documentType,
    required this.documentNumber,
  });

  @override
  List<Object> get props => [email, password, role, documentType, documentNumber];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLogout extends AuthEvent {}