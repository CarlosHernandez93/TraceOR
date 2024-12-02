import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_event.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_state.dart';

class PatientProcedureBloc extends Bloc<PatientProcedureEvent, PatientProcedureState> {

  PatientProcedureBloc() : super(PatientProcedureInitial()){
    on<UpdateOperatingRoomValue>(saveOperatingRoomValue);
    on<UpdatePatientValue>(savePatientValue);
  }


  void saveOperatingRoomValue(event, emit) {
    final operatingRoom = event.value;
    emit(OperatingRoomValue(operatingRoom));
  }

  void savePatientValue(event, emit) {
    final patient = event.value;
    emit(PatientValue(patient));
  }
}