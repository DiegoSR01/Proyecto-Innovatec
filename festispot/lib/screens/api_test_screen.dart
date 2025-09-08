import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/usuario.dart';
import '../config/api_config.dart';
import 'api_config_screen.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  List<Usuario> usuarios = [];
  List<dynamic> eventos = [];
  List<dynamic> categorias = [];
  List<dynamic> favoritos = [];
  List<dynamic> reviews = [];
  List<dynamic> compras = [];
  bool isLoading = false;
  String mensaje = '';
  String lastTestedEndpoint = '';

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
      final usuariosData = await ApiService.getUsuarios();
      setState(() {
        usuarios = usuariosData;
        mensaje = 'Usuarios cargados correctamente (${usuariosData.length})';
      });
    } catch (e) {
      setState(() {
        mensaje = 'Error: $e';
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
        case 'Favoritos':
          favoritos = result is List ? result : [];
          break;
        case 'Reviews':
          reviews = result is List ? result : [];
          break;
        case 'Asistencias':
          compras = result is List ? result : [];
          break;
        case 'Roles':
        case 'Ubicaciones':
        case 'Config Usuario':
        case 'Imágenes Evento':
        case 'Analytics':
        case 'Notificaciones':
        case 'Planes Suscripción':
        case 'Suscripciones Organizador':
          // Estos también se pueden mostrar como datos genéricos
          if (result is List) {
            // Usar la lista de compras como genérica para otros datos
            compras = result;
          }
          break;
        default:
          // Para endpoints que no devuelven listas
          break;
      }
      
      setState(() {
        if (result is List) {
          mensaje = '$label: ${result.length} resultados';
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
              'Entorno: ${ApiConfig.currentEnvironment.displayName}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2D2E3F),
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
              ).then((_) => setState(() {})); // Refrescar al volver
            },
            tooltip: 'Configuración de API',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información del entorno actual
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
                  Text(
                    'Entorno Actual: ${ApiConfig.currentEnvironment.displayName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'URL: ${ApiConfig.baseUrl}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: ApiConfig.currentEnvironment == ApiEnvironment.production 
                          ? null 
                          : () {
                              ApiConfig.setEnvironment(ApiEnvironment.production);
                              setState(() {});
                              _showMessage('Cambiado a Producción');
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ApiConfig.currentEnvironment == ApiEnvironment.production
                            ? Colors.grey
                            : const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Producción', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: ApiConfig.currentEnvironment == ApiEnvironment.testing 
                          ? null 
                          : () {
                              ApiConfig.setEnvironment(ApiEnvironment.testing);
                              setState(() {});
                              _showMessage('Cambiado a Testing');
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ApiConfig.currentEnvironment == ApiEnvironment.testing
                            ? Colors.grey
                            : const Color(0xFFFF9800),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: const Text('Testing', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Estado de carga
            if (isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFFE91E63)),
                    SizedBox(height: 16),
                    Text(
                      'Cargando...',
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
                    : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: mensaje.startsWith('Error') 
                      ? Colors.red.withOpacity(0.5)
                      : Colors.green.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  mensaje,
                  style: TextStyle(
                    color: mensaje.startsWith('Error') 
                      ? Colors.red.shade300
                      : Colors.green.shade300,
                  ),
                ),
              ),

            // Información de configuración actual
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2E3F).withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF00BCD4).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Color(0xFF00BCD4),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Configuración API Actual:',
                        style: TextStyle(
                          color: const Color(0xFF00BCD4),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Entorno: ${ApiConfig.environment.displayName}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    'URL: ${ApiConfig.baseUrl}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                  ),
                  Text(
                    'Debug: ${ApiConfig.isDebugMode ? "Habilitado" : "Deshabilitado"}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
                  ),
                ],
              ),
            ),

            // Botones de prueba principales
            _buildTestButton(
              'Configurar API',
              Icons.settings,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApiConfigScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
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
                      _buildCompactTestButton('Usuarios', Icons.people, () => _testEndpoint('Usuarios', ApiService.getUsuarios)),
                      _buildCompactTestButton('Roles', Icons.admin_panel_settings, () => _testEndpoint('Roles', ApiService.getRoles)),
                      _buildCompactTestButton('Config Usuario', Icons.settings_outlined, () => _testEndpoint('Config Usuario', () => ApiService.getConfiguracionesUsuario(1))),
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
                      _buildCompactTestButton('Eventos', Icons.event, () => _testEndpoint('Eventos', ApiService.getEventos)),
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

            // Lista de usuarios
            if (usuarios.isNotEmpty && lastTestedEndpoint == 'Usuarios') ...[
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
                      'Usuarios en la base de datos:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...usuarios.map((usuario) => _buildUserCard(usuario)),
                  ],
                ),
              ),
            ],

            // Lista de eventos
            if (eventos.isNotEmpty && lastTestedEndpoint == 'Eventos') ...[
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
                      'Eventos en la base de datos:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...eventos.map((evento) => _buildEventCard(evento)),
                  ],
                ),
              ),
            ],

            // Lista de categorías
            if (categorias.isNotEmpty && lastTestedEndpoint == 'Categorías') ...[
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
                      'Categorías en la base de datos:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...categorias.map((categoria) => _buildCategoryCard(categoria)),
                  ],
                ),
              ),
            ],

            // Lista de favoritos
            if (favoritos.isNotEmpty && lastTestedEndpoint == 'Favoritos') ...[
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
                      'Favoritos en la base de datos:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...favoritos.map((favorito) => _buildDataCard('Favorito', favorito)),
                  ],
                ),
              ),
            ],

            // Lista de reviews
            if (reviews.isNotEmpty && lastTestedEndpoint == 'Reviews') ...[
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
                      'Reviews en la base de datos:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...reviews.map((review) => _buildDataCard('Review', review)),
                  ],
                ),
              ),
            ],

            // Lista de compras/asistencias y otros datos
            if (compras.isNotEmpty && (lastTestedEndpoint == 'Asistencias' || 
                lastTestedEndpoint == 'Roles' || 
                lastTestedEndpoint == 'Ubicaciones' || 
                lastTestedEndpoint == 'Config Usuario' ||
                lastTestedEndpoint == 'Imágenes Evento' ||
                lastTestedEndpoint == 'Analytics' ||
                lastTestedEndpoint == 'Notificaciones' ||
                lastTestedEndpoint == 'Planes Suscripción' ||
                lastTestedEndpoint == 'Suscripciones Organizador')) ...[
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
                    Text(
                      '$lastTestedEndpoint en la base de datos:',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...compras.map((item) => _buildDataCard(lastTestedEndpoint, item)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildCompactTestButton(String text, IconData icon, VoidCallback onPressed) {
    return SizedBox(
      height: 40,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E63),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(Usuario usuario) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: usuario.esProductor 
              ? const Color(0xFF9C27B0) 
              : const Color(0xFF00BCD4),
            child: Icon(
              usuario.esProductor 
                ? Icons.business 
                : Icons.person,
              color: Colors.white,
              size: 20,
            ),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  usuario.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Tipo: ${usuario.tipo}',
                  style: TextStyle(
                    color: usuario.esProductor 
                      ? const Color(0xFF9C27B0) 
                      : const Color(0xFF00BCD4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (usuario.id != null)
            Text(
              '#${usuario.id}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF2D2E3F),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildEventCard(dynamic evento) {
    final eventoMap = evento is Map<String, dynamic> ? evento : {};
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF404155),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Colors.orange,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventoMap['nombre']?.toString() ?? 'Evento sin nombre',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                if (eventoMap['descripcion'] != null)
                  Text(
                    eventoMap['descripcion'].toString(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  'Fecha: ${eventoMap['fecha_inicio']?.toString() ?? 'N/A'}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (eventoMap['precio'] != null)
                  Text(
                    'Precio: \$${eventoMap['precio']}',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          if (eventoMap['id'] != null)
            Text(
              '#${eventoMap['id']}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(dynamic categoria) {
    final categoriaMap = categoria is Map<String, dynamic> ? categoria : {};
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF404155),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Colors.purple,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoriaMap['nombre']?.toString() ?? 'Categoría sin nombre',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (categoriaMap['descripcion'] != null)
                  Text(
                    categoriaMap['descripcion'].toString(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (categoriaMap['id'] != null)
            Text(
              '#${categoriaMap['id']}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDataCard(String tipo, dynamic data) {
    final dataMap = data is Map<String, dynamic> ? data : {};
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF404155),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Colors.cyan,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$tipo ${dataMap['id']?.toString() ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Mostrar campos principales del objeto
                ...dataMap.entries.take(3).map((entry) {
                  if (entry.key != 'id') {
                    return Text(
                      '${entry.key}: ${entry.value?.toString() ?? 'N/A'}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
          if (dataMap['id'] != null)
            Text(
              '#${dataMap['id']}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}
