import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/api_response.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late http.Client _client;
  String? _authToken;
  bool _debugMode = false;

  // Inicializar el servicio
  Future<void> initialize({bool debugMode = false}) async {
    _client = http.Client();
    _debugMode = debugMode;
    await _loadAuthToken();
    if (_debugMode) {
      print('🚀 ApiService inicializado en modo debug');
      print('📍 Base URL: ${ApiConstants.baseUrl}');
      print('🔐 Token cargado: ${_authToken != null ? "Sí" : "No"}');
    }
  }

  // Cargar token de autenticación desde SharedPreferences
  Future<void> _loadAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _authToken = prefs.getString(ApiConstants.tokenKey);
    } catch (e) {
      if (_debugMode) print('❌ Error cargando token: $e');
    }
  }

  // Guardar token de autenticación
  Future<void> setAuthToken(String token) async {
    try {
      _authToken = token;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConstants.tokenKey, token);
      if (_debugMode) print('💾 Token guardado exitosamente');
    } catch (e) {
      if (_debugMode) print('❌ Error guardando token: $e');
    }
  }

  // Limpiar token de autenticación
  Future<void> clearAuthToken() async {
    try {
      _authToken = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.tokenKey);
      if (_debugMode) print('🗑️ Token eliminado');
    } catch (e) {
      if (_debugMode) print('❌ Error eliminando token: $e');
    }
  }

  // Obtener headers con autenticación
  Map<String, String> _getHeaders({Map<String, String>? additionalHeaders}) {
    final headers = Map<String, String>.from(ApiConstants.defaultHeaders);
    
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    return headers;
  }

  // Construir URL completa
  String _buildUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }
    return '${ApiConstants.baseUrl}$endpoint';
  }

  // Manejar respuesta HTTP
  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T? Function(dynamic)? fromJson,
  ) {
    if (_debugMode) {
      print('📤 Respuesta recibida:');
      print('   Status: ${response.statusCode}');
      print('   Headers: ${response.headers}');
      print('   Body: ${response.body}');
    }

    try {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>.fromJson(jsonData, fromJson);
      } else {
        return ApiResponse<T>.error(
          message: jsonData['message'] ?? 'Error del servidor',
          errors: jsonData['errors'],
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (_debugMode) print('❌ Error parseando respuesta: $e');
      return ApiResponse<T>.error(
        message: 'Error procesando respuesta del servidor',
        statusCode: response.statusCode,
      );
    }
  }

  // Manejar errores de conexión
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (_debugMode) print('❌ Error de conexión: $error');
    
    String message = 'Error de conexión';
    
    if (error is SocketException) {
      message = 'Sin conexión a internet';
    } else if (error is HttpException) {
      message = 'Error de servidor';
    } else if (error.toString().contains('timeout')) {
      message = 'Tiempo de espera agotado';
    }
    
    return ApiResponse<T>.error(message: message);
  }

  // Petición GET
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    T? Function(dynamic)? fromJson,
  }) async {
    try {
      String url = _buildUrl(endpoint);
      
      if (queryParams != null && queryParams.isNotEmpty) {
        final uri = Uri.parse(url);
        url = uri.replace(queryParameters: queryParams).toString();
      }

      if (_debugMode) {
        print('📡 GET Request:');
        print('   URL: $url');
        print('   Headers: ${_getHeaders()}');
      }

      final response = await _client
          .get(
            Uri.parse(url),
            headers: _getHeaders(),
          )
          .timeout(ApiConstants.requestTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Petición POST
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T? Function(dynamic)? fromJson,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final jsonBody = body != null ? json.encode(body) : null;

      if (_debugMode) {
        print('📡 POST Request:');
        print('   URL: $url');
        print('   Headers: ${_getHeaders()}');
        print('   Body: $jsonBody');
      }

      final response = await _client
          .post(
            Uri.parse(url),
            headers: _getHeaders(),
            body: jsonBody,
          )
          .timeout(ApiConstants.requestTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Petición PUT
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    T? Function(dynamic)? fromJson,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final jsonBody = body != null ? json.encode(body) : null;

      if (_debugMode) {
        print('📡 PUT Request:');
        print('   URL: $url');
        print('   Headers: ${_getHeaders()}');
        print('   Body: $jsonBody');
      }

      final response = await _client
          .put(
            Uri.parse(url),
            headers: _getHeaders(),
            body: jsonBody,
          )
          .timeout(ApiConstants.requestTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Petición DELETE
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    T? Function(dynamic)? fromJson,
  }) async {
    try {
      final url = _buildUrl(endpoint);

      if (_debugMode) {
        print('📡 DELETE Request:');
        print('   URL: $url');
        print('   Headers: ${_getHeaders()}');
      }

      final response = await _client
          .delete(
            Uri.parse(url),
            headers: _getHeaders(),
          )
          .timeout(ApiConstants.requestTimeout);

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // Verificar conectividad
  Future<bool> checkConnectivity() async {
    try {
      final response = await get('/health', fromJson: null);
      return response.success;
    } catch (e) {
      if (_debugMode) print('❌ Error verificando conectividad: $e');
      return false;
    }
  }

  // Cerrar cliente HTTP
  void dispose() {
    _client.close();
    if (_debugMode) print('🔌 ApiService desconectado');
  }
}
