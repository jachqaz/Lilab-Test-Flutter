import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/app/data/datasources/native_api.g.dart',
    dartOptions: DartOptions(),
  ),
)
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
}
