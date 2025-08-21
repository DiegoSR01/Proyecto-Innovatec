import 'package:flutter/material.dart';

class SuscripcionScreenA extends StatelessWidget {
  const SuscripcionScreenA({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Suscripción',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPlanCard(
              title: 'Plan Básico',
              price: '99',
              features: [
                'Sin anuncios',
                'Acceso a eventos básicos',
                'Soporte por correo',
                'Notificaciones básicas',
              ],
              color: Colors.black,
              isRecommended: false,
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              title: 'Plan Fav',
              price: '199',
              features: [
                'Todas las ventajas del Plan Básico',
                'Guardar preferencias de eventos',
                'Agregar eventos a favoritos',
                'Soporte prioritario',
                'Notificaciones personalizadas',
                'Estadísticas básicas',
              ],
              color: Colors.black,
              isRecommended: true,
              accentColor: const Color.fromARGB(
                255,
                255,
                64,
                129,
              ), 
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              title: 'Plan Pro',
              price: '299',
              features: [
                'Todas las ventajas del Plan Fav',
                'Eventos verificados',
                'Acceso prioritario a eventos',
                'Soporte 24/7',
                'Notificaciones avanzadas',
                'Eventos ilimitados',
                'Estadísticas avanzadas',
              ],
              color: Colors.black,
              isRecommended: false,
              accentColor: const Color.fromARGB(
                255,
                255,
                193,
                7,
              ), 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required List<String> features,
    required Color color,
    required bool isRecommended,
    Color accentColor = const Color.fromARGB(
      255,
      0,
      229,
      255,
    ), // Default blue color
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRecommended ? accentColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (isRecommended)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Recomendado',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$$price ',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: '/mes',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: accentColor, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implementar lógica de suscripción
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Comenzar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
