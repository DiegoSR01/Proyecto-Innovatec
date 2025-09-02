import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/debug/api_debug_screen.dart';
import 'utils/api/festispot_api.dart';

// Función principal que inicia la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Inicializar la API en modo debug
    await FestiSpotApi.initialize(debugMode: true);
    print('✅ FestiSpot API inicializada correctamente');
  } catch (e) {
    print('❌ Error inicializando FestiSpot API: $e');
  }
  
  runApp(const MyApp());
}

// Widget principal de la aplicación
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título de la aplicación
      title: 'FestiSpot',
      // Tema de la aplicación utilizando un esquema de color basado en un color semilla
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Pantalla inicial de la aplicación (pantalla de login)
      home: const LoginScreen(),
      // Rutas de navegación
      routes: {
        '/debug': (context) => const ApiDebugScreen(),
      },
    );
  }
}
