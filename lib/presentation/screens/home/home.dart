import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_bloc.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_event.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_state.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:trace_or/widgets/custom_list_field.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _patientItems = [];
  List<String> _orItems = [];
  //String? _selectedOR; // Almacena el quirófano seleccionado

  void _loadORItems() {
    FirebaseFirestore.instance
        .collection('Constants')
        .doc('OR')
        .snapshots()
        .listen((snapshot) {
      setState(() {
        if (snapshot.exists) {
          _orItems = List<String>.from(snapshot.data()?['items'] ?? []);
        } else {
          _orItems = [];
        }
      });
    });
  }

  void _loadPacientItems(String operatingRoom) async {
    var query = await FirebaseFirestore.instance
        .collection('ListProcedure').get();
    
    DocumentReference listProcedureDocument = query.docs.first.reference;

    listProcedureDocument
      .snapshots()
      .listen((snapshot) async {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        DocumentReference? docRefProcedure = data?[operatingRoom];

        if(docRefProcedure == null) {
          setState(() {
            _patientItems = [];
          });
          return;
        }

        DocumentSnapshot docProcedure = await docRefProcedure.get();
        var dataProcedure = docProcedure.data() as Map<String, dynamic>;
        DocumentReference docRefPatient = dataProcedure['patient'];
        DocumentSnapshot docPatient = await docRefPatient.get();
        var dataPatient = docPatient.data() as Map<String, dynamic>;
        String namePatient = "${dataPatient['name']} ${dataPatient['lastName']}";

        setState(() {
          _patientItems = [{"id": docRefProcedure, "name": namePatient}];
        });
      });
  }

  void navigateToRegisterListProcedure() async {
    final patientProcedureState = context.read<PatientProcedureBloc>().state;
    if(patientProcedureState.patientValue == null){
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flatColored,
        title: const Text("Aviso"),
        description: const Text("Debe seleccionar un paciente"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }

    DocumentSnapshot docPatientProcedure = await patientProcedureState.patientValue!.get();
    List listProcedure = docPatientProcedure['procedure'];
    if(listProcedure.isNotEmpty){
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flatColored,
        title: const Text("Aviso"),
        description: const Text("Ya el paciente cuenta con un procedimiento"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }
    appRouter.push('/home/registerListProcedure');
  }

  void navigateToProcedure() async {
    final patientProcedureState = context.read<PatientProcedureBloc>().state;
    if(patientProcedureState.patientValue == null){
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Debe seleccionar un paciente"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }

    DocumentReference patientProcedure = patientProcedureState.patientValue!;
    DocumentSnapshot docPatientProcedure = await patientProcedure.get();

    if((docPatientProcedure.data() as Map<String, dynamic>)["procedure"]?.length == 0){
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("El paciente no tiene procedimientos asignados"),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }

    appRouter.push('/home/viewProcedure');
  }

  @override
  void initState() {
    super.initState();
    _loadORItems();
  }

  @override
  Widget build(BuildContext context) {
    double heightApp = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
            },
            icon: const Icon(Icons.logout),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
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
                ),
              ),
              CustomPaint(
                size: const Size(double.infinity, double.infinity),
                isComplex: false,
                painter: CurvePainterLong(),
                child: Container(height: heightApp * 0.8),
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
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: (heightApp * 0.03)),
                                child: const Text(
                                  'Quirofanos disponibles:',
                                  style: TextStyle(
                                    color: AppColors.colorFive,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22
                                  ),
                                ),
                              ),
                              BlocBuilder<PatientProcedureBloc, PatientProcedureState>(
                                builder: (context, state){
                                  return CustomListField(
                                    items: _orItems,
                                    onChanged: (value) {
                                      if (value != null) {
                                        _loadPacientItems(value); // Cargar pacientes
                                        context.read<PatientProcedureBloc>().add(UpdateOperatingRoomValue(value));
                                      }
                                    },
                                  );
                                }
                              ),
                              const SizedBox(height: 15),
                              CustomElevatedButton(
                                text: "Añadir paciente",
                                color: AppColors.colorSix,
                                icon: Icons.add,
                                onPressed: () {
                                  appRouter.push('/home/registerPatient');
                                },
                              ),
                              const SizedBox(height: 30),
                              Container(
                                margin: EdgeInsets.only(bottom: (heightApp * 0.03)),
                                child: const Text(
                                  'Lista de pacientes:',
                                  style: TextStyle(
                                    color: AppColors.colorFive,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              BlocBuilder<PatientProcedureBloc, PatientProcedureState>(
                                builder: (context, state) {
                                  return CustomListField(
                                    items: _patientItems,
                                    onChanged: (value) {
                                      context.read<PatientProcedureBloc>().add(UpdatePatientValue(value!));
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomElevatedButton(
                                      text: "Configurar",
                                      color: AppColors.colorSix,
                                      icon: Icons.settings,
                                      onPressed: () {
                                        navigateToRegisterListProcedure();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: CustomElevatedButton(
                                      text: "Observar",
                                      color: AppColors.colorSix,
                                      icon: Icons.visibility,
                                      onPressed: () {
                                        navigateToProcedure();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}