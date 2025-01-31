import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:trace_or/local_notification_service.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_bloc.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:trace_or/widgets/custom_text_button.dart';

class ViewProcedure extends StatefulWidget {
  const ViewProcedure({super.key});

  @override
  State<ViewProcedure> createState() => _ViewProcedureState();
}

class _ViewProcedureState extends State<ViewProcedure> {
  final StreamController<dynamic> streamController = StreamController<dynamic>();
  List<dynamic> listProcedure = [];
  int indexItem = 0;
  bool isFollow = false;

  void loadData() {
    context.read<PatientProcedureBloc>().state.patientValue?.snapshots().listen((snapshot){
      streamController.add(snapshot.data());
    });
  }

  void nextStep() {
    final patientProcedureState = context.read<PatientProcedureBloc>().state;
    DocumentReference docRefPatientProcedure = patientProcedureState.patientValue!;

    if(indexItem == listProcedure.length - 1){
      listProcedure[indexItem]['active'] = false;
      docRefPatientProcedure.update({'procedure': listProcedure});
      return;
    }

    listProcedure[indexItem]['active'] = false;
    listProcedure[indexItem + 1]['active'] = true;
    docRefPatientProcedure.update({'procedure': listProcedure});
  }

  void showModal (BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Aviso",
            style: TextStyle(
              color: Color(0xffdbb10c),
              fontSize: 23,
              fontWeight: FontWeight.w700,
              fontFamily: "OpenSans_SemiBold"
            )
          ),
          content: const Text(
            "El procedimiento quirurgico ha finalizado",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontFamily: "OpenSans"
            )
          ),
          actions: [
            CustomElevatedButton(
              text: "Aceptar",
              color: AppColors.colorSix,
              onPressed: () {
                appRouter.pop();
                appRouter.pop();
              }    
            )
          ],
        );
      }
    );
  }

  void startBackgroundTask (Map<String, dynamic> stepProcedure, int indexItem) async {
    final service = FlutterBackgroundService();
    bool isRunning = await service.isRunning();
    if (!isRunning) {
      service.startService();
      print("Servicio iniciado");
    }
  }

  void finishBackgroundTask () async {
    final service = FlutterBackgroundService();
    service.invoke("stopService");
    print("Servicio detenido");
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
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.only(top: (heightApp * 0.08)),
                            alignment: Alignment.topCenter,
                            height: 160,
                            child: SvgPicture.asset(ImagesReferences.logo),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: (heightApp * 0.03)),
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          height: heightApp * 0.6,
                          child: StreamBuilder(
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

                              if(listProcedure.every((item)=> item['active'] == false)){
                                WidgetsBinding.instance.addPostFrameCallback((_){
                                  showModal(context);
                                });
                                return const Text("");
                              }
                              //LocalNotificationService().showInstantNotification();
                              indexItem = listProcedure.indexWhere((item) => item['active'] == true);
                              Map<String, dynamic> itemProcedure = listProcedure[indexItem];
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.03)),
                                    child: const Text(
                                      'Proceso actual:',
                                      style: TextStyle(
                                        color: AppColors.colorFive,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.03)),
                                    child: Text(
                                      itemProcedure['step'],
                                      style: const TextStyle(
                                        color: AppColors.colorFive,
                                        fontSize: 22
                                      )
                                    )
                                  ),
                                  CustomElevatedButton(
                                    text: indexItem == listProcedure.length - 1 ? "Finalizar" : "Validar",
                                    color: AppColors.colorSix,
                                    onPressed: nextStep        
                                  ),
                                  // CustomElevatedButton(
                                  //   text: "Iniciar",
                                  //   color: AppColors.colorSix,
                                  //   onPressed: () async {
                                  //     final service = FlutterBackgroundService();
                                  //     bool isRunning = await service.isRunning();
                                  //     if (!isRunning) {
                                  //       service.startService();
                                  //       print("Servicio iniciado");
                                  //     }
                                  //   }       
                                  // ),
                                  // CustomElevatedButton(
                                  //   text: "Finalizar",
                                  //   color: AppColors.colorSix,
                                  //   onPressed: () async {
                                  //     final service = FlutterBackgroundService();
                                  //     service.invoke("stopService");
                                  //     print("Servicio detenido");
                                  //   }       
                                  // ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const SizedBox(height: 20,),
                                        CustomTextButton(
                                          color: Colors.transparent,
                                          text: isFollow ? "Dejar de seguir" : "Seguir",
                                          icon: isFollow ? Icons.visibility_off : Icons.visibility,
                                          textColor: AppColors.colorOne, 
                                          onPressed: () {
                                            setState(() {
                                              isFollow = !isFollow;
                                            });
                                            isFollow ? startBackgroundTask(itemProcedure, indexItem) : finishBackgroundTask();
                                          }
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ); 
                            }
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
      )
    );
  }
}