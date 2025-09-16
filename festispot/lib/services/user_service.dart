import '../models/usuario.dart';
import 'auth_service.dart';
import 'api_service.dart';
import 'dart:io';

/// Servicio para gestión de perfil de usuario
class UserService {
  
  /// Obtiene la información completa del usuario actual
  static Future<Usuario?> getCurrentUserProfile() async {
    final currentUser = AuthService.currentUser;
    
    if (currentUser?.id == null) {
      return null;
    }

    try {
      // Obtener información actualizada desde la BD
      final updatedUser = await ApiService.obtenerUsuario(currentUser!.id!);
      return updatedUser;
    } catch (e) {
      print('Error al obtener perfil del usuario: $e');
      // Si hay error, devolver el usuario en memoria
      return currentUser;
    }
  }

  /// Actualiza el perfil del usuario
  static Future<UserUpdateResult> updateProfile({
    String? nombre,
    String? apellido,
    String? telefono,
    String? fechaNacimiento,
    String? genero,
  }) async {
    try {
      final currentUser = AuthService.currentUser;
      
      if (currentUser == null) {
        return UserUpdateResult.error('No hay usuario autenticado');
      }

      // Crear usuario actualizado con los nuevos datos
      final updatedUser = currentUser.copyWith(
        nombre: nombre ?? currentUser.nombre,
        apellido: apellido ?? currentUser.apellido,
        telefono: telefono ?? currentUser.telefono,
        fechaNacimiento: fechaNacimiento ?? currentUser.fechaNacimiento,
        genero: genero ?? currentUser.genero,
        fechaActualizacion: DateTime.now(),
      );

      // Actualizar a través del AuthService que maneja la persistencia
      final authResult = await AuthService.updateCurrentUser(updatedUser);
      
      if (authResult.isSuccess) {
        return UserUpdateResult.success(authResult.user!, 'Perfil actualizado correctamente');
      } else {
        return UserUpdateResult.error(authResult.message);
      }
      
    } catch (e) {
      return UserUpdateResult.error('Error al actualizar perfil: $e');
    }
  }

  /// Cambia el email del usuario
  static Future<UserUpdateResult> changeEmail(String newEmail) async {
    try {
      final currentUser = AuthService.currentUser;
      
      if (currentUser == null) {
        return UserUpdateResult.error('No hay usuario autenticado');
      }

      final updatedUser = currentUser.copyWith(
        email: newEmail,
        emailVerificado: false, // Requerir verificación del nuevo email
        fechaActualizacion: DateTime.now(),
      );

      final authResult = await AuthService.updateCurrentUser(updatedUser);
      
      if (authResult.isSuccess) {
        return UserUpdateResult.success(
          authResult.user!, 
          'Email actualizado. Se enviará un enlace de verificación al nuevo email.'
        );
      } else {
        return UserUpdateResult.error(authResult.message);
      }
      
    } catch (e) {
      return UserUpdateResult.error('Error al cambiar email: $e');
    }
  }

  /// Cambia la contraseña del usuario
  static Future<UserUpdateResult> changePassword(String currentPassword, String newPassword) async {
    try {
      final currentUser = AuthService.currentUser;
      
      if (currentUser == null) {
        return UserUpdateResult.error('No hay usuario autenticado');
      }

      // Primero verificar la contraseña actual haciendo login
      final loginResult = await AuthService.login(currentUser.email, currentPassword);
      
      if (!loginResult.isSuccess) {
        return UserUpdateResult.error('Contraseña actual incorrecta');
      }

      // Si la verificación es exitosa, actualizar la contraseña
      final updatedUser = currentUser.copyWith(
        password: newPassword,
        fechaActualizacion: DateTime.now(),
      );

      final authResult = await AuthService.updateCurrentUser(updatedUser);
      
      if (authResult.isSuccess) {
        return UserUpdateResult.success(
          authResult.user!, 
          'Contraseña actualizada correctamente'
        );
      } else {
        return UserUpdateResult.error(authResult.message);
      }
      
    } catch (e) {
      return UserUpdateResult.error('Error al cambiar contraseña: $e');
    }
  }

  /// Actualiza el avatar del usuario
  static Future<UserUpdateResult> updateAvatar(File imageFile) async {
    try {
      final currentUser = AuthService.currentUser;
      
      if (currentUser == null) {
        return UserUpdateResult.error('No hay usuario autenticado');
      }

      // Subir la imagen al servidor
      final avatarUrl = await _uploadAvatar(imageFile, currentUser.id!);
      
      if (avatarUrl == null) {
        return UserUpdateResult.error('Error al subir la imagen');
      }

      // Actualizar el usuario con la nueva URL del avatar
      final updatedUser = currentUser.copyWith(
        avatarUrl: avatarUrl,
        fechaActualizacion: DateTime.now(),
      );

      // Actualizar en la API
      final updatedUserFromApi = await ApiService.actualizarUsuario(updatedUser);
      
      // Actualizar usuario en AuthService
      await AuthService.updateCurrentUser(updatedUserFromApi);
      
      return UserUpdateResult.success(
        updatedUserFromApi,
        'Foto de perfil actualizada exitosamente'
      );
      
    } catch (e) {
      return UserUpdateResult.error('Error al actualizar avatar: $e');
    }
  }

