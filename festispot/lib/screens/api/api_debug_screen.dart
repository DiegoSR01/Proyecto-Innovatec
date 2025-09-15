import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/usuario.dart';
import '../../config/api_config.dart';
import 'api_config_screen.dart';

class ApiDebugScreen extends StatefulWidget {
  const ApiDebugScreen({super.key});

  @override
  State<ApiDebugScreen> createState() => _ApiDebugScreenState();
}

class _ApiDebugScreenState extends State<ApiDebugScreen> {
  // URL única de la API - centralizada en ApiConfig
  static const String apiUrl = ApiConfig.apiUrl;
  
  List<Usuario> usuarios = [];
  List<dynamic> eventos = [];
  List<dynamic> categorias = [];
  List<dynamic> roles = [];
  List<dynamic> ubicaciones = [];
  List<dynamic> favoritos = [];
  List<dynamic> reviews = [];
  List<dynamic> asistencias = [];
  List<dynamic> notificaciones = [];
  List<dynamic> planesSuscripcion = [];
  List<dynamic> suscripcionesOrganizador = [];
  List<dynamic> imagenesEvento = [];
  Map<String, dynamic> configuracionUsuario = {};
  Map<String, dynamic> analytics = {};
  bool isLoading = false;
  String mensaje = '';
  String lastTestedEndpoint = '';
  
  // Método para limpiar todos los datos
  void _clearAllData() {
    usuarios.clear();
    eventos.clear();
    categorias.clear();
    roles.clear();
    ubicaciones.clear();
    favoritos.clear();
    reviews.clear();
    asistencias.clear();
    notificaciones.clear();
    planesSuscripcion.clear();
    suscripcionesOrganizador.clear();
    imagenesEvento.clear();
    configuracionUsuario.clear();
    analytics.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadUsuarios();
  }

  Future<void> _loadUsuarios() async {
    setState(() {
      isLoading = true;
      mensaje = '';
    });

    try {
      final usuariosData = await ApiService.getUsuariosFromUrl(apiUrl);
      setState(() {
        usuarios = usuariosData;
        lastTestedEndpoint = 'Usuarios';
        mensaje = 'Usuarios cargados correctamente (${usuariosData.length})';
      });
    } catch (e) {
      setState(() {
        mensaje = 'Error en API: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Pruebas para cada endpoint PHP
  Future<void> _testEndpoint(String label, Future<dynamic> Function() call) async {
    setState(() {
      isLoading = true;
      mensaje = '';
      lastTestedEndpoint = label;
      // Limpiar datos anteriores
      _clearAllData();
    });
    
    try {
      final result = await call();
      
      // Actualizar la lista correspondiente según el endpoint
      switch (label) {
        case 'Usuarios':
          if (result is List<Usuario>) {
            usuarios = result;
          }
          break;
        case 'Eventos':
          eventos = result is List ? result : [];
          break;
        case 'Categorías':
          categorias = result is List ? result : [];
          break;
        case 'Roles':
          roles = result is List ? result : [];
          break;
        case 'Ubicaciones':
          ubicaciones = result is List ? result : [];
          break;
        case 'Favoritos':
          favoritos = result is List ? result : [];
          break;
        case 'Reviews':
          reviews = result is List ? result : [];
          break;
        case 'Asistencias':
          asistencias = result is List ? result : [];
          break;
        case 'Config Usuario':
          configuracionUsuario = result is Map<String, dynamic> ? result : {};
          break;
        case 'Imágenes Evento':
          imagenesEvento = result is List ? result : [];
          break;
        case 'Analytics':
          analytics = result is Map<String, dynamic> ? result : {};
          break;
        case 'Notificaciones':
          notificaciones = result is List ? result : [];
          break;
        case 'Planes Suscripción':
          planesSuscripcion = result is List ? result : [];
          break;
        case 'Suscripciones Organizador':
          suscripcionesOrganizador = result is List ? result : [];
          break;
        default:
          break;
      }
      
      setState(() {
        if (result is List) {
          mensaje = '$label: ${result.length} resultados encontrados';
        } else if (result is Map) {
          mensaje = '$label: OK (${result.keys.length} campos)';
        } else {
          mensaje = '$label: $result';
        }
      });
    } catch (e) {
      setState(() {
        mensaje = 'Error en $label: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B2E),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'API Debug',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              'URL: $apiUrl',
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFE91E63), // Color del login en lugar de azul
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApiConfigScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1B2E),
              Color(0xFF0F1419),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Información del API
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE91E63).withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.api,
                          color: Color(0xFFE91E63),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'FestiSpot API',
                          style: TextStyle(
                            color: Color(0xFFE91E63),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '🌐 Conectado a: $apiUrl',
                      style: const TextStyle(
                        color: Color(0xFFE91E63),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Estado de carga
              if (isLoading)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: Color(0xFF00BCD4)),
                      SizedBox(height: 16),
                      Text(
                        'Cargando desde API...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),

              // Mensaje de estado
              if (mensaje.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: mensaje.startsWith('Error') 
                      ? Colors.red.withOpacity(0.2)
                      : const Color(0xFFE91E63).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: mensaje.startsWith('Error') 
                        ? Colors.red.withOpacity(0.5)
                        : const Color(0xFFE91E63).withOpacity(0.5),
                    ),
                  ),
                  child: Text(
                    mensaje,
                    style: TextStyle(
                      color: mensaje.startsWith('Error') 
                        ? Colors.red.shade300
                        : const Color(0xFF00BCD4),
                    ),
                  ),
                ),

              // RESULTADOS - Mostrar los resultados de las consultas ARRIBA de los botones
              _buildResultsSection(),

              // BOTONES DE PRUEBA - Ahora van después de los resultados

              // Botón principal de carga
              _buildTestButton(
                'Cargar Usuarios',
                Icons.people,
                _loadUsuarios,
              ),
              const SizedBox(height: 12),

              // Sección de pruebas por categorías
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2E3F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👥 Usuarios y Autenticación',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildCompactTestButton('Usuarios', Icons.people, () => _testEndpoint('Usuarios', () => ApiService.getUsuariosFromUrl(apiUrl))),
                        _buildCompactTestButton('Roles', Icons.admin_panel_settings, () => _testEndpoint('Roles', () => ApiService.getRolesFromUrl(apiUrl))),
                        _buildCompactTestButton('Config Usuario', Icons.settings_outlined, () => _testEndpoint('Config Usuario', () => ApiService.getConfiguracionesUsuarioFromUrl(apiUrl, 1))),
                      ],
                    ),
                  ],
                ),
              ),

