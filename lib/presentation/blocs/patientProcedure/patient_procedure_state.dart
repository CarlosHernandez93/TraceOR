import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class PatientProcedureState extends Equatable {
  final String? operatingRoomValue;
  final DocumentReference? patientValue;

  const PatientProcedureState({
    this.operatingRoomValue,
    this.patientValue,
  });

  PatientProcedureState copyWith({
    String? operatingRoomValue,
    DocumentReference? patientValue,
  }){
    return PatientProcedureState(
      operatingRoomValue: operatingRoomValue ?? this.operatingRoomValue,
      patientValue: patientValue ?? this.patientValue,
    );
  }

  @override
  List<Object?> get props => [operatingRoomValue, patientValue];
}