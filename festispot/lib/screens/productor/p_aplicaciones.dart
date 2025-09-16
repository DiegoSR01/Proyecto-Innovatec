import 'package:flutter/material.dart';
import 'package:festispot/utils/eventos_carrusel.dart';
import 'package:festispot/utils/variables.dart';
import 'package:festispot/screens/productor/p_mostrar_evento.dart';

class AplicacionesPendientes extends StatefulWidget {
  const AplicacionesPendientes({super.key});

  @override
  State<AplicacionesPendientes> createState() => _AplicacionesPendientesState();
}

class _AplicacionesPendientesState extends State<AplicacionesPendientes> {
  List<Evento> _aplicacionesPendientes = [];
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _loadAplicaciones();
  }

  void _loadAplicaciones() {
    setState(() {
      _aplicacionesPendientes = carrusel
          .take(5)
          .toList(); // Ejemplo con 5 eventos
    });
  }

  void _rechazarAplicacion(Evento evento) {
    setState(() {
      _aplicacionesPendientes.removeWhere((e) => e.id == evento.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cancelaste solicitud'),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _aplicacionesPendientes.add(evento);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B2E),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Solicitudes",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_aplicacionesPendientes.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
              icon: Icon(
                _isGridView ? Icons.list : Icons.grid_view,
                color: const Color(0xFF00BCD4),
              ),
            ),
        ],
      ),
      body: _aplicacionesPendientes.isEmpty
          ? _buildEmptyState()
          : _buildAplicacionesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2E3F),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.pending_actions,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay aplicaciones pendientes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Las aplicaciones a tus eventos aparecerán aquí para que puedas revisarlas',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAplicacionCard(Evento evento) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E3F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MostrarEvento(carrusel: evento),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    evento.imagen,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'PENDIENTE',
                          style: TextStyle(
                            color: Colors.orange[800],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _rechazarAplicacion(evento),
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAplicacionesList() {
    return ListView.builder(
      itemCount: _aplicacionesPendientes.length,
      itemBuilder: (context, index) {
        final evento = _aplicacionesPendientes[index];
        return _buildAplicacionCard(evento);
      },
    );
  }
}
