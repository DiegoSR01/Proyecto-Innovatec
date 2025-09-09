import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/api/api_debug_screen.dart';
import 'screens/api/api_config_screen.dart';
import 'services/auth_service.dart';

// Función principal que inicia la aplicación
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Restaurar sesión si existe
  await AuthService.restoreSession();
  
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
      // Rutas de la aplicación
      routes: {
        '/api-debug': (context) => const ApiDebugScreen(),
        '/config': (context) => const ApiConfigScreen(),
      },
    );
  }
}
