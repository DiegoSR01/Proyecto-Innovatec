import 'package:festispot/paginas/carousel_pages.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Add const constructor

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

void main() => runApp(const MyApp()); // Add const
