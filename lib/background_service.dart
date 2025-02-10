import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:trace_or/firebase_options.dart';
import 'package:trace_or/local_notification_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
      initialNotificationTitle: 'Servicio activo',
      initialNotificationContent: 'Se inicia el servicio',
      foregroundServiceNotificationId: 1001
    )
  );
}

bool onIosBackground(ServiceInstance service) {
  return true;
}

void onStart(ServiceInstance service) async {

  if(Firebase.apps.isEmpty){
    try {
      await Firebase.initializeApp(
        name: "TraceOR",
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      return;
    }
  }

  bool isFirtsExecute = true;
  String currentNameStep = "";
  int indexStep = 0;

  FirebaseFirestore.instance
    .collection('PatientProcedure')
    .doc('orcgW0nSzUytAmdVGE2m') // Cambia al ID del documento
    .snapshots()
    .listen((snapshot) async {
      if (snapshot.exists) {
        final data = snapshot.data();
        final listProcedure = data!['procedure'] as List<dynamic>;
        final currentItemStep = listProcedure.indexWhere((item) => item['active'] == true);

        if(isFirtsExecute){
          currentNameStep = listProcedure[currentItemStep]['step'];
          indexStep = currentItemStep;
          isFirtsExecute = false;
        }

        if(currentNameStep != listProcedure[currentItemStep]['step'] && currentItemStep > indexStep) {
          currentNameStep = listProcedure[currentItemStep]['step'];
          indexStep = currentItemStep;
          await LocalNotificationService().showInstantNotification();
        }
      }
  });

  if (service is AndroidServiceInstance) {
    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
}