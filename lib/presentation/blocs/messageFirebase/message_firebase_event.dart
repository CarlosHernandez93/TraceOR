import 'package:equatable/equatable.dart';

abstract class FirestoreEvent extends Equatable {
  const FirestoreEvent();

  @override
  List<Object?> get props => [];
}

class FirestoreStartListening extends FirestoreEvent {
  final String collectionPath;

  const FirestoreStartListening({required this.collectionPath});

  @override
  List<Object?> get props => [collectionPath];
}

class FirestoreNewDataReceived extends FirestoreEvent {
  final Map<String, dynamic> data;

  const FirestoreNewDataReceived({required this.data});

  @override
  List<Object?> get props => [data];
}