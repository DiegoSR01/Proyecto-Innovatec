import 'package:festispot/paginas/carousel_pages.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "carousel",
        routes:{
            "carousel": (context) => Inicio(),
        }
  
    );
  }
}
