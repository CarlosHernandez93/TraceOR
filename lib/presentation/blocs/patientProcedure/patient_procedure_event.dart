import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PatientProcedureEvent extends Equatable {
 
  @override
  List<Object> get props => [];
}

class UpdateOperatingRoomValue extends PatientProcedureEvent {
  final String value;

  UpdateOperatingRoomValue(this.value);

  @override
  List<Object> get props => [value];
}

class UpdatePatientValue extends PatientProcedureEvent {
  final DocumentReference value;

  UpdatePatientValue(this.value);

  @override
  List<Object> get props => [value];
}