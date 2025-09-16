import 'package:flutter/material.dart';
import 'package:festispot/utils/eventos_carrusel.dart';
import 'package:festispot/utils/variables.dart';
import 'package:festispot/screens/productor/p_mostrar_evento.dart';

class AplicacionesCombined extends StatefulWidget {
  const AplicacionesCombined({super.key});

  @override
  State<AplicacionesCombined> createState() => _AplicacionesCombinedState();
}

class _AplicacionesCombinedState extends State<AplicacionesCombined>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Evento> _aplicacionesPendientes = [];
  List<Evento> _aplicacionesAceptadas = [];
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAplicaciones();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAplicaciones() {
    setState(() {
      _aplicacionesPendientes = carrusel.take(5).toList();
      _aplicacionesAceptadas = carrusel.take(3).toList();
    });
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF00BCD4),
          tabs: const [
            Tab(text: 'Pendientes'),
            Tab(text: 'Aceptadas'),
          ],
        ),
        actions: [
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
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña de Pendientes
          _aplicacionesPendientes.isEmpty
              ? _buildEmptyState('pendientes')
              : _buildPendientesList(),

          // Pestaña de Aceptadas
          _aplicacionesAceptadas.isEmpty
              ? _buildEmptyState('aceptadas')
              : _buildAceptadasList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String tipo) {
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
              tipo == 'pendientes'
                  ? Icons.pending_actions
                  : Icons.check_circle_outline,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay aplicaciones $tipo',
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
              tipo == 'pendientes'
                  ? 'Las aplicaciones a tus eventos aparecerán aquí para que puedas revisarlas'
                  : 'Las aplicaciones que aceptes aparecerán aquí para que puedas gestionarlas',
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

  Widget _buildPendientesList() {
    return ListView.builder(
      itemCount: _aplicacionesPendientes.length,
      itemBuilder: (context, index) {
        final evento = _aplicacionesPendientes[index];
        return _buildPendienteCard(evento);
      },
    );
  }

  Widget _buildAceptadasList() {
    return ListView.builder(
      itemCount: _aplicacionesAceptadas.length,
      itemBuilder: (context, index) {
        final evento = _aplicacionesAceptadas[index];
        return _buildAceptadaCard(evento);
      },
    );
  }

  Widget _buildPendienteCard(Evento evento) {
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
                builder: (context) => MostrarEventoProductor(carrusel: evento),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: evento.imagen.isNotEmpty
                      ? Image.asset(
                          evento.imagen,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/placeholder.png',
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
                Row(
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

  Widget _buildAceptadaCard(Evento evento) {
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
                builder: (context) => MostrarEventoProductor(carrusel: evento),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: evento.imagen.isNotEmpty
                      ? Image.asset(
                          evento.imagen,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/placeholder.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/placeholder.png',
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
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'ACEPTADA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _removeAplicacion(evento),
                  icon: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _rechazarAplicacion(Evento evento) {
    setState(() {
      _aplicacionesPendientes.removeWhere((e) => e.id == evento.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Aplicación removida'),
        backgroundColor: const Color(0xFF2D2E3F),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: const Color(0xFF00BCD4),
          onPressed: () {
            setState(() {
              _aplicacionesPendientes.add(evento);
            });
          },
        ),
      ),
    );
  }

  void _removeAplicacion(Evento evento) {
    setState(() {
      _aplicacionesAceptadas.removeWhere((e) => e.id == evento.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Aplicación removida'),
        backgroundColor: const Color(0xFF2D2E3F),
        action: SnackBarAction(
          label: 'Deshacer',
          textColor: const Color(0xFF00BCD4),
          onPressed: () {
            setState(() {
              _aplicacionesAceptadas.add(evento);
            });
          },
        ),
      ),
    );
  }
}
