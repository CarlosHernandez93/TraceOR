import 'package:cloud_firestore/cloud_firestore.dart';

class PatientProcedureRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String?> registerPatient({
    required String name,
    required String lastName,
    required String birthDate,
    required String age,
    required String typeDocument,
    required String document,
    }) async {
    try {
      DocumentReference patientDocument = await _firestore.collection('Patients').add({
        'name': name,
        'lastName': lastName,
        'birthDate': birthDate,
        'age': age,
        'typeDocument': typeDocument,
        'document': document
      });

      return patientDocument.id;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> registerProcedure({
    required String patientId,
    required String operatingRoom,
    required String description
  }) async {
    try {
      DocumentReference patientDocument = _firestore.collection('Patients').doc(patientId);

      DocumentReference patientProcedureDocument = await _firestore.collection('PatientProcedure').add({
        'patient': patientDocument,
        'cretedAt': DateTime.now(),
        'procedure': [],
        'operatingRoom': operatingRoom,
        'description': description
      });

      return patientProcedureDocument.id;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> updateListProcedure({
    required String patientProcedureId,
    required String operatingRoom,
  }) async {
    try {
      DocumentReference patientProcedureDocument = _firestore.collection('PatientProcedure').doc(patientProcedureId);
      
      QuerySnapshot query = await _firestore.collection('ListProcedure').get();
      DocumentReference listProcedureDocument = query.docs.first.reference;

      await listProcedureDocument.update({
        operatingRoom: patientProcedureDocument
      });

      return true;
    } catch (e) {
      return false;
    }
  }
}