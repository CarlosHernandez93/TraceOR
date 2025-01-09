import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';
import 'package:trace_or/config/repository/constants/constants_repository.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/domain/entities/list_item.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_bloc.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:trace_or/widgets/custom_text_field.dart';

class RegisterListProcedure extends StatefulWidget {
  const RegisterListProcedure({super.key});

  @override
  State<RegisterListProcedure> createState() => _RegisterListProcedureState();
}

class _RegisterListProcedureState extends State<RegisterListProcedure> {

  TextEditingController nameProcessController = TextEditingController();
  bool isLoading = false;
  List<ListItem> stepsListProcedure = [];
  late DocumentSnapshot docPatientProcedure;
  late List<ListItem> fetchedPatientProcedure;
  
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    List<String> fetchedStepsListProcedure = await ConstanstRepository.stepsListProcedure();
    fetchedPatientProcedure = fetchedStepsListProcedure.map((step) => ListItem(step, true)).toList();

    setState(() {
      stepsListProcedure = fetchedPatientProcedure;
      isLoading = false;
    });
  }

  void searchItem(String query) {
    final search = fetchedPatientProcedure.where((element) {
      final nameStep = element.title.toLowerCase();
      final input = query.toLowerCase();

      return nameStep.contains(input);
    }).toList();
    setState(() => stepsListProcedure = search);
  }

  void updateListProcedure() async {
    bool isFirtsItem = true;
    var result = stepsListProcedure.map((item){
      if(item.check && isFirtsItem){
        isFirtsItem = false;
        return {'step': item.title, 'active': true, 'comments': []};
      } else if(item.check) {
        return {'step': item.title, 'active': false, 'comments': []};
      }
    }).toList();
    
    final patientProcedureState = context.read<PatientProcedureBloc>().state;
    DocumentReference docRefPatientProcedure = patientProcedureState.patientValue!;
    try {
      await docRefPatientProcedure.update({'procedure': result});
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
      appRouter.pop();
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
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogout());
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
                  isLoading
                  ? Container(
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
                    )
                  : Center(
                      child: Container(
                        height: heightApp * 0.8,
                        width: widthApp * 0.85,
                        margin: EdgeInsets.only(top: (heightApp * 0.15)),
                        child: Card(
                          color: AppColors.colorFive,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 10.0,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: (heightApp * 0.02), 
                              bottom: (heightApp * 0.02), 
                              left: 16, right: 16
                            ),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                  child: const Text(
                                    "Lista de procesos",
                                    style: TextStyle(
                                      color: AppColors.colorFour,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22
                                    )
                                  )
                                ),
                                Container(
                                  margin: EdgeInsets.only(bottom: (heightApp * 0.025)),
                                  child: CustomTextField(
                                    hintText: "Nombre del proceso",
                                    controller: nameProcessController,
                                    keyboardType: TextInputType.text,
                                    icon: Icons.search_outlined,
                                    onChanged: searchItem,
                                  )
                                ),
                                stepsListProcedure.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Lottie.asset(
                                            'assets/animation-search.json',
                                            width: 300,
                                            height: 200,
                                          ),
                                          const Text(
                                            "No se encontraron resultados",
                                            style: TextStyle(
                                              color: AppColors.colorFour,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ]
                                      )
                                    ),
                                  )
                                : Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: stepsListProcedure.length,
                                      itemBuilder: (context, index){
                                        return CheckboxListTile(
                                          key: Key('$index'),
                                          title: Text(
                                            stepsListProcedure[index].title,
                                            style: const TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.colorFour
                                            ),
                                          ),
                                          value: stepsListProcedure[index].check,
                                          checkColor: AppColors.colorFour,
                                          activeColor: AppColors.colorSix,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              stepsListProcedure[index].check = value!;
                                            });
                                          },
                                        );
                                      }
                                    )
                                  ),
                                SizedBox(
                                  height: heightApp * 0.025,
                                ),
                                CustomElevatedButton(
                                  text: "Añadir",
                                  color: AppColors.colorSix,
                                  onPressed: updateListProcedure        
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}