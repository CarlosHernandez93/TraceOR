import 'package:flutter_bloc/flutter_bloc.dart';
import './auth_event.dart';
import './auth_state.dart';
import 'package:trace_or/config/repository/repositories.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthRegister>(register);
    on<AuthLogin>(login);
    on<AuthLogout>(logOut);
    on<AppStarted>(appStarted);
    on<AuthPasswordResetRequested>(onPasswordResetRequested);
  }


  void register (event, emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.register(
        fullName: event.fullName,
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
  }


  void login (event, emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  void logOut (event, emit) async {
    emit(AuthLoading());
    try {
      await authRepository.logout();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  void appStarted (event, emit) async {
    final user = authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthPreviousAuthenticated(user)); // Usuario autenticado
    } else {
      emit(AuthUnauthenticated()); // Usuario no autenticado
    }
  }


  void onPasswordResetRequested(event, emit) async{
    emit(AuthLoading()); // Emitimos un estado de carga mientras se envía el correo
    try {
      await authRepository.sendPasswordResetEmail(event.email);
      emit(PasswordResetEmailSent()); // Emitimos un estado indicando que el correo fue enviado
    } catch (error) {
      emit(AuthError(error.toString())); // Si hay error, emitimos un estado de error
    }
  }
}