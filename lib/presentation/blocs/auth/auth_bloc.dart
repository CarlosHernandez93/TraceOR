import 'package:flutter_bloc/flutter_bloc.dart';
import './auth_event.dart';
import './auth_state.dart';
import 'package:trace_or/config/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthRegister>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.register(
          email: event.email,
          password: event.password,
          role: event.role,
          documentType: event.documentType,
          documentNumber: event.documentNumber,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogin>((event, emit) async {
      emit(AuthLoading());
      try {
        print("dd");
        final user = await authRepository.login(
          email: event.email,
          password: event.password,
        );
        emit(AuthAuthenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logout();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}