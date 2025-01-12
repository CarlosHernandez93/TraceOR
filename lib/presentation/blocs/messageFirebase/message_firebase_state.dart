import 'package:equatable/equatable.dart';

abstract class FirestoreState extends Equatable {
  const FirestoreState();

  @override
  List<Object?> get props => [];
}

class FirestoreInitial extends FirestoreState {}

class FirestoreLoading extends FirestoreState {}

class FirestoreDataUpdated extends FirestoreState {
  final Map<String, dynamic> data;

  const FirestoreDataUpdated({required this.data});

  @override
  List<Object?> get props => [data];
}