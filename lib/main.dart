import 'package:flutter/material.dart';

import 'controllers/quake_controller.dart';
import 'screens/app_shell.dart';
import 'services/bmkg_service.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = QuakeController(BmkgService())..refresh();
  runApp(TremoraApp(controller: controller));
}

class TremoraApp extends StatelessWidget {
  const TremoraApp({super.key, required this.controller});

  final QuakeController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tremora',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: AppShell(controller: controller),
    );
  }
}
