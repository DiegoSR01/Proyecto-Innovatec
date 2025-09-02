// Exportar constantes
export 'constants.dart';

// Exportar modelos
export 'models/api_response.dart';
export 'models/user.dart';
export 'models/event.dart';

// Exportar servicios
export 'services/api_service.dart';
export 'services/auth_service.dart';
export 'services/event_service.dart';
export 'services/user_service.dart';
export 'services/mock_api_service.dart';

// Importar servicios para uso interno
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/event_service.dart';
import 'services/user_service.dart';

// Clase principal para inicializar todos los servicios
class FestiSpotApi {
  static bool _initialized = false;
  
  // Servicios
  static final ApiService apiService = ApiService();
  static final AuthService authService = AuthService();
  static final EventService eventService = EventService();
  static final UserService userService = UserService();

  // Inicializar todos los servicios
  static Future<void> initialize({
    bool debugMode = false,
    String? baseUrl,
  }) async {
    if (_initialized) return;

    try {
      // Inicializar servicio base de API
      await apiService.initialize(debugMode: debugMode);
      
      // Inicializar servicio de autenticación
      await authService.initialize();
      
      _initialized = true;
      
      if (debugMode) {
        print('🎉 FestiSpot API inicializada exitosamente');
      }
    } catch (e) {
      if (debugMode) {
        print('❌ Error inicializando FestiSpot API: $e');
      }
      rethrow;
    }
  }

  // Verificar si la API está inicializada
  static bool get isInitialized => _initialized;

  // Verificar conectividad
  static Future<bool> checkConnectivity() async {
    return await apiService.checkConnectivity();
  }

  // Limpiar recursos
  static void dispose() {
    apiService.dispose();
    _initialized = false;
  }
}
