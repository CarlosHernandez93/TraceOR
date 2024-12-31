import 'package:cloud_firestore/cloud_firestore.dart';

class ConstanstRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Obtener la lista de roles definidos en el documento
  static Future<List<String>> getRoles() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Constants')
        .doc('Role')
        .get();

    return List<String>.from(snapshot['roles']);
  }

  // Obtener la lista de documentos definidos en el documento
  static Future<List<String>> getTypeDocuments() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Constants')
        .doc('TypeDocument')
        .get();

    return List<String>.from(snapshot['documents']);
  }

    // Obtener la lista de documentos definidos en el documento
  static Future<List<String>> getNameOperatingRooms() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Constants')
        .doc('OR')
        .get();

    return List<String>.from(snapshot['items']);
  }
}