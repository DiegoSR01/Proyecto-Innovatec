import 'package:flutter/material.dart';
import 'api_debug_screen.dart';

/// Aplicación independiente para ejecutar únicamente la pantalla de debug de la API
/// 
/// Para ejecutar este archivo independientemente, usa:
/// flutter run lib/screens/api/main_debug.dart
void main() {
  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FestiSpot API Debug Tool',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const ApiDebugScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}