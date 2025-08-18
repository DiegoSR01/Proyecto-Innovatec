import 'package:festispot/paginas/pantalla_inicio.dart';
import 'package:flutter/material.dart';

class Asistentes extends StatelessWidget {
  const Asistentes({super.key}); // Add const constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "carousel",
      routes: {
        "carousel": (context) => const Inicio(), // Add const
      },
    );
  }
}

void main() => runApp(const Asistentes()); // Add const
