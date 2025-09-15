/// Configuración de la API y entornos
class ApiConfig {
  // IP única - CAMBIAR SOLO AQUÍ
  static const String _apiHost = '192.168.1.78';
  static const String apiUrl = 'http://$_apiHost/festispot_api';
  
  // Tipo de entorno
  static const ApiEnvironment environment = ApiEnvironment.production;
  
  // Configuraciones por entorno - Una sola API
  static const Map<ApiEnvironment, String> _baseUrls = {
    ApiEnvironment.production: apiUrl, // API única
    ApiEnvironment.testing: apiUrl,    // Misma API
  };
  
  // URL base actual según el entorno
  static String get baseUrl => _baseUrls[environment]!;
  
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
  
  // Variable para cambio dinámico de entorno (para testing)
  static ApiEnvironment _currentEnvironment = environment;
  
  /// Cambia el entorno dinámicamente
  static void setEnvironment(ApiEnvironment env) {
    _currentEnvironment = env;
    print('🔄 Entorno cambiado a: ${env.displayName}');
    print('🌐 Nueva URL: ${_baseUrls[env]}');
  }
  
  /// Obtiene el entorno actual (puede haber cambiado dinámicamente)
  static ApiEnvironment get currentEnvironment => _currentEnvironment;
  
  /// Obtiene la URL base del entorno actual
  static String get currentBaseUrl => _baseUrls[_currentEnvironment]!;
  
  /// URLs específicas basadas en el entorno actual
  static String get currentAuthUrl => '$currentBaseUrl/api/auth.php';
  static String get currentUsersUrl => '$currentBaseUrl/api/users.php';
  static String get currentEventsUrl => '$currentBaseUrl/api/get_events.php';
  static String get currentCategoriesUrl => '$currentBaseUrl/api/get_categorias.php';
  static String get currentFavoritesUrl => '$currentBaseUrl/api/get_favoritos.php';
  
  // Información del entorno actual
  static Map<String, dynamic> get environmentInfo => {
    'environment': _currentEnvironment.name,
    'baseUrl': currentBaseUrl,
    'isDebugMode': isDebugMode,
    'timeout': timeout.inSeconds,
  };
  
  /// Obtiene todas las configuraciones disponibles
  static List<Map<String, dynamic>> get allEnvironments {
    return ApiEnvironment.values.map((env) => {
      'environment': env,
      'name': env.displayName,
      'url': _baseUrls[env],
      'isCurrent': env == _currentEnvironment,
    }).toList();
  }
}

/// Enum para los diferentes entornos - API única
enum ApiEnvironment {
  production('API Principal (10.228.2.29)'),
  testing('API de Testing (10.228.2.29)');
  
  const ApiEnvironment(this.displayName);
  final String displayName;
}

/// Configuración específica para credenciales locales (fallback)
class LocalCredentials {
  static const Map<String, Map<String, String>> users = {
    'asistente@festispot.com': {
      'password': 'asistente123',
      'tipo': 'asistente',
      'nombre': 'Usuario Asistente',
    },
    'productor@festispot.com': {
      'password': 'productor123', 
      'tipo': 'productor',
      'nombre': 'Usuario Productor',
    },
  };
  
  /// Valida credenciales locales
  static Map<String, String>? validateCredentials(String email, String password) {
    final user = users[email];
    if (user != null && user['password'] == password) {
      return user;
    }
    return null;
  }
}