              // Sección de eventos
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2E3F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎉 Eventos y Contenido',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildCompactTestButton('Eventos', Icons.event, () => _testEndpoint('Eventos', () => ApiService.getEventosFromUrl(apiUrl))),
                        _buildCompactTestButton('Categorías', Icons.category, () => _testEndpoint('Categorías', ApiService.getCategorias)),
                        _buildCompactTestButton('Ubicaciones', Icons.location_on, () => _testEndpoint('Ubicaciones', ApiService.getUbicaciones)),
                        _buildCompactTestButton('Imágenes', Icons.image, () => _testEndpoint('Imágenes Evento', () => ApiService.getImagenesEvento(1))),
                      ],
                    ),
                  ],
                ),
              ),

              // Sección de interacciones
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2E3F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '❤️ Interacciones y Reviews',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildCompactTestButton('Favoritos', Icons.favorite, () => _testEndpoint('Favoritos', () => ApiService.getFavoritos(1))),
                        _buildCompactTestButton('Reviews', Icons.rate_review, () => _testEndpoint('Reviews', () => ApiService.getReviews(1))),
                        _buildCompactTestButton('Asistencias', Icons.check_circle, () => _testEndpoint('Asistencias', () => ApiService.getAsistencias(1))),
                      ],
                    ),
                  ],
                ),
              ),

              // Sección de gestión
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2E3F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Gestión y Analytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildCompactTestButton('Analytics', Icons.analytics, () => _testEndpoint('Analytics', () => ApiService.getAnalyticsEvento(1))),
                        _buildCompactTestButton('Notificaciones', Icons.notifications, () => _testEndpoint('Notificaciones', () => ApiService.getNotificaciones(1))),
                        _buildCompactTestButton('Suscripciones', Icons.subscriptions, () => _testEndpoint('Planes Suscripción', ApiService.getPlanesSuscripcion)),
                        _buildCompactTestButton('Organizador', Icons.group, () => _testEndpoint('Suscripciones Organizador', () => ApiService.getSuscripcionesOrganizador(1))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsSection() {
    if (lastTestedEndpoint.isEmpty) {
      return Container(); // No mostrar nada si no hay consultas
    }

    return Column(
      children: [
        // Usuarios
        if (usuarios.isNotEmpty && lastTestedEndpoint == 'Usuarios')
          _buildDataSection('👥 Usuarios', usuarios.length, usuarios.map((u) => _buildUserCard(u)).toList()),

        // Eventos
        if (eventos.isNotEmpty && lastTestedEndpoint == 'Eventos')
          _buildDataSection('🎉 Eventos', eventos.length, eventos.take(10).map((e) => _buildEventCard(e)).toList()),

        // Categorías
        if (categorias.isNotEmpty && lastTestedEndpoint == 'Categorías')
          _buildDataSection('📂 Categorías', categorias.length, categorias.take(10).map((c) => _buildCategoryCard(c)).toList()),

        // Roles
        if (roles.isNotEmpty && lastTestedEndpoint == 'Roles')
          _buildDataSection('👤 Roles', roles.length, roles.take(10).map((r) => _buildRoleCard(r)).toList()),

        // Ubicaciones
        if (ubicaciones.isNotEmpty && lastTestedEndpoint == 'Ubicaciones')
          _buildDataSection('📍 Ubicaciones', ubicaciones.length, ubicaciones.take(10).map((u) => _buildLocationCard(u)).toList()),

        // Favoritos
        if (favoritos.isNotEmpty && lastTestedEndpoint == 'Favoritos')
          _buildDataSection('❤️ Favoritos', favoritos.length, favoritos.take(10).map((f) => _buildFavoriteCard(f)).toList()),

        // Reviews
        if (reviews.isNotEmpty && lastTestedEndpoint == 'Reviews')
          _buildDataSection('⭐ Reviews', reviews.length, reviews.take(10).map((r) => _buildReviewCard(r)).toList()),

        // Asistencias
        if (asistencias.isNotEmpty && lastTestedEndpoint == 'Asistencias')
          _buildDataSection('✅ Asistencias', asistencias.length, asistencias.take(10).map((a) => _buildAttendanceCard(a)).toList()),

        // Notificaciones
        if (notificaciones.isNotEmpty && lastTestedEndpoint == 'Notificaciones')
          _buildDataSection('🔔 Notificaciones', notificaciones.length, notificaciones.take(10).map((n) => _buildNotificationCard(n)).toList()),

        // Planes Suscripción
        if (planesSuscripcion.isNotEmpty && lastTestedEndpoint == 'Planes Suscripción')
          _buildDataSection('💳 Planes de Suscripción', planesSuscripcion.length, planesSuscripcion.take(10).map((p) => _buildSubscriptionPlanCard(p)).toList()),

        // Suscripciones Organizador
        if (suscripcionesOrganizador.isNotEmpty && lastTestedEndpoint == 'Suscripciones Organizador')
          _buildDataSection('👥 Suscripciones de Organizador', suscripcionesOrganizador.length, suscripcionesOrganizador.take(10).map((s) => _buildOrganizerSubscriptionCard(s)).toList()),

        // Imágenes Evento
        if (imagenesEvento.isNotEmpty && lastTestedEndpoint == 'Imágenes Evento')
          _buildDataSection('🖼️ Imágenes de Evento', imagenesEvento.length, imagenesEvento.take(5).map((i) => _buildImageCard(i)).toList()),

        // Configuración Usuario
        if (configuracionUsuario.isNotEmpty && lastTestedEndpoint == 'Config Usuario')
          _buildConfigSection('⚙️ Configuración de Usuario', configuracionUsuario),

        // Analytics
        if (analytics.isNotEmpty && lastTestedEndpoint == 'Analytics')
          _buildConfigSection('📊 Analytics del Evento', analytics),
      ],
    );
  }

  Widget _buildDataSection(String title, int count, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E3F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BCD4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count registros',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items,
          if (count > items.length)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '... y ${count - items.length} registros más',
                style: const TextStyle(
                  color: Color(0xFF00BCD4),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConfigSection(String title, Map<String, dynamic> config) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E3F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...config.entries.map((entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: const TextStyle(
                      color: Color(0xFF00BCD4),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Text(
                    entry.value?.toString() ?? 'null',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTestButton(String label, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactTestButton(String label, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFFE91E63), Color(0xFF9C27B0)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(Usuario usuario) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            usuario.nombre,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            usuario.email,
            style: const TextStyle(
              color: Color(0xFF00BCD4),
              fontSize: 14,
            ),
          ),
          if (usuario.telefono?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(
              'Teléfono: ${usuario.telefono}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Métodos para construir diferentes tipos de tarjetas
  Widget _buildEventCard(dynamic evento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            evento['nombre']?.toString() ?? evento['title']?.toString() ?? 'Sin nombre',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (evento['fecha'] != null || evento['date'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Fecha: ${evento['fecha'] ?? evento['date']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (evento['ubicacion'] != null || evento['location'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Ubicación: ${evento['ubicacion'] ?? evento['location']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
          if (evento['descripcion'] != null || evento['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Descripción: ${(evento['descripcion'] ?? evento['description']).toString().length > 50 ? '${(evento['descripcion'] ?? evento['description']).toString().substring(0, 50)}...' : evento['descripcion'] ?? evento['description']}',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryCard(dynamic categoria) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoria['nombre']?.toString() ?? categoria['name']?.toString() ?? 'Sin nombre',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (categoria['descripcion'] != null || categoria['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              categoria['descripcion']?.toString() ?? categoria['description']?.toString() ?? '',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (categoria['id'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'ID: ${categoria['id']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoleCard(dynamic rol) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rol['nombre']?.toString() ?? rol['name']?.toString() ?? 'Sin nombre',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (rol['descripcion'] != null || rol['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              rol['descripcion']?.toString() ?? rol['description']?.toString() ?? '',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (rol['permisos'] != null || rol['permissions'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Permisos: ${rol['permisos'] ?? rol['permissions']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationCard(dynamic ubicacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ubicacion['nombre']?.toString() ?? ubicacion['name']?.toString() ?? 'Sin nombre',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (ubicacion['direccion'] != null || ubicacion['address'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Dirección: ${ubicacion['direccion'] ?? ubicacion['address']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (ubicacion['ciudad'] != null || ubicacion['city'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Ciudad: ${ubicacion['ciudad'] ?? ubicacion['city']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(dynamic favorito) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favorito #${favorito['id'] ?? 'N/A'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (favorito['usuario_id'] != null || favorito['user_id'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Usuario: ${favorito['usuario_id'] ?? favorito['user_id']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (favorito['evento_id'] != null || favorito['event_id'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Evento: ${favorito['evento_id'] ?? favorito['event_id']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Review #${review['id'] ?? 'N/A'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (review['calificacion'] != null || review['rating'] != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00BCD4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '⭐ ${review['calificacion'] ?? review['rating']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          if (review['comentario'] != null || review['comment'] != null) ...[
            const SizedBox(height: 4),
            Text(
              '${(review['comentario'] ?? review['comment']).toString().length > 80 ? '${(review['comentario'] ?? review['comment']).toString().substring(0, 80)}...' : review['comentario'] ?? review['comment']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (review['usuario'] != null || review['user'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Usuario: ${review['usuario'] ?? review['user']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(dynamic asistencia) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Asistencia #${asistencia['id'] ?? 'N/A'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (asistencia['usuario_id'] != null || asistencia['user_id'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Usuario: ${asistencia['usuario_id'] ?? asistencia['user_id']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (asistencia['evento_id'] != null || asistencia['event_id'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Evento: ${asistencia['evento_id'] ?? asistencia['event_id']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
          if (asistencia['estado'] != null || asistencia['status'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Estado: ${asistencia['estado'] ?? asistencia['status']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationCard(dynamic notificacion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notificacion['titulo']?.toString() ?? notificacion['title']?.toString() ?? 'Notificación',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (notificacion['mensaje'] != null || notificacion['message'] != null) ...[
            const SizedBox(height: 4),
            Text(
              '${(notificacion['mensaje'] ?? notificacion['message']).toString().length > 60 ? '${(notificacion['mensaje'] ?? notificacion['message']).toString().substring(0, 60)}...' : notificacion['mensaje'] ?? notificacion['message']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (notificacion['fecha'] != null || notificacion['date'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Fecha: ${notificacion['fecha'] ?? notificacion['date']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlanCard(dynamic plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plan['nombre']?.toString() ?? plan['name']?.toString() ?? 'Plan',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (plan['precio'] != null || plan['price'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Precio: \$${plan['precio'] ?? plan['price']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (plan['duracion'] != null || plan['duration'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Duración: ${plan['duracion'] ?? plan['duration']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrganizerSubscriptionCard(dynamic suscripcion) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Suscripción #${suscripcion['id'] ?? 'N/A'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (suscripcion['organizador_id'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Organizador: ${suscripcion['organizador_id']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (suscripcion['plan'] != null || suscripcion['plan_name'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Plan: ${suscripcion['plan'] ?? suscripcion['plan_name']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageCard(dynamic imagen) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE91E63).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            imagen['nombre']?.toString() ?? imagen['name']?.toString() ?? 'Imagen',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (imagen['url'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'URL: ${imagen['url'].toString().length > 50 ? '${imagen['url'].toString().substring(0, 50)}...' : imagen['url']}',
              style: const TextStyle(
                color: Color(0xFF00BCD4),
                fontSize: 14,
              ),
            ),
          ],
          if (imagen['tipo'] != null || imagen['type'] != null) ...[
            const SizedBox(height: 4),
            Text(
              'Tipo: ${imagen['tipo'] ?? imagen['type']}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

