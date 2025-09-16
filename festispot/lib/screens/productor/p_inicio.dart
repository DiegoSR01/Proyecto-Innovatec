import 'package:festispot/screens/productor/p_perfil.dart';
import 'package:festispot/screens/productor/p_explorar_eventos.dart';
import 'package:festispot/screens/productor/p_favoritos.dart';
import 'package:festispot/screens/productor/p_configuracion.dart';
import 'package:festispot/screens/productor/p_aplicaciones_combined.dart';
import 'package:festispot/utils/variables.dart';
import 'package:festispot/utils/eventos_carrusel.dart';
import 'package:festispot/screens/productor/p_mostrar_evento.dart';
import 'package:festispot/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainProductor extends StatefulWidget {
  const MainProductor({super.key});

  @override
  State<MainProductor> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainProductor> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const Inicio(),
      const ExplorarEventos(),
      const FavoritosScreen(),
      const AplicacionesCombined(),
      const ConfiguracionScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2D2E3F),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00BCD4),
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Explorar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.request_page_outlined),
              activeIcon: Icon(Icons.request_page),
              label: 'Solicitudes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Configuración',
            ),
          ],
        ),
      ),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  List<Evento> _eventos = [];
  List<Evento> _eventosFiltrados = [];
  List<Map<String, dynamic>> _categorias = [];
  bool _isLoading = true;
  String? _error;
  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Cargar eventos y categorías en paralelo
      final futures = await Future.wait([
        loadEventosFromAPI(),
        ApiService.getCategorias(),
      ]);

      final eventos = futures[0] as List<Evento>;
      final categorias = futures[1] as List<Map<String, dynamic>>;

      setState(() {
        _eventos = eventos;
        _eventosFiltrados = eventos; // Inicialmente mostrar todos
        _categorias = categorias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar datos: $e';
        _isLoading = false;
        _eventos = [];
        _eventosFiltrados = [];
        _categorias = [];
      });
    }
  }

  void _filtrarEventosPorCategoria(String? categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
      if (categoria == null) {
        _eventosFiltrados = _eventos;
      } else {
        _eventosFiltrados = _eventos.where((evento) => 
          evento.categoria.toLowerCase() == categoria.toLowerCase()
        ).toList();
      }
    });
  }

  IconData _getIconForCategory(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'conferencia':
        return Icons.mic;
      case 'seminario':
        return Icons.school;
      case 'taller':
        return Icons.handyman;
      case 'networking':
        return Icons.people_alt;
      case 'festival':
        return Icons.celebration;
      case 'evento deportivo':
        return Icons.sports_soccer;
      case 'evento cultural':
        return Icons.palette;
      case 'evento empresarial':
        return Icons.business_center;
      case 'educativo':
        return Icons.menu_book;
      case 'evento social':
        return Icons.group;
      default:
        return Icons.event;
    }
  }

  Color _getColorForCategory(int index) {
    final colors = [
      const Color(0xFF00BCD4),
      const Color(0xFF0097A7),
      const Color(0xFF4FC3F7),
      const Color(0xFF29B6F6),
      const Color(0xFF03DAC6),
      const Color(0xFF00BCD4),
      const Color(0xFF0097A7),
      const Color(0xFF4FC3F7),
      const Color(0xFF29B6F6),
      const Color(0xFF03DAC6),
      const Color(0xFF4FC3F7),
    ];
    return colors[index % colors.length];
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
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2E3F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF00BCD4),
              size: 24,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilUsuario()),
              );
            },
          ),
        ),
        title: const Text(
          "FestiSpot",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2E3F),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF00BCD4),
                size: 24,
              ),
              onPressed: () {
                // Notificaciones
              },
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFF00BCD4)),
                  SizedBox(height: 16),
                  Text(
                    'Cargando eventos...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Color(0xFF00BCD4),
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BCD4),
                        ),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estadísticas rápidas
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.event,
                      title: 'Eventos',
                      subtitle: 'Disponibles',
                      value: '${_eventos.length}',
                      color: const Color(0xFF00BCD4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.people,
                      title: 'Usuarios',
                      subtitle: 'Activos',
                      value: '1.2K',
                      color: const Color(0xFF0097A7),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.star,
                      title: 'Rating',
                      subtitle: 'Promedio',
                      value: '4.8',
                      color: const Color(0xFF4FC3F7),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Título de eventos populares
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '🔥 Eventos Populares',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Ver todos
                    },
                    child: const Text(
                      'Ver todos',
                      style: TextStyle(
                        color: Color(0xFF00BCD4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Carrusel de eventos
            CarouselSlider.builder(
              itemCount: _eventosFiltrados.length,
              itemBuilder: (context, index, realindex) {
                return CardImages(carrusel: _eventosFiltrados[index]);
              },
              options: CarouselOptions(
                height: 320,
                autoPlay: true,
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.85,
                scrollDirection: Axis.horizontal,
                autoPlayInterval: const Duration(seconds: 4),
              ),
            ),

            const SizedBox(height: 24),

            // Categorías de eventos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '🎵 Categorías',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_categoriaSeleccionada != null)
                        TextButton(
                          onPressed: () => _filtrarEventosPorCategoria(null),
                          child: const Text(
                            'Ver todas',
                            style: TextStyle(
                              color: Color(0xFF00BCD4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: _categorias.isEmpty
                        ? const Center(
                            child: Text(
                              'Cargando categorías...',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _categorias.length,
                            itemBuilder: (context, index) {
                              final categoria = _categorias[index];
                              final nombre = categoria['nombre'] ?? 'Sin nombre';
                              final isSelected = _categoriaSeleccionada == nombre;
                              
                              return _buildCategoryCard(
                                nombre,
                                _getIconForCategory(nombre),
                                isSelected ? const Color(0xFF00BCD4) : _getColorForCategory(index),
                                isSelected: isSelected,
                                onTap: () => _filtrarEventosPorCategoria(nombre),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Eventos recomendados
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '✨ Recomendados para ti',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Lista de eventos recomendados
            ..._eventosFiltrados.take(3).map((evento) => _buildRecommendedEventCard(evento)),

            const SizedBox(height: 100), // Espacio para el bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color, {bool isSelected = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: isSelected 
          ? Border.all(color: Colors.white, width: 2)
          : null,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: isSelected ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap ?? () {
            // Funcionalidad por defecto
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: isSelected ? 36 : 32),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSelected ? 13 : 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendedEventCard(Evento evento) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
            evento.copy();
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
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/images/loading.gif"),
                    image: AssetImage(evento.imagen),
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white.withOpacity(0.6), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Ciudad de México', // Placeholder
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.6), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Próximamente', // Placeholder
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Ver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardImages extends StatefulWidget {
  final Evento carrusel;
  const CardImages({super.key, required this.carrusel});

  @override
  State<CardImages> createState() => _CardImagesState();
}

class _CardImagesState extends State<CardImages> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      if (userId != null) {
        final favoritos = await ApiService.getFavoritos(userId);
        final isFavorite = favoritos.any((fav) => fav['event_id'] == widget.carrusel.id);
        
        setState(() {
          _isFavorite = isFavorite;
        });
      }
    } catch (e) {
      print('Error al verificar estado de favorito: $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debe iniciar sesión para agregar favoritos'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final success = await ApiService.toggleFavorito(userId, widget.carrusel.id);
      
      if (success) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(_isFavorite ? '¡Agregado a favoritos!' : 'Eliminado de favoritos'),
              ],
            ),
            backgroundColor: const Color(0xFF00BCD4),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar favoritos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MostrarEvento(carrusel: widget.carrusel),
                  ),
                );
              },
              child: FadeInImage(
                placeholder: const AssetImage("assets/images/loading.gif"),
                image: AssetImage(widget.carrusel.imagen),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.carrusel.nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BCD4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'POPULAR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const Text(
                        ' 4.8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Botón de favorito
            Positioned(
              top: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border, 
                    color: _isFavorite ? const Color(0xFF00BCD4) : Colors.white, 
                    size: 20
                  ),
                  onPressed: () {
                    // Agregar a favoritos
                    _toggleFavorite();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}