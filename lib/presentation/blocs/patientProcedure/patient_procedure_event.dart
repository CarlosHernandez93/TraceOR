import 'package:equatable/equatable.dart';

abstract class PatientProcedureEvent extends Equatable {
  const PatientProcedureEvent();

  @override
  List<Object> get props => [];
}

class UpdateOperatingRoomValue extends PatientProcedureEvent {
  final String value;

  const UpdateOperatingRoomValue({required this.value});

  @override
  List<Object> get props => [value];
}

class UpdatePatientValue extends PatientProcedureEvent {
  final String value;

  const UpdatePatientValue({required this.value});

  @override
  List<Object> get props => [value];
}