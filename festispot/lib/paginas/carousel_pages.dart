import 'package:festispot/paginas/model_event.dart';
import 'package:festispot/paginas/detalles_event.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, // Moved here from TextStyle
        title: const Text(
          "Festispot",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), // Faltaba cerrar el AppBar
      body: Column(
        children: [
          const SizedBox(height: 30),
          CarouselSlider.builder(
            itemCount: carrusel.length,
            itemBuilder: (context, index, realindex) {
              return CardImages(carrusel: carrusel[index]);
            },
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ],
      ),
    );
  }
}

class CardImages extends StatelessWidget {
  final Evento carrusel;
  const CardImages({super.key, required this.carrusel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {},
          child: FadeInImage(
            placeholder: const AssetImage("assets/images/loading.gif"),
            image: AssetImage(carrusel.imagen),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
