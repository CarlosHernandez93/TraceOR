import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trace_or/device/device_size.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  VideoState createState() => VideoState();
}

DeviceSize? deviceSize;

class VideoState extends State<Splash> with SingleTickerProviderStateMixin {
   var _visible = true;
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    // Controlador de animación para el logo
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });

    // Temporizador para el splash (3 segundos)
    Timer(const Duration(seconds: 3), () {
      // Verificar el estado del AuthBloc
      context.read<AuthBloc>().add(AppStarted());
    });
  }
  
  @override
  Widget build(BuildContext context) {
    deviceSize = DeviceSize(
        size: MediaQuery.of(context).size,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        aspectRatio: MediaQuery.of(context).size.aspectRatio);

    return Scaffold(
      backgroundColor: AppColors.colorOne,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if (state is AuthPreviousAuthenticated) {
            appRouter.go('/home');
          }
          if(state is AuthUnauthenticated){
            appRouter.go('/login');
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: animation.value * 250,
                  height: animation.value * 250,
                  child: SvgPicture.asset(ImagesReferences.logo),
                ),
              ],
            ),
          ],
        )
      )
    );
  }
}