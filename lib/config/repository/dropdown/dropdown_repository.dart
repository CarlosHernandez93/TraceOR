import 'package:cloud_firestore/cloud_firestore.dart';

class DropdownRepository {
  final FirebaseFirestore firestore;

  DropdownRepository({required this.firestore});

  // Obtener el stream de 'Pacient' en tiempo real
  Stream<List<String>> getPacientStream() {
    return firestore.collection('Constants').doc('Pacient').snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<String> pacientItems = List<String>.from(snapshot.data()?['items'] ?? []);
        print(pacientItems);
        return pacientItems;
      } else {
        return [];
      }
    });
  }

  // Obtener el stream de 'OR' (Operating Room) en tiempo real
  Stream<List<String>> getORStream() {
    return firestore.collection('Constants').doc('OR').snapshots().map((snapshot) {
      if (snapshot.exists) {
        List<String> orItems = List<String>.from(snapshot.data()?['items'] ?? []);
        print(orItems);
        return orItems;
      } else {
        return [];
      }
    });
  }
}
