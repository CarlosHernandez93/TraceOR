import 'package:go_router/go_router.dart';
import 'package:trace_or/presentation/screens/screens.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Splash()
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const Login()
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const Register()
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Home()
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => const ForgotPassword()
    ),
  ],
  initialLocation: '/'
);