import 'package:cloud_firestore/cloud_firestore.dart';

class ConstanstRepository {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<String>> getRoles() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Constants')
        .doc('Role')
        .get();

    return List<String>.from(snapshot['roles']);
  }

  static Future<List<String>> getTypeDocuments() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('Constants')
        .doc('TypeDocument')
        .get();

    return List<String>.from(snapshot['documents']);
  }
}