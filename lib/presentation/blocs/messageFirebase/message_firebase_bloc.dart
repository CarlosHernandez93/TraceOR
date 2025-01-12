// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'firestore_event.dart';
// import 'firestore_state.dart';

// class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
//   final FirebaseFirestore _firestore;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

//   FirestoreBloc({
//     required FirebaseFirestore firestore,
//     required FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//   })  : _firestore = firestore,
//         _flutterLocalNotificationsPlugin = flutterLocalNotificationsPlugin,
//         super(FirestoreInitial()) {
//     on<FirestoreStartListening>(_onStartListening);
//     on<FirestoreNewDataReceived>(_onNewDataReceived);
//   }

//   void _onStartListening(
//       FirestoreStartListening event, Emitter<FirestoreState> emit) {
//     emit(FirestoreLoading());

//     _firestore.collection(event.collectionPath).snapshots().listen((snapshot) {
//       for (var doc in snapshot.docs) {
//         add(FirestoreNewDataReceived(data: doc.data()));
//       }
//     });
//   }

//   void _onNewDataReceived(
//       FirestoreNewDataReceived event, Emitter<FirestoreState> emit) {
//     emit(FirestoreDataUpdated(data: event.data));

//     Mostrar una notificación local
//     _showNotification(event.data);
//   }

//   Future<void> _showNotification(Map<String, dynamic> data) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       channelDescription: 'channel_description',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       'Actualización',
//       'Nuevo cambio detectado en Firestore',
//       notificationDetails,
//     );
//   }
// }