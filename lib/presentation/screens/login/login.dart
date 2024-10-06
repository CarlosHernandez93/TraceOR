import 'package:toastification/toastification.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/widgets/custom_password_field.dart';
import 'package:trace_or/widgets/custom_text_field.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trace_or/config/router/app_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void navigationPage() {
    appRouter.go('/login');
  }

  @override
  Widget build(BuildContext context) {

    double heightApp = MediaQuery.of(context).size.height;
    double widthApp = MediaQuery.of(context).size.width;
    
    return PopScope(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if (state is AuthError) {
            // Muestra el Toast cuando ocurre un error
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text("Usario incorrecto"),
              description: const Text("El correo o contraseña no coincide"),
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: highModeShadow,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.colorFive,
          body: SingleChildScrollView(
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
                            ),
                          )
                        )
                      ],
                    ),
                    Row(children: <Widget>[
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
                                child: Column(children: <Widget>[
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
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.045)),
                                    width: widthApp * 0.75,
                                    child: CustomPasswordField(
                                      hintText: "Contraseña",
                                      controller: passwordController
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.05)),
                                    width: widthApp * 0.75,
                                    child: CustomElevatedButton(
                                      text: "Iniciar Sesion",
                                      color: AppColors.colorSix,
                                      onPressed:(){
                                        FocusScope.of(context).unfocus();
                                        context.read<AuthBloc>().add(
                                          AuthLogin(
                                            email: emailController.text, 
                                            password: passwordController.text
                                          )
                                        );
                                      } ,
                                    ),
                                  )
                                ]),
                              ),
                            ) 
                          ),
                        ),
                      ),
                    ]),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: (heightApp * 0.03)),
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: CustomElevatedButton(
                              text: "Crear Cuenta",
                              color: AppColors.colorSix,
                              onPressed:(){
                                //
                              } ,
                            ),
                          )
                        )
                      ]
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}