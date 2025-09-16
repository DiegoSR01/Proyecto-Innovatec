/// Configuración de la API
class ApiConfig {
  // IP única - CAMBIAR SOLO AQUÍ
  static const String _apiHost = '192.168.1.78';
  static const String baseUrl = 'http://$_apiHost/festispot_api';
  
  // Configuraciones adicionales
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // Headers por defecto
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'FestiSpot-Flutter-App',
  };
  
  // Configuración para desarrollo/debug
  static bool get isDebugMode => true; // Siempre habilitado para testing
  
  // URLs específicas de endpoints
  static String get authUrl => '$baseUrl/api/auth.php';
  static String get usersUrl => '$baseUrl/api/users.php';
  static String get eventsUrl => '$baseUrl/api/get_events.php';
  static String get categoriesUrl => '$baseUrl/api/get_categorias.php';
  static String get favoritesUrl => '$baseUrl/api/get_favoritos.php';
  static String get reviewsUrl => '$baseUrl/api/get_reviews.php';
  static String get notificationsUrl => '$baseUrl/api/get_notificaciones.php';
  static String get analyticsUrl => '$baseUrl/api/get_analytics_evento.php';
  static String get subscriptionsUrl => '$baseUrl/api/get_planes_suscripcion.php';
  static String get userConfigUrl => '$baseUrl/api/get_configuraciones_usuario.php';
  static String get attendanceUrl => '$baseUrl/api/get_asistencias.php';
  static String get locationsUrl => '$baseUrl/api/get_ubicaciones.php';
  static String get rolesUrl => '$baseUrl/api/get_roles.php';
  static String get eventImagesUrl => '$baseUrl/api/get_imagenes_evento.php';
  static String get organizerSubscriptionsUrl => '$baseUrl/api/get_suscripciones_organizador.php';
}


