import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? id;
  final String email;
  final String role;
  final String documentType;
  final String documentNumber;

  const UserModel({
    this.id,
    required this.email,
    required this.role,
    required this.documentType,
    required this.documentNumber,
  });

  @override
  List<Object?> get props => [id, email, role, documentType, documentNumber];
}