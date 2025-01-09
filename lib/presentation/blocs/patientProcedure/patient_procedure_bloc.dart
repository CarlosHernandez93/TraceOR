import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_event.dart';
import 'package:trace_or/presentation/blocs/patientProcedure/patient_procedure_state.dart';

class PatientProcedureBloc extends Bloc<PatientProcedureEvent, PatientProcedureState> {

  PatientProcedureBloc() : super(const PatientProcedureState()){
    on<UpdateOperatingRoomValue>(saveOperatingRoomValue);
    on<UpdatePatientValue>(savePatientValue);
  }


  void saveOperatingRoomValue(event, emit) {
    emit(state.copyWith(operatingRoomValue: event.value));
  }

  void savePatientValue(event, emit) {
    emit(state.copyWith(patientValue: event.value));
  }
}