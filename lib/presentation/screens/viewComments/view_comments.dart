import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_bloc.dart';
import 'package:trace_or/widgets/comment_card.dart';

class ViewComments extends StatefulWidget {
  const ViewComments({super.key});

  @override
  State<ViewComments> createState() => _ViewCommentsState();
}

class _ViewCommentsState extends State<ViewComments> {
  final StreamController<dynamic> streamController = StreamController<dynamic>();
  final TextEditingController commentController = TextEditingController();
  List<dynamic> listProcedure = [];

  void loadData() {
    context.read<PatientProcedureBloc>().state.patientValue?.snapshots().listen((snapshot){
      streamController.add(snapshot.data());
    });
  }

  void updateListComment() async{
    if(commentController.text == ''){

      toastification.show(
          context: context,
          type: ToastificationType.warning,
          style: ToastificationStyle.flatColored,
          title: const Text("Aviso"),
          description: const Text("Estas intentando guardar un comentario vacio!"),
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: highModeShadow,
        );
    }
    else{

      final patientProcedureState = context.read<PatientProcedureBloc>().state;
      User? user = FirebaseAuth.instance.currentUser;
      DocumentReference docRefPatientProcedure = patientProcedureState.patientValue!;
      DocumentSnapshot document = await docRefPatientProcedure.get();
      List<dynamic> listProcedure = document['procedure'];
      int indexActiveItem = listProcedure.indexWhere((item) => item['active'] == true);
      var activeItem = listProcedure[indexActiveItem];
      List<dynamic> listComments = activeItem['comments'];

      // Creacion del comentario
      Map<String, dynamic> comment = {
        "user": user!.displayName,
        "comment": commentController.text,
        "datePublish": DateTime.now()
      };
      listComments.add(comment);

      listProcedure[indexActiveItem]['comments'] = listComments;

      try {
        await docRefPatientProcedure.update({'procedure': listProcedure});
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          title: const Text("Solictud exitosa"),
          description: const Text("Se registro correctamente el procedimiento!"),
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: highModeShadow,
        );
      } catch (e) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: const Text("Error"),
          description: const Text("No se pudo registrar el procedimiento"),
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: highModeShadow,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double heightApp = MediaQuery.of(context).size.height;
    double widthApp = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Comentarios",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              bool s = await streamController.close();
              if(s){
                print("Se cerro");
              }
              //context.read<AuthBloc>().add((AuthLogout()));
            }, 
            icon: const Icon(Icons.logout)
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state){
            if (state is AuthUnauthenticated) {
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: EdgeInsets.only(
                      top: (heightApp * 0.15), 
                      bottom: (heightApp * 0.10),
                      right: (widthApp * 0.05),
                      left: (widthApp * 0.05)
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.comment, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            minLines: 2,
                            maxLines: 2,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            controller: commentController,
                            decoration: const InputDecoration(
                              hintText: 'Añadir un comentario',
                              border: InputBorder.none,
                            ),
                          )
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: updateListComment, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                          ),
                          child: Text("Enviar")
                        )
                      ],
                    )
                  ),
                  StreamBuilder(
                    stream: streamController.stream, 
                    builder: (BuildContext context, AsyncSnapshot snapshot){

                      if(!snapshot.hasData){
                        return Container(
                          width: widthApp,
                          margin: EdgeInsets.only(top: (heightApp * 0.20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos verticalmente
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                color: AppColors.colorFive,
                              ),
                              SizedBox(height: (heightApp * 0.02)),
                              const Text(
                                "Cargando...",
                                style: TextStyle(
                                  color: AppColors.colorFive,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22
                                )
                              )
                            ],
                          ),
                        );
                      }

                      var dataProcedure = snapshot.data as Map<String, dynamic>?;
                      listProcedure = dataProcedure!['procedure'];
                      Map<String, dynamic> currentStep = listProcedure.firstWhere((item) => item['active'] == true);

                      if(currentStep['comments'].isEmpty){
                        return Column(
                          children: [
                            Lottie.asset(
                              'assets/animation-search.json',
                              width: 300,
                              height: 200,
                            ),
                            const Text(
                              "No se encuentran comentarios",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            )
                          ]
                        );
                      }
                      else{
                        return Container(
                          margin: EdgeInsetsDirectional.symmetric(horizontal: (widthApp * 0.05)),
                          child:  ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: currentStep['comments'].length,
                            itemBuilder: (context, index){
                              return CommentCard(
                                comment: currentStep['comments'][index]["comment"],
                                username: currentStep['comments'][index]["user"],
                              );
                            },
                          )
                        );
                      }
                    }
                  )
                ],
              )
            ]
          )
        ),
      )
    );
  }
}