import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/app/data/datasources/native_api.g.dart',
  kotlinOut: 'android/app/src/main/kotlin/com/example/lilab_test_flutter/NativeApi.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.example.lilab_test_flutter'),
  swiftOut: 'ios/Runner/NativeApi.g.swift',
))

class NotificationPayload {
  final String id;
  final String titulo;
  final String mensaje;

  NotificationPayload({
    required this.id,
    required this.titulo,
    required this.mensaje,
  });
}

@HostApi()
abstract class NativeService {
  void sendLocalNotification(NotificationPayload payload);

  bool requestNotificationPermission();
}
