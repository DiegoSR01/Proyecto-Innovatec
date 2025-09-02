import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'mock_api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  User? _currentUser;
  bool _isLoggedIn = false;

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  // Inicializar servicio de autenticación
  Future<void> initialize() async {
    await _loadUserData();
  }

  // Cargar datos del usuario desde SharedPreferences
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(ApiConstants.isLoggedInKey) ?? false;
      
      if (_isLoggedIn) {
        final userData = prefs.getString(ApiConstants.userDataKey);
        if (userData != null) {
          final userJson = json.decode(userData);
          _currentUser = User.fromJson(userJson);
        }
      }
    } catch (e) {
      print('❌ Error cargando datos del usuario: $e');
    }
  }

  // Guardar datos del usuario
  Future<void> _saveUserData(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConstants.userDataKey, json.encode(user.toJson()));
      await prefs.setBool(ApiConstants.isLoggedInKey, true);
      _currentUser = user;
      _isLoggedIn = true;
    } catch (e) {
      print('❌ Error guardando datos del usuario: $e');
    }
  }

  // Limpiar datos del usuario
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.userDataKey);
      await prefs.remove(ApiConstants.isLoggedInKey);
      await prefs.remove(ApiConstants.tokenKey);
      await prefs.remove(ApiConstants.refreshTokenKey);
      
      _currentUser = null;
      _isLoggedIn = false;
      
      await _apiService.clearAuthToken();
    } catch (e) {
      print('❌ Error limpiando datos del usuario: $e');
    }
  }

  // Iniciar sesión
  Future<ApiResponse<User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Si el modo mock está habilitado, usar datos simulados
      if (MockApiService.isEnabled) {
        final response = await MockApiService.mockLogin(email, password);
        if (response.success && response.data != null) {
          await _saveUserData(response.data!);
          // Simular token para el mock
          await _apiService.setAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
        }
        return response;
      }

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiConstants.loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        
        // Guardar token
        if (data['token'] != null) {
          await _apiService.setAuthToken(data['token']);
        }
        
        // Guardar refresh token si existe
        if (data['refreshToken'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(ApiConstants.refreshTokenKey, data['refreshToken']);
        }
        
        // Crear y guardar usuario
        final user = User.fromJson(data['user'] ?? data);
        await _saveUserData(user);
        
        return ApiResponse<User>.success(
          message: response.message,
          data: user,
        );
      }

      return ApiResponse<User>.error(
        message: response.message,
        errors: response.errors,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<User>.error(
        message: 'Error durante el inicio de sesión: $e',
      );
    }
  }

  // Registrar usuario
  Future<ApiResponse<User>> register({
    required String email,
    required String password,
    String? name,
    String? phone,
    required String userType, // 'asistente' o 'productor'
  }) async {
    try {
      // Si el modo mock está habilitado, usar datos simulados
      if (MockApiService.isEnabled) {
        final response = await MockApiService.mockRegister(
          email: email,
          password: password,
          name: name,
          phone: phone,
          userType: userType,
        );
        if (response.success && response.data != null) {
          await _saveUserData(response.data!);
          // Simular token para el mock
          await _apiService.setAuthToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
        }
        return response;
      }

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiConstants.registerEndpoint,
        body: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
          'userType': userType,
        },
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        
        // Guardar token si se proporciona
        if (data['token'] != null) {
          await _apiService.setAuthToken(data['token']);
        }
        
        // Crear usuario
        final user = User.fromJson(data['user'] ?? data);
        
        // Si se proporciona token, guardar datos del usuario
        if (data['token'] != null) {
          await _saveUserData(user);
        }
        
        return ApiResponse<User>.success(
          message: response.message,
          data: user,
        );
      }

      return ApiResponse<User>.error(
        message: response.message,
        errors: response.errors,
        statusCode: response.statusCode,
      );
    } catch (e) {
      return ApiResponse<User>.error(
        message: 'Error durante el registro: $e',
      );
    }
  }

  // Cerrar sesión
  Future<ApiResponse<void>> logout() async {
    try {
      // Intentar cerrar sesión en el servidor
      await _apiService.post<void>(
        ApiConstants.logoutEndpoint,
        fromJson: null,
      );

      // Limpiar datos locales independientemente de la respuesta del servidor
      await _clearUserData();

      return ApiResponse<void>.success(
        message: 'Sesión cerrada exitosamente',
      );
    } catch (e) {
      // Limpiar datos locales aunque haya error en el servidor
      await _clearUserData();
      
      return ApiResponse<void>.success(
        message: 'Sesión cerrada localmente',
      );
    }
  }

  // Obtener perfil del usuario
  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _apiService.get<User>(
        ApiConstants.userProfileEndpoint,
        fromJson: (data) => User.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Actualizar datos del usuario actual
        await _saveUserData(response.data!);
      }

      return response;
    } catch (e) {
      return ApiResponse<User>.error(
        message: 'Error obteniendo perfil: $e',
      );
    }
  }

  // Actualizar perfil del usuario
  Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    String? email,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (name != null) body['name'] = name;
      if (phone != null) body['phone'] = phone;
      if (email != null) body['email'] = email;

      final response = await _apiService.put<User>(
        ApiConstants.updateUserEndpoint,
        body: body,
        fromJson: (data) => User.fromJson(data),
      );

      if (response.success && response.data != null) {
        // Actualizar datos del usuario actual
        await _saveUserData(response.data!);
      }

      return response;
    } catch (e) {
      return ApiResponse<User>.error(
        message: 'Error actualizando perfil: $e',
      );
    }
  }

  // Refrescar token de autenticación
  Future<ApiResponse<void>> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(ApiConstants.refreshTokenKey);

      if (refreshToken == null) {
        return ApiResponse<void>.error(
          message: 'No hay token de refresco disponible',
        );
      }

      final response = await _apiService.post<Map<String, dynamic>>(
        ApiConstants.refreshTokenEndpoint,
        body: {'refreshToken': refreshToken},
        fromJson: (data) => data as Map<String, dynamic>,
      );

      if (response.success && response.data != null) {
        final newToken = response.data!['token'];
        if (newToken != null) {
          await _apiService.setAuthToken(newToken);
        }
        
        // Actualizar refresh token si se proporciona uno nuevo
        final newRefreshToken = response.data!['refreshToken'];
        if (newRefreshToken != null) {
          await prefs.setString(ApiConstants.refreshTokenKey, newRefreshToken);
        }

        return ApiResponse<void>.success(
          message: 'Token actualizado exitosamente',
        );
      }

      return ApiResponse<void>.error(
        message: response.message,
      );
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error refrescando token: $e',
      );
    }
  }

  // Verificar si la sesión es válida
  Future<bool> isSessionValid() async {
    if (!_isLoggedIn || _currentUser == null) {
      return false;
    }

    try {
      final response = await getProfile();
      return response.success;
    } catch (e) {
      return false;
    }
  }
}
