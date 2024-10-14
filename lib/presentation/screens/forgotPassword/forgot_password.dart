import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:trace_or/widgets/custom_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  TextEditingController emailController = TextEditingController();

  void forgotValidation (){
    if(emailController.text == ''){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Campo incompleto"),
        description: const Text("El campo esta vacio"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
    }
    else{
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(AuthPasswordResetRequested(email: emailController.text ));
    }
  }

  @override
  Widget build(BuildContext context) {

    double heightApp = MediaQuery.of(context).size.height;
    double widthApp = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if(state is AuthError){
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text("Error"),
              description: const Text("No se pudo enviar una notificacion al correo ingresado"),
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: highModeShadow,
            );
          }
          if(state is PasswordResetEmailSent){
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: const Text("Solictud exitosa"),
              description: const Text("Se envio una notificacion al correo ingresado"),
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: highModeShadow,
            );
            appRouter.go('/login');
          }
        },
        child: Stack(
          fit: StackFit.loose,
          children: [
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              isComplex: false,
              painter: CurvePainterShort(),
              child: Container(
                height: heightApp * 0.8,
                margin: EdgeInsets.only(bottom: (heightApp * 0.08)),
              )
            ),
            CustomPaint(
              size: const Size(double.infinity, double.infinity),
              isComplex: false,
              painter: CurvePainterLong(),
              child: Container(height: heightApp * 0.8)
            ),
            Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.only(top: (heightApp * 0.08)),
                          alignment: Alignment.topCenter,
                          height: 160,
                          child: SvgPicture.asset(ImagesReferences.logo),
                        )
                      )
                    )
                  ]
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: (heightApp * 0.03)),
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: Card(
                          color: AppColors.colorFive,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10.0,
                          child: Padding(
                            padding: EdgeInsets.only(top: (heightApp * 0.03), bottom: (heightApp * 0.03)),
                            child: Form(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.01)),
                                    width: widthApp * 0.75,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Recuperar Cuenta',
                                      style: TextStyle(
                                        color: AppColors.colorOne,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Proporciónanos algo de información sobre esta cuenta.',
                                      style: TextStyle(
                                        fontSize: 16
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: CustomTextField(
                                      hintText: "Correo electronico",
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      icon: Icons.person_outline,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                    width: widthApp * 0.75,
                                    child: CustomElevatedButton(
                                      text: "Continuar",
                                      color: AppColors.colorSix,
                                      onPressed:(){
                                        forgotValidation();
                                      } ,
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                        )
                      )
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ) 
    );
  }
}