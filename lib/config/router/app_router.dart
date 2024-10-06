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
  ],
  initialLocation: '/'
);