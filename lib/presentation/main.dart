import 'package:trace_or/config/repository/repositories.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trace_or/config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "TraceOR",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(FirebaseAuth.instance, FirebaseFirestore.instance),
      child: BlocProvider(
        create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context)
        ),
        child: MaterialApp.router(
          title: 'TraceOR',
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          theme: AppTheme.getTheme,
        )
      ),
    ); 
  }
}
