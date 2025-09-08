import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../config/api_config.dart';

class ApiService {
  // Configuración dinámica basada en ApiConfig
  static String get baseUrl => ApiConfig.currentBaseUrl;
  static Duration get timeout => ApiConfig.timeout;
  static Map<String, String> get headers => ApiConfig.headers;

  // Método genérico para manejar respuestas HTTP
  static dynamic _handleResponse(http.Response response) {
    if (ApiConfig.isDebugMode) {
      print('API Response [${response.statusCode}]: ${response.body}');
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw ApiException('Error al decodificar JSON: $e', response.statusCode);
      }
    } else {
      throw ApiException('Error HTTP ${response.statusCode}: ${response.body}', response.statusCode);
    }
  }

  // === MÉTODOS PARA AUTENTICACIÓN ===

  /// Login de usuario con email y contraseña usando auth.php
  static Future<Usuario?> loginUsuario(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.currentAuthUrl),
            headers: headers,
            body: json.encode({
              'action': 'login',
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      // Adaptar respuesta según la estructura de tu API
      if (data != null && data['success'] == true && data['data'] != null) {
        return Usuario.fromJson(data['data']);
      } else if (data != null && data['error'] == false && data['user'] != null) {
        // Formato alternativo que podría usar tu API
        return Usuario.fromJson(data['user']);
      }
      return null;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error en login: $e');
    }
  }

  /// Registra un nuevo usuario usando auth.php
  static Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.currentAuthUrl),
            headers: headers,
            body: json.encode({
              'action': 'register',
              ...usuario.toJson(),
            }),
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data['success'] == true || data['error'] == false;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al registrar usuario: $e');
    }
  }

  // === MÉTODOS PARA USUARIOS ===

  /// Obtiene todos los usuarios usando users.php
  static Future<List<Usuario>> getUsuarios() async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.currentUsersUrl}?action=get_all'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      // Adaptar según la estructura de respuesta de tu API
      List<dynamic> userList;
      if (data is List) {
        userList = data;
      } else if (data['data'] is List) {
        userList = data['data'];
      } else if (data['users'] is List) {
        userList = data['users'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return userList.map((user) => Usuario.fromJson(user)).toList();
    } on SocketException {
      throw ApiException('No hay conexión a internet o el servidor no está disponible');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener usuarios: $e');
    }
  }

  /// Obtiene un usuario por ID usando users.php
  static Future<Usuario?> getUsuarioById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.currentUsersUrl}?action=get_by_id&id=$id'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data != null) {
        // Adaptar según la estructura de tu API
        if (data['data'] != null) {
          return Usuario.fromJson(data['data']);
        } else if (data['user'] != null) {
          return Usuario.fromJson(data['user']);
        } else if (data is Map<String, dynamic>) {
          return Usuario.fromJson(data);
        }
      }
      return null;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener usuario: $e');
    }
  }

  /// Actualiza un usuario existente usando users.php
  static Future<bool> actualizarUsuario(Usuario usuario) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.currentUsersUrl),
            headers: headers,
            body: json.encode({
              'action': 'update',
              ...usuario.toJson(),
            }),
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data['success'] == true || data['error'] == false;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al actualizar usuario: $e');
    }
  }

  /// Elimina un usuario usando users.php
  static Future<bool> eliminarUsuario(int id) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.currentUsersUrl),
            headers: headers,
            body: json.encode({
              'action': 'delete',
              'id': id,
            }),
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data['success'] == true || data['error'] == false;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al eliminar usuario: $e');
    }
  }

  // === MÉTODOS PARA EVENTOS ===

  /// Obtiene todos los eventos
  static Future<List<Map<String, dynamic>>> getEventos() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.eventsUrl),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> eventsList;
      if (data is List) {
        eventsList = data;
      } else if (data['data'] is List) {
        eventsList = data['data'];
      } else if (data['events'] is List) {
        eventsList = data['events'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return eventsList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener eventos: $e');
    }
  }

  /// Crea un nuevo evento
  static Future<bool> crearEvento(Map<String, dynamic> eventoData) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.eventsUrl),
            headers: headers,
            body: json.encode({
              'action': 'create',
              ...eventoData,
            }),
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data['success'] == true || data['error'] == false;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al crear evento: $e');
    }
  }

  // === MÉTODOS PARA CATEGORÍAS ===

  /// Obtiene todas las categorías
  static Future<List<Map<String, dynamic>>> getCategorias() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.currentCategoriesUrl),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> categoriesList;
      if (data is List) {
        categoriesList = data;
      } else if (data['data'] is List) {
        categoriesList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return categoriesList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener categorías: $e');
    }
  }

  // === MÉTODOS PARA FAVORITOS ===

  /// Obtiene favoritos de un usuario
  static Future<List<Map<String, dynamic>>> getFavoritos(int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.currentFavoritesUrl}?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> favoritesList;
      if (data is List) {
        favoritesList = data;
      } else if (data['data'] is List) {
        favoritesList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return favoritesList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener favoritos: $e');
    }
  }

  /// Agrega o quita un evento de favoritos
  static Future<bool> toggleFavorito(int userId, int eventId) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.favoritesUrl),
            headers: headers,
            body: json.encode({
              'action': 'toggle',
              'user_id': userId,
              'event_id': eventId,
            }),
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data['success'] == true || data['error'] == false;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al actualizar favoritos: $e');
    }
  }

  // === MÉTODOS PARA REVIEWS ===

  /// Obtiene reviews de un evento
  static Future<List<Map<String, dynamic>>> getReviews(int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.reviewsUrl}?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> reviewsList;
      if (data is List) {
        reviewsList = data;
      } else if (data['data'] is List) {
        reviewsList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return reviewsList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener reviews: $e');
    }
  }

  // === MÉTODOS PARA NOTIFICACIONES ===

  /// Obtiene notificaciones de un usuario
  static Future<List<Map<String, dynamic>>> getNotificaciones(int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.notificationsUrl}?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> notificationsList;
      if (data is List) {
        notificationsList = data;
      } else if (data['data'] is List) {
        notificationsList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return notificationsList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener notificaciones: $e');
    }
  }

  // === MÉTODOS PARA ANALYTICS ===

  /// Obtiene analytics de un evento
  static Future<Map<String, dynamic>> getAnalyticsEvento(int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.analyticsUrl}?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : {};
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener analytics: $e');
    }
  }

  // === MÉTODOS PARA OTROS ENDPOINTS ===

  /// Obtiene los planes de suscripción
  static Future<List<Map<String, dynamic>>> getPlanesSuscripcion() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.subscriptionsUrl),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> plansList;
      if (data is List) {
        plansList = data;
      } else if (data['data'] is List) {
        plansList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return plansList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener planes de suscripción: $e');
    }
  }

  /// Obtiene las configuraciones de un usuario
  static Future<Map<String, dynamic>> getConfiguracionesUsuario(int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.userConfigUrl}?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      return data is Map<String, dynamic> ? data : {};
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener configuraciones de usuario: $e');
    }
  }

  /// Obtiene las asistencias de un evento
  static Future<List<Map<String, dynamic>>> getAsistencias(int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.attendanceUrl}?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> attendanceList;
      if (data is List) {
        attendanceList = data;
      } else if (data['data'] is List) {
        attendanceList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return attendanceList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener asistencias: $e');
    }
  }

  /// Obtiene todas las ubicaciones
  static Future<List<Map<String, dynamic>>> getUbicaciones() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.locationsUrl),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> locationsList;
      if (data is List) {
        locationsList = data;
      } else if (data['data'] is List) {
        locationsList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return locationsList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener ubicaciones: $e');
    }
  }

  /// Obtiene todos los roles
  static Future<List<Map<String, dynamic>>> getRoles() async {
    try {
      final response = await http
          .get(
            Uri.parse(ApiConfig.rolesUrl),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> rolesList;
      if (data is List) {
        rolesList = data;
      } else if (data['data'] is List) {
        rolesList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return rolesList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener roles: $e');
    }
  }

  /// Obtiene las imágenes de un evento
  static Future<List<Map<String, dynamic>>> getImagenesEvento(int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.eventImagesUrl}?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> imagesList;
      if (data is List) {
        imagesList = data;
      } else if (data['data'] is List) {
        imagesList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return imagesList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener imágenes del evento: $e');
    }
  }

  /// Obtiene las suscripciones de un organizador
  static Future<List<Map<String, dynamic>>> getSuscripcionesOrganizador(int organizadorId) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.organizerSubscriptionsUrl}?organizador_id=$organizadorId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> subscriptionsList;
      if (data is List) {
        subscriptionsList = data;
      } else if (data['data'] is List) {
        subscriptionsList = data['data'];
      } else {
        throw ApiException('Formato de respuesta inesperado');
      }
      
      return subscriptionsList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener suscripciones del organizador: $e');
    }
  }

  // === MÉTODO GENÉRICO PARA OTRAS OPERACIONES ===

  /// Método genérico para hacer peticiones GET personalizadas
  static Future<dynamic> get(String endpoint, {Map<String, String>? queryParams}) async {
    try {
      Uri uri = Uri.parse('$baseUrl/$endpoint');
      if (queryParams != null) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http
          .get(uri, headers: headers)
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No hay conexión a internet');
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error en petición GET: $e');
    }
  }

  /// Método genérico para hacer peticiones POST personalizadas
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: headers,
            body: json.encode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No hay conexión a internet');
    } on TimeoutException {
      throw Exception('Tiempo de espera agotado');
    } catch (e) {
      throw Exception('Error en petición POST: $e');
    }
  }
}

/// Clase para manejar errores de la API de forma más específica
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  
  const ApiException(this.message, [this.statusCode]);
  
  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException($statusCode): $message';
    }
    return 'ApiException: $message';
  }
}
