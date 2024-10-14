import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trace_or/domain/models/models.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._firebaseAuth, this._firestore);

  Future<UserModel> register({
    required fullName,
    required String email,
    required String password,
    required String role,
    required String documentType,
    required String documentNumber,
  }) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      // Guardar datos adicionales en Firestore
      await _firestore.collection('Users').doc(firebaseUser.uid).set({
        'fullName': fullName,
        'email': email,
        'role': role,
        'documentType': documentType,
        'documentNumber': documentNumber,
      });

      return UserModel(
        id: firebaseUser.uid,
        fullName: fullName,
        email: email,
        role: role,
        documentType: documentType,
        documentNumber: documentNumber,
      );
    } else {
      throw Exception("Error al registrar el usuario");
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {

    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      DocumentSnapshot doc = await _firestore.collection('Users').doc(firebaseUser.uid).get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        return UserModel(
          id: firebaseUser.uid,
          fullName: data['fullName'],
          email: data['email'],
          role: data['role'],
          documentType: data['documentType'],
          documentNumber: data['documentNumber'],
        );
      } else {
        throw Exception("Datos de usuario no encontrados");
      }
    } else {
      throw Exception("Error al iniciar sesión");
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser; // Devuelve el usuario actual o null si no hay ninguno
  }


  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No existe un usuario con ese correo electrónico.');
      }
      throw Exception('Error al enviar el correo de recuperación.');
    }
  }
}