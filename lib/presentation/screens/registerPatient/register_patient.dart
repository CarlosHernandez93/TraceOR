import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toastification/toastification.dart';
import 'package:trace_or/config/repository/constants/constants_repository.dart';
import 'package:trace_or/config/repository/patientProcedure/patient_procedure_repository.dart';
import 'package:trace_or/config/router/app_router.dart';
import 'package:trace_or/config/theme/app_colors.dart';
import 'package:trace_or/config/theme/curve_painter_long.dart';
import 'package:trace_or/config/theme/curve_painter_short.dart';
import 'package:trace_or/config/utils/image_references.dart';
import 'package:trace_or/presentation/blocs/auth/auth_bloc.dart';
import 'package:trace_or/presentation/blocs/auth/auth_event.dart';
import 'package:trace_or/presentation/blocs/auth/auth_state.dart';
import 'package:trace_or/widgets/custom_date_picker.dart';
import 'package:trace_or/widgets/custom_elevated_button.dart';
import 'package:trace_or/widgets/custom_list_field.dart';
import 'package:trace_or/widgets/custom_text_area_field.dart';
import 'package:trace_or/widgets/custom_text_field.dart';

class RegisterPatient extends StatefulWidget {
  const RegisterPatient({super.key});

  @override
  State<RegisterPatient> createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {

  TextEditingController documentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birhtDateController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Map<String, dynamic>? documentData;
  String? documentDataID;
  bool isLoading = false;
  bool isSearching = false;
  List<dynamic> typeDocuments = [];
  List<dynamic> namesOperatingRooms= [];
  String typeDocument = '';
  String nameOperatingRooms = '';

 Future<void> searchDocument() async {
    setState(() {
      isSearching = true;
      isLoading = true;
      documentData = null;
      documentDataID = null;
    });

    FocusScope.of(context).unfocus();
    String documentValue = documentController.text.trim();

    if (documentValue.isEmpty) {
      setState(() {
        isLoading = false;
      });
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Por favor, ingresa un valor válido."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }

    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection('Patients')
          .where('document', isEqualTo: documentValue)
          .get();

      if (query.docs.isNotEmpty) {
        // Documento encontrado
        setState(() {
          documentData = query.docs.first.data() as Map<String, dynamic>;
          documentDataID = query.docs.first.reference.id;
        });
      } else {
        // Documento no encontrado
        setState(() {
          documentData = null;
          documentDataID = null;
        });
        toastification.show(
          context: context,
          type: ToastificationType.warning,
          style: ToastificationStyle.flatColored,
          title: const Text("Aviso"),
          description: const Text("No se encontro información del paciente."),
          alignment: Alignment.bottomCenter,
          autoCloseDuration: const Duration(seconds: 4),
          borderRadius: BorderRadius.circular(100.0),
          boxShadow: highModeShadow,
        );
      }

    if(documentData != null){
      nameController.text = documentData!['name'];
      lastNameController.text = documentData!['lastName'];
      birhtDateController.text = documentData!['birthDate'];
      ageController.text = documentData!['age'];  
    }
    else{
      nameController.clear();
      lastNameController.clear();
      birhtDateController.clear();
      ageController.clear();
      descriptionController.clear();
      nameOperatingRooms = '';
      typeDocument = '';
    }

    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Ocurrio un error."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> registerPatient() async {

    if(nameController.text.isEmpty || 
    lastNameController.text.isEmpty || 
    birhtDateController.text.isEmpty || 
    ageController.text.isEmpty || 
    typeDocument.isEmpty || 
    documentController.text.isEmpty ||
    nameOperatingRooms.isEmpty || 
    descriptionController.text.isEmpty){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Por favor, ingresa todos los campos."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }
  
    var createUser = await PatientProcedureRepository.registerPatient(
      name: nameController.text,
      lastName: lastNameController.text,
      birthDate: birhtDateController.text,
      age: ageController.text,
      typeDocument: typeDocument,
      document: documentController.text
    );

    if(createUser == null){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Ocurrio un error al registrar el paciente."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }

    var createProcedure = await PatientProcedureRepository.registerProcedure(
      patientId: createUser,
      operatingRoom: nameOperatingRooms,
      description: descriptionController.text
    );

    if(createProcedure == null){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Ocurrio un error al registrar el procedimiento."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    } 

    var updateItemListProcedure = await PatientProcedureRepository.updateListProcedure(
      patientProcedureId: createProcedure,
      operatingRoom: nameOperatingRooms
    );

    if(!updateItemListProcedure){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Ocurrio un error al añadir el procedimiento a la lista."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    } 

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("Exito"),
      description: const Text("Paciente registrado correctamente."),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(100.0),
      boxShadow: highModeShadow,
    );

    nameController.clear();
    lastNameController.clear();
    birhtDateController.clear();
    ageController.clear();
    documentController.clear();
    descriptionController.clear();
    nameOperatingRooms = '';
    typeDocument = '';
    
    setState(() {
      isSearching = false;
    });
  }

  Future<void> registerProcedure() async {
    if(nameOperatingRooms.isEmpty || 
    descriptionController.text.isEmpty){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Por favor, ingresa todos los campos."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    }

    var createProcedure = await PatientProcedureRepository.registerProcedure(
      patientId: documentDataID!,
      operatingRoom: nameOperatingRooms,
      description: descriptionController.text
    );

    if(createProcedure == null){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Ocurrio un error al registrar el procedimiento."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    } 

    var updateItemListProcedure = await PatientProcedureRepository.updateListProcedure(
      patientProcedureId: createProcedure,
      operatingRoom: nameOperatingRooms
    );

    if(!updateItemListProcedure){
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Error"),
        description: const Text("Ocurrio un error al añadir el procedimiento a la lista."),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 4),
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: highModeShadow,
      );
      return;
    } 

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      title: const Text("Exito"),
      description: const Text("Se actualizo la información del paciente correctamente."),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(100.0),
      boxShadow: highModeShadow,
    );

    nameController.clear();
    lastNameController.clear();
    birhtDateController.clear();
    ageController.clear();
    documentController.clear();
    descriptionController.clear();
    nameOperatingRooms = '';
    typeDocument = '';
    
    setState(() {
      isSearching = false;
    });

  }

  Future<void> _loadData() async {
    List<dynamic> fetchedTypeDocuments = await ConstanstRepository.getTypeDocuments();
    List<dynamic> fetchNameOperatingRooms = await ConstanstRepository.getNameOperatingRooms();

    setState(() {
      typeDocuments = fetchedTypeDocuments;
      namesOperatingRooms = fetchNameOperatingRooms;
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add((AuthLogout()));
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
                              padding: EdgeInsets.only(top: (heightApp * 0.02), bottom: (heightApp * 0.02)),
                              child: Form(
                                child: Column(children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                    width: widthApp * 0.75,
                                    child: Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                          child: const Text(
                                            "Consulta de pacientes",
                                            style: TextStyle(
                                              color: AppColors.colorFour,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22
                                            )
                                          )
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                          child: CustomTextField(
                                            hintText: "Numero de identificación",
                                            controller: documentController,
                                            keyboardType: TextInputType.number,
                                            icon: Icons.search_outlined,
                                          )
                                        ),
                                        CustomElevatedButton(
                                          text: "Buscar",
                                          color: AppColors.colorSix,
                                          onPressed: () {
                                            searchDocument();
                                          }
                                        )
                                      ],
                                    ) 
                                  )
                                ])
                              )
                            ),
                          )
                        )
                      )
                    ],
                  ),
                  if (isSearching)
                    isLoading 
                      ? Container(
                          margin: EdgeInsets.only(top: (heightApp * 0.06)),
                          child: const CircularProgressIndicator(
                            color: AppColors.colorFive,
                          ),
                        )
                      : Row(
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
                                  padding: EdgeInsets.only(top: (heightApp * 0.02), bottom: (heightApp * 0.02)),
                                  child: Form(
                                    child: Column(children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(bottom: (heightApp * 0.035)),
                                        width: widthApp * 0.75,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: const Text(
                                                "Información del paciente",
                                                style: TextStyle(
                                                  color: AppColors.colorFour,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22
                                                )
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomTextField(
                                                hintText: "Nombres",
                                                controller: nameController,
                                                keyboardType: TextInputType.text,
                                                icon: Icons.person,
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomTextField(
                                                hintText: "Apellidos",
                                                controller: lastNameController,
                                                keyboardType: TextInputType.text,
                                                icon: Icons.person,
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: DatePickerWidget(
                                                hintText: "Fecha de nacimiento",
                                                dateController: birhtDateController,
                                                ageController: ageController,
                                                icon: Icons.calendar_month,
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomTextField(
                                                hintText: "Edad",
                                                controller: ageController,
                                                keyboardType: TextInputType.number,
                                                icon: Icons.person,
                                                enabled: false,
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomListField(
                                                items: typeDocuments,
                                                hintText: "Tipo de documento",
                                                onChanged: (value) {
                                                  typeDocument = value!;
                                                },
                                                initialValue: documentData != null ? documentData!['typeDocument'] : null,
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomTextField(
                                                hintText: "Numero de documento",
                                                keyboardType: TextInputType.number,
                                                controller: documentController
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomListField(
                                                items: namesOperatingRooms,
                                                hintText: "Quirófano",
                                                onChanged: (value) {
                                                  nameOperatingRooms = value!;
                                                },
                                              )
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(bottom: (heightApp * 0.02)),
                                              child: CustomTextAreaField(
                                                hintText: "Descripcion", 
                                                controller: descriptionController
                                              )
                                            ),
                                            CustomElevatedButton(
                                              text: "Registrar paciente",
                                              color: AppColors.colorSix,
                                              onPressed: () {
                                                documentData == null ? registerPatient() : registerProcedure();
                                              }
                                            )
                                          ],
                                        ) 
                                      )
                                    ])
                                  )
                                ),
                              )
                            )
                          )
                        ],
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