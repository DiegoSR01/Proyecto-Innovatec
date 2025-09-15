import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';

  // Usuario actual en memoria
  static Usuario? _currentUser;

  /// Obtiene el usuario actual
  static Usuario? get currentUser => _currentUser;

  /// Verifica si hay un usuario autenticado
  static bool get isAuthenticated => _currentUser != null;

  /// Obtiene el ID del usuario actual
  static int? get currentUserId => _currentUser?.id;

  /// Inicia sesión con email y password
  static Future<AuthResult> login(String email, String password) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Iniciando proceso de login para: $email');
      }
      
      // Intentar login con la API
      final usuario = await ApiService.loginUsuario(email, password);
      if (usuario != null) {
        if (ApiConfig.isDebugMode) {
          print('✅ Usuario obtenido de la API:');
          print('   ID: ${usuario.id}');
          print('   Nombre: ${usuario.nombre} ${usuario.apellido}');
          print('   Email: ${usuario.email}');
          print('   Rol ID: ${usuario.rolId}');
          print('   Es Asistente: ${usuario.esAsistente}');
          print('   Es Productor: ${usuario.esProductor}');
          print('   Estado: ${usuario.estado}');
        }
        
        await _saveUser(usuario);
        _currentUser = usuario;
        return AuthResult.success(usuario, 'Login exitoso - Bienvenido ${usuario.nombre}!');
      }

      return AuthResult.error('Credenciales incorrectas');
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error durante el login: $e');
      }
      return AuthResult.error('Error durante el login: ${e.toString()}');
    }
  }

  /// Registra un nuevo usuario
  static Future<AuthResult> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    int rolId = 1, // 1=asistente por defecto
    String? telefono,
    String? fechaNacimiento,
    String? genero,
  }) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Iniciando registro de usuario: $email');
      }
      
      final nuevoUsuario = Usuario(
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
        rolId: rolId,
        telefono: telefono,
        fechaNacimiento: fechaNacimiento,
        genero: genero,
        fechaCreacion: DateTime.now(),
      );

      final success = await ApiService.registrarUsuario(nuevoUsuario);
      
      if (success) {
        if (ApiConfig.isDebugMode) {
          print('✅ Registro exitoso');
        }
        // Devolver éxito sin hacer login automático para evitar problemas
        return AuthResult.success(
          nuevoUsuario, 
          'Usuario registrado exitosamente. Ya puedes iniciar sesión.'
        );
      } else {
        return AuthResult.error('Error al registrar usuario en el servidor');
      }
    } on ApiException catch (e) {
      // Manejar errores específicos de la API
      String errorMessage = e.message;
      if (errorMessage.contains('email ya está registrado') || 
          errorMessage.contains('email already exists')) {
        errorMessage = 'Este email ya está registrado. Intenta con otro email.';
      } else if (errorMessage.contains('JSON')) {
        errorMessage = 'Error de comunicación con el servidor. Inténtalo de nuevo.';
      }
      return AuthResult.error(errorMessage);
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error durante el registro: $e');
      }
      return AuthResult.error('Error durante el registro: ${e.toString()}');
    }
  }

  /// Cierra la sesión del usuario
  static Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
  }

  /// Actualiza los datos del usuario actual
  static Future<AuthResult> updateCurrentUser(Usuario usuarioActualizado) async {
    try {
      final usuarioActualizadoDb = await ApiService.actualizarUsuario(usuarioActualizado);
      
      _currentUser = usuarioActualizadoDb;
      await _saveUser(usuarioActualizadoDb);
      return AuthResult.success(usuarioActualizadoDb, 'Usuario actualizado correctamente');
    } catch (e) {
      return AuthResult.error('Error durante la actualización: $e');
    }
  }

  /// Obtiene la información actualizada del usuario desde la BD
  static Future<AuthResult> refreshCurrentUser() async {
    try {
      if (_currentUser?.id == null) {
        return AuthResult.error('No hay usuario activo para actualizar');
      }

      final usuarioActualizado = await ApiService.obtenerUsuario(_currentUser!.id!);
      
      if (usuarioActualizado != null) {
        _currentUser = usuarioActualizado;
        await _saveUser(usuarioActualizado);
        return AuthResult.success(usuarioActualizado, 'Información del usuario actualizada');
      } else {
        return AuthResult.error('No se pudo obtener la información del usuario');
      }
    } catch (e) {
      return AuthResult.error('Error al actualizar información: $e');
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
    
    // Guardar también el ID del usuario separadamente para fácil acceso
    if (usuario.id != null) {
      await prefs.setInt(_userIdKey, usuario.id!);
    }
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
