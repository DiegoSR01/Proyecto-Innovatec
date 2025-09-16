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

class _ApiDebugScreenState extends State<ApiDebugScreen> with TickerProviderStateMixin {
  // URL única de la API - centralizada en ApiConfig
  static String get apiUrl => ApiConfig.baseUrl;
  
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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // Colores de la paleta roja mejorada
  static const Color primaryRed = Color(0xFFE91E63);
  static const Color darkRed = Color(0xFFC2185B);
  static const Color lightRed = Color(0xFFF8BBD9);
  static const Color accentRed = Color(0xFFAD1457);
  static const Color backgroundDark = Color(0xFF1A1B2E);
  static const Color surfaceDark = Color(0xFF2D2E3F);
  static const Color errorRed = Color(0xFFFF5252);
  static const Color successGreen = Color(0xFF4CAF50);
  
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
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut)
    );
    _loadUsuarios();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      _animationController.forward();
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
    
    _animationController.reset();
    
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
      _animationController.forward();
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
      backgroundColor: backgroundDark,
      appBar: _buildAppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              backgroundDark,
              Color(0xFF0F1419),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildApiInfoCard(),
              const SizedBox(height: 20),
              _buildStatusSection(),
              const SizedBox(height: 24),
              _buildResultsSection(),
              const SizedBox(height: 24),
              _buildMainActionButton(),
              const SizedBox(height: 24),
              _buildTestSections(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryRed, darkRed],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'API Debug Center',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'FestiSpot API Testing',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8), 
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApiConfigScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApiInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed.withOpacity(0.15), accentRed.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryRed.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.api_rounded,
                  color: primaryRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'FestiSpot API Connection',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: successGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ONLINE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: surfaceDark.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.link_rounded,
                  color: lightRed,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    apiUrl,
                    style: const TextStyle(
                      color: lightRed,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection() {
    if (!isLoading && mensaje.isEmpty) return const SizedBox.shrink();
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: Column(
        children: [
          if (isLoading) _buildLoadingIndicator(),
          if (mensaje.isNotEmpty) _buildStatusMessage(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryRed),
                ),
              ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: primaryRed.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Conectando con API...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage() {
    final isError = mensaje.startsWith('Error');
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isError 
            ? [errorRed.withOpacity(0.15), errorRed.withOpacity(0.05)]
            : [successGreen.withOpacity(0.15), successGreen.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? errorRed.withOpacity(0.3) : successGreen.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isError ? errorRed : successGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                color: isError ? errorRed : successGreen,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection() {
    if (lastTestedEndpoint.isEmpty) return const SizedBox.shrink();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          // Header de resultados
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryRed, accentRed],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.data_usage_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Resultados: $lastTestedEndpoint',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Contenido de resultados
          if (usuarios.isNotEmpty && lastTestedEndpoint == 'Usuarios')
            _buildDataSection('Usuarios', usuarios.length, usuarios.map((u) => _buildUserCard(u)).toList()),
          if (eventos.isNotEmpty && lastTestedEndpoint == 'Eventos')
            _buildDataSection('Eventos', eventos.length, eventos.take(10).map((e) => _buildGenericCard(e, 'evento')).toList()),
          if (categorias.isNotEmpty && lastTestedEndpoint == 'Categorías')
            _buildDataSection('Categorías', categorias.length, categorias.take(10).map((c) => _buildGenericCard(c, 'categoria')).toList()),
          if (roles.isNotEmpty && lastTestedEndpoint == 'Roles')
            _buildDataSection('Roles', roles.length, roles.take(10).map((r) => _buildGenericCard(r, 'rol')).toList()),
          if (ubicaciones.isNotEmpty && lastTestedEndpoint == 'Ubicaciones')
            _buildDataSection('Ubicaciones', ubicaciones.length, ubicaciones.take(10).map((u) => _buildGenericCard(u, 'ubicacion')).toList()),
          if (favoritos.isNotEmpty && lastTestedEndpoint == 'Favoritos')
            _buildDataSection('Favoritos', favoritos.length, favoritos.take(10).map((f) => _buildGenericCard(f, 'favorito')).toList()),
          if (reviews.isNotEmpty && lastTestedEndpoint == 'Reviews')
            _buildDataSection('Reviews', reviews.length, reviews.take(10).map((r) => _buildGenericCard(r, 'review')).toList()),
          if (asistencias.isNotEmpty && lastTestedEndpoint == 'Asistencias')
            _buildDataSection('Asistencias', asistencias.length, asistencias.take(10).map((a) => _buildGenericCard(a, 'asistencia')).toList()),
          if (notificaciones.isNotEmpty && lastTestedEndpoint == 'Notificaciones')
            _buildDataSection('Notificaciones', notificaciones.length, notificaciones.take(10).map((n) => _buildGenericCard(n, 'notificacion')).toList()),
          if (planesSuscripcion.isNotEmpty && lastTestedEndpoint == 'Planes Suscripción')
            _buildDataSection('Planes de Suscripción', planesSuscripcion.length, planesSuscripcion.take(10).map((p) => _buildGenericCard(p, 'plan')).toList()),
          if (suscripcionesOrganizador.isNotEmpty && lastTestedEndpoint == 'Suscripciones Organizador')
            _buildDataSection('Suscripciones de Organizador', suscripcionesOrganizador.length, suscripcionesOrganizador.take(10).map((s) => _buildGenericCard(s, 'suscripcion')).toList()),
          if (imagenesEvento.isNotEmpty && lastTestedEndpoint == 'Imágenes Evento')
            _buildDataSection('Imágenes de Evento', imagenesEvento.length, imagenesEvento.take(5).map((i) => _buildGenericCard(i, 'imagen')).toList()),
          if (configuracionUsuario.isNotEmpty && lastTestedEndpoint == 'Config Usuario')
            _buildConfigSection('Configuración de Usuario', configuracionUsuario),
          if (analytics.isNotEmpty && lastTestedEndpoint == 'Analytics')
            _buildConfigSection('Analytics del Evento', analytics),
        ],
      ),
    );
  }

  Widget _buildDataSection(String title, int count, List<Widget> items) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryRed, darkRed]),
                  borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 20),
          ...items,
          if (count > items.length) _buildMoreItemsIndicator(count - items.length),
        ],
      ),
    );
  }

  Widget _buildMoreItemsIndicator(int remaining) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed.withOpacity(0.1), accentRed.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.more_horiz_rounded, color: primaryRed.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            'y $remaining registros más',
            style: TextStyle(
              color: primaryRed.withOpacity(0.8),
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigSection(String title, Map<String, dynamic> config) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
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
          const SizedBox(height: 20),
          ...config.entries.map((entry) => _buildConfigItem(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildConfigItem(String key, dynamic value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed.withOpacity(0.1), primaryRed.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: const TextStyle(
                color: lightRed,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value?.toString() ?? 'null',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryRed, darkRed, accentRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _loadUsuarios,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh_rounded, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Cargar Usuarios',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSections() {
    return Column(
      children: [
        _buildTestSection(
          'Usuarios y Autenticación',
          Icons.people_rounded,
          [
            _buildTestButton('Usuarios', Icons.people, () => _testEndpoint('Usuarios', () => ApiService.getUsuariosFromUrl(apiUrl))),
            _buildTestButton('Roles', Icons.admin_panel_settings, () => _testEndpoint('Roles', () => ApiService.getRolesFromUrl(apiUrl))),
            _buildTestButton('Config Usuario', Icons.settings_outlined, () => _testEndpoint('Config Usuario', () => ApiService.getConfiguracionesUsuarioFromUrl(apiUrl, 1))),
          ],
        ),
        const SizedBox(height: 20),
        _buildTestSection(
          'Eventos y Contenido',
          Icons.event_rounded,
          [
            _buildTestButton('Eventos', Icons.event, () => _testEndpoint('Eventos', () => ApiService.getEventosFromUrl(apiUrl))),
            _buildTestButton('Categorías', Icons.category, () => _testEndpoint('Categorías', ApiService.getCategorias)),
            _buildTestButton('Ubicaciones', Icons.location_on, () => _testEndpoint('Ubicaciones', ApiService.getUbicaciones)),
            _buildTestButton('Imágenes', Icons.image, () => _testEndpoint('Imágenes Evento', () => ApiService.getImagenesEvento(1))),
          ],
        ),
        const SizedBox(height: 20),
        _buildTestSection(
          'Interacciones y Reviews',
          Icons.favorite_rounded,
          [
            _buildTestButton('Favoritos', Icons.favorite, () => _testEndpoint('Favoritos', () => ApiService.getFavoritos(1))),
            _buildTestButton('Reviews', Icons.rate_review, () => _testEndpoint('Reviews', () => ApiService.getReviews(1))),
            _buildTestButton('Asistencias', Icons.check_circle, () => _testEndpoint('Asistencias', () => ApiService.getAsistencias(1))),
          ],
        ),
        const SizedBox(height: 20),
        _buildTestSection(
          'Gestión y Analytics',
          Icons.analytics_rounded,
          [
            _buildTestButton('Analytics', Icons.analytics, () => _testEndpoint('Analytics', () => ApiService.getAnalyticsEvento(1))),
            _buildTestButton('Notificaciones', Icons.notifications, () => _testEndpoint('Notificaciones', () => ApiService.getNotificaciones(1))),
            _buildTestButton('Suscripciones', Icons.subscriptions, () => _testEndpoint('Planes Suscripción', ApiService.getPlanesSuscripcion)),
            _buildTestButton('Organizador', Icons.group, () => _testEndpoint('Suscripciones Organizador', () => ApiService.getSuscripcionesOrganizador(1))),
          ],
        ),
      ],
    );
  }

  Widget _buildTestSection(String title, IconData icon, List<Widget> buttons) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryRed.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryRed, darkRed]),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: buttons,
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(String label, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed.withOpacity(0.8), darkRed.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryRed.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Usuario usuario) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed.withOpacity(0.1), primaryRed.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [primaryRed, darkRed]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                    Text(
                      usuario.email,
                      style: TextStyle(
                        color: lightRed.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (usuario.telefono?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Tel: ${usuario.telefono}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGenericCard(dynamic item, String type) {
    String title = '';
    String subtitle = '';
    String detail = '';
    IconData cardIcon = Icons.info;
    
    // Determinar el contenido basado en el tipo
    switch (type) {
      case 'evento':
        title = item['nombre']?.toString() ?? item['title']?.toString() ?? 'Evento sin nombre';
        subtitle = item['fecha']?.toString() ?? item['date']?.toString() ?? '';
        detail = item['ubicacion']?.toString() ?? item['location']?.toString() ?? '';
        cardIcon = Icons.event;
        break;
      case 'categoria':
        title = item['nombre']?.toString() ?? item['name']?.toString() ?? 'Categoría';
        subtitle = item['descripcion']?.toString() ?? item['description']?.toString() ?? '';
        detail = 'ID: ${item['id'] ?? 'N/A'}';
        cardIcon = Icons.category;
        break;
      case 'rol':
        title = item['nombre']?.toString() ?? item['name']?.toString() ?? 'Rol';
        subtitle = item['descripcion']?.toString() ?? item['description']?.toString() ?? '';
        detail = item['permisos']?.toString() ?? item['permissions']?.toString() ?? '';
        cardIcon = Icons.admin_panel_settings;
        break;
      case 'ubicacion':
        title = item['nombre']?.toString() ?? item['name']?.toString() ?? 'Ubicación';
        subtitle = item['direccion']?.toString() ?? item['address']?.toString() ?? '';
        detail = item['ciudad']?.toString() ?? item['city']?.toString() ?? '';
        cardIcon = Icons.location_on;
        break;
      case 'favorito':
        title = 'Favorito #${item['id'] ?? 'N/A'}';
        subtitle = 'Usuario: ${item['usuario_id'] ?? item['user_id'] ?? 'N/A'}';
        detail = 'Evento: ${item['evento_id'] ?? item['event_id'] ?? 'N/A'}';
        cardIcon = Icons.favorite;
        break;
      case 'review':
        title = 'Review #${item['id'] ?? 'N/A'}';
        subtitle = item['comentario']?.toString() ?? item['comment']?.toString() ?? 'Sin comentario';
        detail = 'Calificación: ${item['calificacion'] ?? item['rating'] ?? 'N/A'}⭐';
        cardIcon = Icons.rate_review;
        break;
      case 'asistencia':
        title = 'Asistencia #${item['id'] ?? 'N/A'}';
        subtitle = 'Usuario: ${item['usuario_id'] ?? item['user_id'] ?? 'N/A'}';
        detail = 'Estado: ${item['estado'] ?? item['status'] ?? 'N/A'}';
        cardIcon = Icons.check_circle;
        break;
      case 'notificacion':
        title = item['titulo']?.toString() ?? item['title']?.toString() ?? 'Notificación';
        subtitle = item['mensaje']?.toString() ?? item['message']?.toString() ?? '';
        detail = item['fecha']?.toString() ?? item['date']?.toString() ?? '';
        cardIcon = Icons.notifications;
        break;
      case 'plan':
        title = item['nombre']?.toString() ?? item['name']?.toString() ?? 'Plan';
        subtitle = 'Precio: \$${item['precio'] ?? item['price'] ?? 'N/A'}';
        detail = 'Duración: ${item['duracion'] ?? item['duration'] ?? 'N/A'}';
        cardIcon = Icons.subscriptions;
        break;
      case 'suscripcion':
        title = 'Suscripción #${item['id'] ?? 'N/A'}';
        subtitle = 'Organizador: ${item['organizador_id'] ?? 'N/A'}';
        detail = 'Plan: ${item['plan'] ?? item['plan_name'] ?? 'N/A'}';
        cardIcon = Icons.group;
        break;
      case 'imagen':
        title = item['nombre']?.toString() ?? item['name']?.toString() ?? 'Imagen';
        subtitle = item['tipo']?.toString() ?? item['type']?.toString() ?? 'Tipo desconocido';
        final url = item['url']?.toString() ?? '';
        detail = url.length > 30 ? '${url.substring(0, 30)}...' : url;
        cardIcon = Icons.image;
        break;
      default:
        title = 'Elemento desconocido';
        cardIcon = Icons.help_outline;
    }

    // Truncar textos largos
    if (subtitle.length > 60) {
      subtitle = '${subtitle.substring(0, 60)}...';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryRed.withOpacity(0.1), primaryRed.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [primaryRed, darkRed]),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(cardIcon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: lightRed.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (detail.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    detail,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}