  /// Sube la imagen del avatar al servidor
  static Future<String?> _uploadAvatar(File imageFile, int userId) async {
    try {
      // Aquí deberías implementar la subida real al servidor
      // Por ahora, simularemos una URL
      
      // En una implementación real, subirías la imagen a tu servidor
      // y devolvería la URL donde está almacenada
      
      // Ejemplo de implementación:
      /*
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('${ApiConfig.baseUrl}/upload-avatar')
      );
      
      request.fields['user_id'] = userId.toString();
      request.files.add(await http.MultipartFile.fromPath('avatar', imageFile.path));
      
      var response = await request.send();
      
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonResponse = json.decode(responseString);
        return jsonResponse['avatar_url'];
      }
      */
      
      // Por ahora, devolvemos una URL de ejemplo
      await Future.delayed(const Duration(seconds: 1)); // Simular subida
      return 'https://example.com/avatars/user_${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
    } catch (e) {
      print('Error al subir avatar: $e');
      return null;
    }
  }

  /// Refresca la información del usuario desde la BD
  static Future<UserUpdateResult> refreshUserData() async {
    try {
      final authResult = await AuthService.refreshCurrentUser();
      
      if (authResult.isSuccess) {
        return UserUpdateResult.success(
          authResult.user!, 
          'Información actualizada correctamente'
        );
      } else {
        return UserUpdateResult.error(authResult.message);
      }
      
    } catch (e) {
      return UserUpdateResult.error('Error al actualizar información: $e');
    }
  }

  /// Obtiene estadísticas del usuario (eventos asistidos, favoritos, etc.)
  static Future<UserStats> getUserStats() async {
    try {
      final currentUser = AuthService.currentUser;
      
      if (currentUser?.id == null) {
        return UserStats.empty();
      }

      // Aquí se pueden hacer llamadas a diferentes endpoints para obtener estadísticas
      // Por ahora devolvemos datos de ejemplo
      return UserStats(
        eventosAsistidos: 12,
        eventosFavoritos: 8,
        reviewsEscritas: 5,
        fechaRegistro: currentUser!.fechaRegistro ?? DateTime.now(),
      );
      
    } catch (e) {
      print('Error al obtener estadísticas del usuario: $e');
      return UserStats.empty();
    }
  }
}

/// Clase para manejar los resultados de actualización de usuario
class UserUpdateResult {
  final bool isSuccess;
  final Usuario? user;
  final String message;

  UserUpdateResult._(this.isSuccess, this.user, this.message);

  factory UserUpdateResult.success(Usuario user, String message) {
    return UserUpdateResult._(true, user, message);
  }

  factory UserUpdateResult.error(String message) {
    return UserUpdateResult._(false, null, message);
  }
}

/// Clase para estadísticas del usuario
class UserStats {
  final int eventosAsistidos;
  final int eventosFavoritos;
  final int reviewsEscritas;
  final DateTime fechaRegistro;

  const UserStats({
    required this.eventosAsistidos,
    required this.eventosFavoritos,
    required this.reviewsEscritas,
    required this.fechaRegistro,
  });

  factory UserStats.empty() {
    return UserStats(
      eventosAsistidos: 0,
      eventosFavoritos: 0,
      reviewsEscritas: 0,
      fechaRegistro: DateTime.now(),
    );
  }

  /// Obtiene el tiempo transcurrido desde el registro
  String get tiempoDesdeRegistro {
    final now = DateTime.now();
    final difference = now.difference(fechaRegistro);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'Miembro desde hace $years año${years > 1 ? 's' : ''}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'Miembro desde hace $months mes${months > 1 ? 'es' : ''}';
    } else if (difference.inDays > 0) {
      return 'Miembro desde hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
    } else {
      return 'Miembro nuevo';
    }
  }
}

/// Extension para facilitar el uso de UserUpdateResult
extension UserUpdateResultExtension on UserUpdateResult {
  /// Ejecuta una función si el resultado es exitoso
  void onSuccess(void Function(Usuario user, String message) callback) {
    if (isSuccess && user != null) {
      callback(user!, message);
    }
  }

  /// Ejecuta una función si el resultado es un error
  void onError(void Function(String message) callback) {
    if (!isSuccess) {
      callback(message);
    }
  }
}