import 'package:equatable/equatable.dart';

abstract class PatientProcedureState extends Equatable {
  const PatientProcedureState();

  @override
  List<Object> get props => [];
}

class PatientProcedureInitial extends PatientProcedureState {}

class OperatingRoomValue extends PatientProcedureState {
  final String value;

  const OperatingRoomValue(this.value);

  @override
  List<Object> get props => [value];
}

class PatientValue extends PatientProcedureState {
  final String value;

  const PatientValue(this.value);

  @override
  List<Object> get props => [value];
}