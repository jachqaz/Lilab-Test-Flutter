import 'package:flutter/material.dart';

import 'app/config/injection_container.dart' as di;
import 'app/data/datasources/native_api.g.dart';
import 'app/presentation/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Solicitar permisos de notificación
  try {
    final nativeService = NativeService();
    await nativeService.requestNotificationPermission();
  } catch (e) {
    print('Error requesting notification permission: $e');
  }

  runApp(const MyApp());
}
