import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  // Usuario actual en memoria
  static Usuario? _currentUser;

  /// Obtiene el usuario actual
  static Usuario? get currentUser => _currentUser;

  /// Verifica si hay un usuario autenticado
  static bool get isAuthenticated => _currentUser != null;

  /// Inicia sesión con email y password
  static Future<AuthResult> login(String email, String password) async {
    try {
      // Primero intenta con la API
      try {
        final usuario = await ApiService.loginUsuario(email, password);
        if (usuario != null) {
          await _saveUser(usuario);
          _currentUser = usuario;
          return AuthResult.success(usuario, 'Login exitoso');
        }
      } catch (apiError) {
        // Si falla la API, usar credenciales hardcodeadas como fallback
        print('API no disponible, usando credenciales locales: $apiError');
        return await _loginLocal(email, password);
      }

      return AuthResult.error('Credenciales incorrectas');
    } catch (e) {
      return AuthResult.error('Error durante el login: $e');
    }
  }

  /// Login local como fallback (usando las credenciales de LocalCredentials)
  static Future<AuthResult> _loginLocal(String email, String password) async {
    final userCredentials = LocalCredentials.validateCredentials(email, password);
    
    if (userCredentials != null) {
      final usuario = Usuario(
        id: email == 'asistente@festispot.com' ? 1 : 2,
        nombre: userCredentials['nombre']!,
        email: email,
        password: password,
        tipo: userCredentials['tipo']!,
      );

      await _saveUser(usuario);
      _currentUser = usuario;
      return AuthResult.success(usuario, 'Login exitoso (modo local)');
    }

    return AuthResult.error('Credenciales incorrectas');
  }

  /// Registra un nuevo usuario
  static Future<AuthResult> register({
    required String nombre,
    required String email,
    required String password,
    required String tipo,
    String? telefono,
    String? fechaNacimiento,
  }) async {
    try {
      final nuevoUsuario = Usuario(
        nombre: nombre,
        email: email,
        password: password,
        tipo: tipo,
        telefono: telefono,
        fechaNacimiento: fechaNacimiento,
        fechaCreacion: DateTime.now(),
      );

      final success = await ApiService.registrarUsuario(nuevoUsuario);
      
      if (success) {
        // Después de registrar, hacer login automáticamente
        return await login(email, password);
      } else {
        return AuthResult.error('Error al registrar usuario');
      }
    } catch (e) {
      return AuthResult.error('Error durante el registro: $e');
    }
  }

  /// Cierra la sesión del usuario
  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// Actualiza los datos del usuario actual
  static Future<AuthResult> updateCurrentUser(Usuario usuarioActualizado) async {
    try {
      final success = await ApiService.actualizarUsuario(usuarioActualizado);
      
      if (success) {
        _currentUser = usuarioActualizado;
        await _saveUser(usuarioActualizado);
        return AuthResult.success(usuarioActualizado, 'Usuario actualizado correctamente');
      } else {
        return AuthResult.error('Error al actualizar usuario');
      }
    } catch (e) {
      return AuthResult.error('Error durante la actualización: $e');
    }
  }

  /// Restaura la sesión del usuario desde SharedPreferences
  static Future<bool> restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString(_userKey);
      
      if (userData != null) {
        final userJson = json.decode(userData) as Map<String, dynamic>;
        _currentUser = Usuario.fromJson(userJson);
        return true;
      }
      return false;
    } catch (e) {
      print('Error al restaurar sesión: $e');
      return false;
    }
  }

  /// Guarda el usuario en SharedPreferences
  static Future<void> _saveUser(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(usuario.toJsonSafe()));
  }

  /// Elimina la cuenta del usuario actual
  static Future<AuthResult> deleteAccount() async {
    try {
      if (_currentUser?.id != null) {
        final success = await ApiService.eliminarUsuario(_currentUser!.id!);
        
        if (success) {
          await logout();
          return AuthResult.success(null, 'Cuenta eliminada correctamente');
        } else {
          return AuthResult.error('Error al eliminar la cuenta');
        }
      } else {
        return AuthResult.error('No hay usuario para eliminar');
      }
    } catch (e) {
      return AuthResult.error('Error durante la eliminación: $e');
    }
  }
}

/// Clase para manejar los resultados de autenticación
class AuthResult {
  final bool isSuccess;
  final Usuario? user;
  final String message;

  AuthResult._(this.isSuccess, this.user, this.message);

  factory AuthResult.success(Usuario? user, String message) {
    return AuthResult._(true, user, message);
  }

  factory AuthResult.error(String message) {
    return AuthResult._(false, null, message);
  }
}

/// Extension para facilitar el uso de AuthResult
extension AuthResultExtension on AuthResult {
  /// Ejecuta una función si el resultado es exitoso
  void onSuccess(void Function(Usuario? user, String message) callback) {
    if (isSuccess) {
      callback(user, message);
    }
  }

  /// Ejecuta una función si el resultado es un error
  void onError(void Function(String message) callback) {
    if (!isSuccess) {
      callback(message);
    }
  }
}
