import 'package:festispot/paginas/config_perfil.dart';
import 'package:festispot/utils/model_event.dart';
import 'package:festispot/utils/eventos_carrusel.dart';
import 'package:festispot/paginas/mostrar_evento.dart';
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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle_outlined,
            color: Colors.greenAccent,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Cuenta()),
            );
          },
        ),
        title: const Text(
          "Festispot",
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar eventos...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                ),
                onChanged: (value) {
                  // Add search functionality here
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Eventos Populares',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Eventos que te podrían interesar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 30,
                ),
                onPressed: () {
                  // Add check functionality here
                },
              ),
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
                onPressed: () {
                  // Add favorite functionality here
                },
              ),
            ],
          ),
        ),
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
          onTap: () {
            carrusel.copy();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MostrarEvento(
                  carrusel: carrusel,
                ), // Navigate to MostrarEvento
              ),
            );
          },
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
