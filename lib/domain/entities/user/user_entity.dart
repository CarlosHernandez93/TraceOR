import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable{
  final String userId;
  final String email;
  final String password;

  const MyUserEntity({
    required this.userId,
    required this.email,
    required this.password,
  });

  static const empty = MyUserEntity(userId: "", email: "", password: "");

  @override
  List<Object> get props => [userId, email, password];

}