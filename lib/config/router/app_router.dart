import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:trace_or/presentation/screens/screens.dart';

final firestore = FirebaseFirestore.instance;

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
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
          path: 'registerPatient',
          builder: (context, state) => const RegisterPatient()
        ),
        GoRoute(
          path: 'registerListProcedure',
          builder: (context, state) => const RegisterListProcedure()
        ),
        GoRoute(
          path: 'viewProcedure',
          builder: (context, state) => const ViewProcedure()
        )
      ]
    ),
    GoRoute(
      path: '/forgotPassword',
      builder: (context, state) => const ForgotPassword()
    ),
  ],
  initialLocation: '/'
);