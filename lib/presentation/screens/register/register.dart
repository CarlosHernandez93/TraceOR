import 'package:toastification/toastification.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/widgets/custom_list_field.dart';
import 'package:trace_or/widgets/custom_password_field.dart';
import 'package:trace_or/widgets/custom_text_field.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/repository/repositories.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController documentController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController roleController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<dynamic> roles = [];
  List<dynamic> typeDocuments = [];
  final formKey = GlobalKey<FormState>();
  String typeDocuent = '';
  String roleUser = '';

  void registerValidation(){
    if(
      nameController.text == '' ||
      typeDocuent == '' ||
      documentController.text == '' ||
      roleUser == '' ||
      emailController.text == '' || 
      passwordController.text == ''
    ){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Campos incompletos"),
        description: const Text("Algunos de los campos estan vacios"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
    }
    else{
      FocusScope.of(context).unfocus();
      context.read<AuthBloc>().add(
        AuthRegister(
          fullName: nameController.text,
          email: emailController.text, 
          password: passwordController.text,
          role: roleUser,
          documentType: typeDocuent,
          documentNumber: documentController.text
        )
      );
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadData() async {
    List<dynamic> fetchedRoles = await ConstanstRepository.getRoles();
    List<dynamic> fetchedTypeDocuments = await ConstanstRepository.getTypeDocuments();

    setState(() {
      roles = fetchedRoles;
      typeDocuments = fetchedTypeDocuments;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    
    double heightApp = MediaQuery.of(context).size.height;
    double widthApp = MediaQuery.of(context).size.width;
    
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state){
          if (state is AuthError) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text("Error"),
              description: const Text("No se pudo crear el usuario"),
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: highModeShadow,
            );
          }
          if(state is AuthAuthenticated){
            toastification.show(
              context: context,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: const Text("Registro exitoso!"),
              alignment: Alignment.bottomCenter,
              autoCloseDuration: const Duration(seconds: 4),
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: highModeShadow,
            );
            appRouter.go('/login');
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
                                key: formKey,
                                child: Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: CustomTextField(
                                      hintText: "Nombre Completo",
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
                                      icon: Icons.person,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: CustomListField(
                                      hintText: "Tipo de documento",
                                      items: typeDocuments,
                                      onChanged: (value) {
                                        typeDocuent = value!;
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: CustomTextField(
                                      hintText: "Numero de documento",
                                      controller: documentController,
                                      keyboardType: TextInputType.number,
                                      icon: Icons.badge,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: CustomListField(
                                      hintText: "Rol",
                                      items: roles,
                                      onChanged: (value) {
                                        roleUser = value!;
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: CustomTextField(
                                      hintText: "Correo electronico",
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      icon: Icons.email,
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
                                        registerValidation();
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