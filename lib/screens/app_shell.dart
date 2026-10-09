import 'package:flutter/material.dart';

import '../controllers/quake_controller.dart';
import 'felt_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});

  final QuakeController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(controller: widget.controller),
          MapScreen(controller: widget.controller),
          FeltScreen(controller: widget.controller),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = 1),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sensors), label: 'Terbaru'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Peta'),
          NavigationDestination(icon: Icon(Icons.waves), label: 'Dirasakan'),
        ],
      ),
    );
  }
}
