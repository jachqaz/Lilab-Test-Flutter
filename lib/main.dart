import 'package:flutter/material.dart';

import 'app/config/injection_container.dart' as di;
import 'app/presentation/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}
