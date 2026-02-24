import 'package:flutter/services.dart';

class NativeServiceIOS {
  static const MethodChannel _channel = MethodChannel(
    'dev.flutter.pigeon.social_challenge.NativeService',
  );

  static Future<bool> requestNotificationPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>(
        'requestNotificationPermission',
      );
      return result ?? false;
    } catch (e) {
      print('Error requesting permission: $e');
      return false;
    }
  }

  static Future<void> sendLocalNotification({
    required String id,
    required String titulo,
    required String mensaje,
  }) async {
    try {
      await _channel.invokeMethod('sendLocalNotification', {
        'id': id,
        'titulo': titulo,
        'mensaje': mensaje,
      });
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}
