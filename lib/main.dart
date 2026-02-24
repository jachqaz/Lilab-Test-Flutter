import 'package:flutter/widgets.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app/config/providers/blocsProviders.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(const BlocsProviders());
}
