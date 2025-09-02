import '../constants.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'api_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  final ApiService _apiService = ApiService();

  // Obtener perfil de usuario por ID
  Future<ApiResponse<User>> getUserById(String userId) async {
    try {
      final response = await _apiService.get<User>(
        '${ApiConstants.usersEndpoint}/$userId',
        fromJson: (data) => User.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<User>.error(
        message: 'Error obteniendo usuario: $e',
      );
    }
  }

  // Obtener lista de usuarios (para administradores)
  Future<ApiResponse<List<User>>> getAllUsers({
    String? userType,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (userType != null) queryParams['userType'] = userType;
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();

      final response = await _apiService.get<List<User>>(
        ApiConstants.usersEndpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => User.fromJson(item)).toList();
          }
          return <User>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<User>>.error(
        message: 'Error obteniendo usuarios: $e',
      );
    }
  }

  // Buscar usuarios
  Future<ApiResponse<List<User>>> searchUsers({
    required String query,
    String? userType,
  }) async {
    try {
      final queryParams = <String, String>{'q': query};
      
      if (userType != null) queryParams['userType'] = userType;

      final response = await _apiService.get<List<User>>(
        '${ApiConstants.usersEndpoint}/search',
        queryParams: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => User.fromJson(item)).toList();
          }
          return <User>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<User>>.error(
        message: 'Error buscando usuarios: $e',
      );
    }
  }

  // Actualizar información del usuario (admin)
  Future<ApiResponse<User>> updateUser({
    required String userId,
    String? name,
    String? email,
    String? phone,
    String? userType,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (name != null) body['name'] = name;
      if (email != null) body['email'] = email;
      if (phone != null) body['phone'] = phone;
      if (userType != null) body['userType'] = userType;

      final response = await _apiService.put<User>(
        '${ApiConstants.usersEndpoint}/$userId',
        body: body,
        fromJson: (data) => User.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<User>.error(
        message: 'Error actualizando usuario: $e',
      );
    }
  }

  // Eliminar usuario (admin)
  Future<ApiResponse<void>> deleteUser(String userId) async {
    try {
      final response = await _apiService.delete<void>(
        '${ApiConstants.usersEndpoint}/$userId',
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error eliminando usuario: $e',
      );
    }
  }

  // Cambiar contraseña
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.put<void>(
        '${ApiConstants.usersEndpoint}/change-password',
        body: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error cambiando contraseña: $e',
      );
    }
  }

  // Solicitar restablecimiento de contraseña
  Future<ApiResponse<void>> requestPasswordReset(String email) async {
    try {
      final response = await _apiService.post<void>(
        '${ApiConstants.usersEndpoint}/request-password-reset',
        body: {'email': email},
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error solicitando restablecimiento: $e',
      );
    }
  }

  // Restablecer contraseña con token
  Future<ApiResponse<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiService.post<void>(
        '${ApiConstants.usersEndpoint}/reset-password',
        body: {
          'token': token,
          'newPassword': newPassword,
        },
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error restableciendo contraseña: $e',
      );
    }
  }

  // Verificar email
  Future<ApiResponse<void>> verifyEmail(String token) async {
    try {
      final response = await _apiService.post<void>(
        '${ApiConstants.usersEndpoint}/verify-email',
        body: {'token': token},
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error verificando email: $e',
      );
    }
  }

  // Reenviar email de verificación
  Future<ApiResponse<void>> resendVerificationEmail() async {
    try {
      final response = await _apiService.post<void>(
        '${ApiConstants.usersEndpoint}/resend-verification',
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error reenviando verificación: $e',
      );
    }
  }

  // Obtener estadísticas del usuario (para productores)
  Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    try {
      final response = await _apiService.get<Map<String, dynamic>>(
        '${ApiConstants.usersEndpoint}/stats',
        fromJson: (data) => data as Map<String, dynamic>,
      );

      return response;
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>.error(
        message: 'Error obteniendo estadísticas: $e',
      );
    }
  }
}
