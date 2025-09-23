import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';
import '../config/api_config.dart';

class ApiService {
  // Configuración dinámica basada en ApiConfig
  static String get baseUrl => ApiConfig.baseUrl;
  static Duration get timeout => ApiConfig.timeout;
  static Map<String, String> get headers => ApiConfig.headers;

  // Método genérico para manejar respuestas HTTP
  static dynamic _handleResponse(http.Response response) {
    if (ApiConfig.isDebugMode) {
      print('API Response [${response.statusCode}]: ${response.body}');
      print('');
    }
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        // Limpiar la respuesta para remover posibles elementos HTML
        String cleanedBody = response.body;
        
        // Remover posibles warnings o HTML al inicio/final
        cleanedBody = cleanedBody.trim();
        
        // Detectar errores de conexión específicos
        if (cleanedBody.contains('Error de conexión') || 
            cleanedBody.contains('MySQL server has gone away') ||
            cleanedBody.contains('No se puede establecer una conexión') ||
            cleanedBody.contains('Fatal error') ||
            cleanedBody.contains('Cannot redeclare') ||
            cleanedBody.contains('SQLSTATE[HY000]')) {
          
          // Esto es un error de servidor
          throw ApiException(
            'Error en el servidor. Por favor, verifica que el servidor web esté configurado correctamente.',
            500
          );
        }
        
        // Si contiene HTML, buscar el JSON válido
        if (cleanedBody.contains('<') && cleanedBody.contains('>')) {
          // Buscar el primer { o [ que indique el inicio del JSON
          int jsonStart = -1;
          for (int i = 0; i < cleanedBody.length; i++) {
            if (cleanedBody[i] == '{' || cleanedBody[i] == '[') {
              jsonStart = i;
              break;
            }
          }
          
          // Buscar el último } o ] que indique el final del JSON
          int jsonEnd = -1;
          for (int i = cleanedBody.length - 1; i >= 0; i--) {
            if (cleanedBody[i] == '}' || cleanedBody[i] == ']') {
              jsonEnd = i + 1;
              break;
            }
          }
          
          if (jsonStart != -1 && jsonEnd != -1 && jsonStart < jsonEnd) {
            cleanedBody = cleanedBody.substring(jsonStart, jsonEnd);
          } else {
            // No se encontró JSON válido en respuesta HTML
            throw ApiException(
              'Error del servidor. La respuesta contiene HTML en lugar de JSON.',
              500
            );
          }
        }
        
        final data = json.decode(cleanedBody);
        
        if (ApiConfig.isDebugMode) {
          _printFormattedResponse(response);
        }
        
        return data;
      } catch (e) {
        // Si hay error de decodificación, mostrar más información
        print('Error al decodificar JSON:');
        print('Response body: ${response.body}');
        print('Status code: ${response.statusCode}');
        print('Error: $e');
        
        // Si es un error de servidor conocido, lanzar error más descriptivo
        if (response.body.contains('Fatal error') || response.body.contains('Cannot redeclare')) {
          throw ApiException(
            'Error en el servidor: Conflicto en el código PHP. Contacta al administrador.',
            response.statusCode
          );
        }
        
        throw ApiException(
          'Error al procesar respuesta del servidor. Verifica que el servidor esté funcionando correctamente.',
          response.statusCode
        );
      }
    } else {
      throw ApiException('Error HTTP ${response.statusCode}: ${response.body}', response.statusCode);
    }
  }

  // Método para formatear y mostrar la respuesta como una consulta de base de datos
  static void _printFormattedResponse(http.Response response) {
    try {
      // Usar el mismo proceso de limpieza que en _handleResponse
      String cleanedBody = response.body.trim();
      
      if (cleanedBody.contains('<') && cleanedBody.contains('>')) {
        int jsonStart = -1;
        for (int i = 0; i < cleanedBody.length; i++) {
          if (cleanedBody[i] == '{' || cleanedBody[i] == '[') {
            jsonStart = i;
            break;
          }
        }
        
        int jsonEnd = -1;
        for (int i = cleanedBody.length - 1; i >= 0; i--) {
          if (cleanedBody[i] == '}' || cleanedBody[i] == ']') {
            jsonEnd = i + 1;
            break;
          }
        }
        
        if (jsonStart != -1 && jsonEnd != -1 && jsonStart < jsonEnd) {
          cleanedBody = cleanedBody.substring(jsonStart, jsonEnd);
        }
      }
      
      final data = json.decode(cleanedBody);
      print('═══════════════════════════════════════════════════════════════');
      print('🗃️  CONSULTA API - RESULTADO FORMATEADO');
      print('═══════════════════════════════════════════════════════════════');
      print('📡 Endpoint: ${response.request?.url ?? 'N/A'}');
      print('📊 Status: ${response.statusCode} ${_getStatusText(response.statusCode)}');
      print('⏱️  Response Time: ${DateTime.now().toString().substring(11, 19)}');
      print('───────────────────────────────────────────────────────────────');

      // Verificar si es una respuesta exitosa con datos
      if (data is Map && data.containsKey('success') && data['success'] == true && data.containsKey('data')) {
        final resultData = data['data'];
        
        if (resultData is List) {
          print('📋 Registros encontrados: ${resultData.length}');
          print('───────────────────────────────────────────────────────────────');
          
          if (resultData.isNotEmpty) {
            // Mostrar header de tabla basado en las claves del primer registro
            if (resultData[0] is Map) {
              final firstRecord = resultData[0] as Map<String, dynamic>;
              _printTableHeader(firstRecord.keys.toList());
              
              // Mostrar cada registro
              for (int i = 0; i < resultData.length; i++) {
                if (resultData[i] is Map) {
                  _printTableRow(i + 1, resultData[i] as Map<String, dynamic>);
                }
              }
            } else {
              // Si no son mapas, mostrar como lista simple
              for (int i = 0; i < resultData.length; i++) {
                print('${i + 1}. ${resultData[i]}');
              }
            }
          } else {
            print('⚠️  Sin registros para mostrar');
          }
          
        } else if (resultData is Map) {
          print('📋 Registro único encontrado');
          print('───────────────────────────────────────────────────────────────');
          _printSingleRecord(resultData as Map<String, dynamic>);
        } else {
          print('📋 Respuesta: $resultData');
        }
        
      } else if (data is List) {
        // Respuesta directa como lista
        print('📋 Registros encontrados: ${data.length}');
        print('───────────────────────────────────────────────────────────────');
        
        if (data.isNotEmpty && data[0] is Map) {
          final firstRecord = data[0] as Map<String, dynamic>;
          _printTableHeader(firstRecord.keys.toList());
          
          for (int i = 0; i < data.length; i++) {
            if (data[i] is Map) {
              _printTableRow(i + 1, data[i] as Map<String, dynamic>);
            }
          }
        }
        
      } else if (data is Map) {
        print('📋 Respuesta del servidor:');
        print('───────────────────────────────────────────────────────────────');
        _printSingleRecord(Map<String, dynamic>.from(data));
      } else {
        print('📋 Respuesta: $data');
      }
      
      print('═══════════════════════════════════════════════════════════════');
      print('');
    } catch (e) {
      print('❌ Error al formatear respuesta: $e');
      print('───────────────────────────────────────────────────────────────');
      print('Raw Response: ${response.body}');
      print('═══════════════════════════════════════════════════════════════');
      print('');
    }
  }

  static void _printTableHeader(List<String> columns) {
    final header = columns.map((col) => col.padRight(20).substring(0, 20)).join(' │ ');
    print('┌${'─' * header.length}┐');
    print('│ $header │');
    print('├${'─' * header.length}┤');
  }

  static void _printTableRow(int index, Map<String, dynamic> record) {
    final values = record.values.map((value) {
      String strValue;
      if (value == null) {
        strValue = 'NULL';
      } else if (value is String && value.length > 18) {
        strValue = '${value.substring(0, 15)}...';
      } else {
        strValue = value.toString();
      }
      return strValue.padRight(20).substring(0, 20);
    }).join(' │ ');
    
    print('│ $values │');
    
    // Añadir separador cada 5 registros para mejor legibilidad
    if (index % 5 == 0) {
      print('├${'─' * values.length}┤');
    }
  }

  static void _printSingleRecord(Map<String, dynamic> record) {
    record.forEach((key, value) {
      final displayValue = value?.toString() ?? 'NULL';
      print('$key: $displayValue');
    });
  }

  static String _getStatusText(int statusCode) {
    switch (statusCode) {
      case 200: return 'OK';
      case 201: return 'Created';
      case 400: return 'Bad Request';
      case 401: return 'Unauthorized';
      case 403: return 'Forbidden';
      case 404: return 'Not Found';
      case 500: return 'Internal Server Error';
      default: return '';
    }
  }

  // === MÉTODOS PARA AUTENTICACIÓN ===

  /// Login de usuario con email y contraseña usando auth.php
  static Future<Usuario?> loginUsuario(String email, String password) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Iniciando login: $email');
        print('📡 URL: ${ApiConfig.authUrl}');
      }
      
      final response = await http
          .post(
            Uri.parse(ApiConfig.authUrl),
            headers: headers,
            body: json.encode({
              'action': 'login',
              'email': email,
              'password': password,
            }),
          )
          .timeout(timeout);

      if (ApiConfig.isDebugMode) {
        print('📥 Respuesta de login - Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      final data = _handleResponse(response);
      
      if (ApiConfig.isDebugMode) {
        print('📋 Datos procesados del login: $data');
      }
      
      // Verificar estructura de respuesta exitosa
      if (data != null && data['success'] == true && data['user'] != null) {
        if (ApiConfig.isDebugMode) {
          print('✅ Login exitoso, creando objeto Usuario');
          print('📊 Datos del usuario: ${data['user']}');
        }
        
        // Crear usuario desde los datos de la BD
        return Usuario.fromJson(data['user']);
      } else if (data != null && data['error'] != null) {
        if (ApiConfig.isDebugMode) {
          print('❌ Error en login: ${data['error']}');
        }
        throw ApiException(data['error'].toString());
      }
      
      return null;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error en loginUsuario: $e');
      }
      if (e is ApiException) {
        rethrow; // Re-lanzar ApiException
      }
      throw ApiException('Error en login: $e');
    }
  }

  /// Registra un nuevo usuario usando auth.php
  static Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Registrando usuario: ${usuario.email}');
        print('📡 URL: ${ApiConfig.authUrl}');
        
        final dataToSend = {
          'action': 'register',
          ...usuario.toJson(),
        };
        
        print(' Datos a enviar:');
        dataToSend.forEach((key, value) {
          if (key == 'password') {
            print('   $key: [OCULTO]');
          } else {
            print('   $key: $value');
          }
        });
      }
      
      final response = await http
          .post(
            Uri.parse(ApiConfig.authUrl),
            headers: headers,
            body: json.encode({
              'action': 'register',
              ...usuario.toJson(),
            }),
          )
          .timeout(timeout);

      if (ApiConfig.isDebugMode) {
        print('📥 Código de respuesta: ${response.statusCode}');
        print('📥 Headers de respuesta: ${response.headers}');
        print('📥 Cuerpo de respuesta RAW:');
        print('═══════════════════════════════════════');
        print(response.body);
        print('═══════════════════════════════════════');
      }

      final data = _handleResponse(response);
      
      if (ApiConfig.isDebugMode) {
        print(' Datos procesados: $data');
        print('📊 Tipo de datos: ${data.runtimeType}');
        if (data is Map) {
          print('📊 Claves disponibles: ${data.keys.toList()}');
        }
      }
      
      // Verificar diferentes formatos de respuesta exitosa
      if (data is Map<String, dynamic>) {
        bool isSuccess = data['success'] == true || 
                        data['error'] == false ||
                        (data.containsKey('user_id') && data['user_id'] != null);
        
        if (ApiConfig.isDebugMode) {
          print('📊 ¿Es exitoso?: $isSuccess');
          if (!isSuccess) {
            print('❌ Motivo del fallo:');
            print('   success: ${data['success']}');
            print('   error: ${data['error']}');
            print('   user_id: ${data['user_id']}');
            print('   message: ${data['message']}');
          }
        }
        
        return isSuccess;
      }
      
      if (ApiConfig.isDebugMode) {
        print('❌ Formato de respuesta inesperado');
      }
      
      return false;
    } on SocketException catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error de conexión: $e');
      }
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
            Uri.parse('${ApiConfig.usersUrl}?action=get_all'),
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
            Uri.parse('${ApiConfig.usersUrl}?action=get_by_id&id=$id'),
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

  /// Obtiene información de un usuario por ID usando get_user.php
  static Future<Usuario?> obtenerUsuario(int userId) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Obteniendo información del usuario ID: $userId');
        print('📡 URL: ${ApiConfig.baseUrl}/get_user.php');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_user.php?id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      if (ApiConfig.isDebugMode) {
        print('📥 Respuesta obtener usuario - Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      final data = _handleResponse(response);
      
      if (data != null && data['success'] == true && data['user'] != null) {
        if (ApiConfig.isDebugMode) {
          print('✅ Usuario obtenido exitosamente');
          print('📊 Datos del usuario: ${data['user']}');
        }
        return Usuario.fromJson(data['user']);
      } else if (data != null && data['error'] != null) {
        if (ApiConfig.isDebugMode) {
          print('❌ Error obteniendo usuario: ${data['error']}');
        }
        throw ApiException(data['error'].toString());
      }
      
      return null;
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error en obtenerUsuario: $e');
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al obtener usuario: $e');
    }
  }

  /// Actualiza un usuario existente usando update_user.php
  static Future<Usuario> actualizarUsuario(Usuario usuario) async {
    try {
      // Crear JSON para actualización (solo campos necesarios)
      final updateData = {
        'id': usuario.id,
        if (usuario.nombre.isNotEmpty) 'nombre': usuario.nombre,
        if (usuario.apellido.isNotEmpty) 'apellido': usuario.apellido,
        if (usuario.email.isNotEmpty) 'email': usuario.email,
        if (usuario.telefono != null && usuario.telefono!.isNotEmpty) 'telefono': usuario.telefono,
        if (usuario.fechaNacimiento != null && usuario.fechaNacimiento!.isNotEmpty) 'fecha_nacimiento': usuario.fechaNacimiento,
        if (usuario.genero != null && usuario.genero!.isNotEmpty) 'genero': usuario.genero,
        if (usuario.avatarUrl != null && usuario.avatarUrl!.isNotEmpty) 'avatar_url': usuario.avatarUrl,
        // Incluir password solo si se está actualizando
        if (usuario.password != null && usuario.password!.isNotEmpty) 'password': usuario.password,
      };

      if (ApiConfig.isDebugMode) {
        print('Actualizando usuario con datos: $updateData');
      }

      final response = await http
          .put(
            Uri.parse('$baseUrl/api/update_user.php'),
            headers: headers,
            body: json.encode(updateData),
          )
          .timeout(timeout);

      if (ApiConfig.isDebugMode) {
        print('Respuesta del servidor: ${response.statusCode} - ${response.body}');
      }

      final data = _handleResponse(response);
      
      if (data['success'] == true && data['user'] != null) {
        return Usuario.fromJson(data['user']);
      } else {
        throw ApiException(data['error'] ?? 'Error al actualizar usuario');
      }
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('Error completo al actualizar usuario: $e');
      }
      throw ApiException('Error al actualizar usuario: $e');
    }
  }

  /// Elimina un usuario usando users.php
  static Future<bool> eliminarUsuario(int id) async {
    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.usersUrl),
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
            Uri.parse(ApiConfig.categoriesUrl),
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
      if (ApiConfig.isDebugMode) {
        print('🔄 Obteniendo favoritos del usuario: $userId');
        print('📡 URL: ${ApiConfig.favoritesUrl}?user_id=$userId');
      }

      final response = await http
          .get(
            Uri.parse('${ApiConfig.favoritesUrl}?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      if (ApiConfig.isDebugMode) {
        print('📥 Respuesta favoritos - Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      final data = _handleResponse(response);
      
      List<dynamic> favoritesList;
      if (data is List) {
        favoritesList = data;
      } else if (data is Map && data['data'] is List) {
        favoritesList = data['data'];
      } else if (data is Map && data['success'] == true && data['data'] is List) {
        favoritesList = data['data'];
      } else {
        if (ApiConfig.isDebugMode) {
          print('⚠️ Formato de respuesta inesperado para favoritos: $data');
        }
        favoritesList = [];
      }
      
      if (ApiConfig.isDebugMode) {
        print('✅ Favoritos obtenidos: ${favoritesList.length} elementos');
      }
      
      return favoritesList.cast<Map<String, dynamic>>();
    } on SocketException {
      throw ApiException('No hay conexión a internet. Verifica tu conexión de red.');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado. El servidor tardó demasiado en responder.');
    } on ApiException {
      rethrow; // Re-lanzar ApiException sin modificar
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error en getFavoritos: $e');
      }
      throw ApiException('Error al obtener favoritos. Verifica que el servidor esté funcionando.');
    }
  }

  /// Agrega o quita un evento de favoritos
  static Future<bool> toggleFavorito(int userId, int eventId) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Toggle favorito - Usuario: $userId, Evento: $eventId');
        print('📡 URL: ${ApiConfig.favoritesUrl}');
      }

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

      if (ApiConfig.isDebugMode) {
        print('📥 Respuesta toggle favorito - Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      final data = _handleResponse(response);
      
      if (data['success'] == true) {
        if (ApiConfig.isDebugMode) {
          print('✅ Toggle favorito exitoso: ${data['action']} - ${data['message']}');
        }
        return true;
      } else {
        if (ApiConfig.isDebugMode) {
          print('❌ Error en toggle favorito: ${data['error']}');
        }
        return false;
      }
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error en toggleFavorito: $e');
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al actualizar favoritos: $e');
    }
  }

  /// Elimina todos los favoritos de un usuario
  static Future<bool> clearAllFavoritos(int userId) async {
    try {
      if (ApiConfig.isDebugMode) {
        print('🔄 Eliminando todos los favoritos del usuario: $userId');
        print('📡 URL: ${ApiConfig.favoritesUrl}');
      }

      final response = await http
          .delete(
            Uri.parse('${ApiConfig.favoritesUrl}?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      if (ApiConfig.isDebugMode) {
        print('📥 Respuesta eliminar favoritos - Status: ${response.statusCode}');
        print('📥 Body: ${response.body}');
      }

      final data = _handleResponse(response);
      
      if (data['success'] == true) {
        if (ApiConfig.isDebugMode) {
          print('✅ Favoritos eliminados exitosamente');
        }
        return true;
      } else {
        if (ApiConfig.isDebugMode) {
          print('❌ Error eliminando favoritos: ${data['error']}');
        }
        return false;
      }
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      if (ApiConfig.isDebugMode) {
        print('❌ Error en clearAllFavoritos: $e');
      }
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Error al eliminar favoritos: $e');
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

  // === MÉTODOS CON URL ESPECÍFICA PARA DEBUG ===
  
  /// Obtiene usuarios desde una URL base específica
  static Future<List<Usuario>> getUsuariosFromUrl(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/users.php?action=get_all'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      List<dynamic> userList;
      if (data is List) {
        userList = data;
      } else if (data['data'] is List) {
        userList = data['data'];
      } else if (data['users'] is List) {
        userList = data['users'];
      } else {
        throw ApiException('Formato de respuesta inesperado para usuarios', response.statusCode);
      }
      
      return userList.map((json) => Usuario.fromJson(json)).toList();
    } on SocketException {
      throw ApiException('No hay conexión a internet o el servidor no está disponible');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener usuarios: $e');
    }
  }

  /// Obtiene eventos desde una URL base específica
  static Future<List<dynamic>> getEventosFromUrl(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_events.php'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data;
      } else if (data['data'] is List) {
        return data['data'];
      } else if (data['events'] is List) {
        return data['events'];
      }
      return [];
    } on SocketException {
      throw ApiException('No hay conexión a internet');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado');
    } catch (e) {
      throw ApiException('Error al obtener eventos: $e');
    }
  }

  /// Obtiene categorías desde una URL base específica
  static Future<List<Map<String, dynamic>>> getCategoriasFromUrl(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_categorias.php'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      } else if (data['categorias'] is List) {
        return data['categorias'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener categorías: $e');
    }
  }

  /// Obtiene roles desde una URL base específica
  static Future<List<Map<String, dynamic>>> getRolesFromUrl(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_roles.php'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener roles: $e');
    }
  }

  /// Obtiene ubicaciones desde una URL base específica
  static Future<List<Map<String, dynamic>>> getUbicacionesFromUrl(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_ubicaciones.php'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener ubicaciones: $e');
    }
  }

  /// Obtiene favoritos desde una URL base específica
  static Future<List<Map<String, dynamic>>> getFavoritosFromUrl(String baseUrl, int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_favoritos.php?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener favoritos: $e');
    }
  }

  /// Obtiene reviews desde una URL base específica
  static Future<List<Map<String, dynamic>>> getReviewsFromUrl(String baseUrl, int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_reviews.php?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener reviews: $e');
    }
  }

  /// Obtiene asistencias desde una URL base específica
  static Future<List<Map<String, dynamic>>> getAsistenciasFromUrl(String baseUrl, int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_asistencias.php?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener asistencias: $e');
    }
  }

  /// Obtiene analytics desde una URL base específica
  static Future<Map<String, dynamic>> getAnalyticsEventoFromUrl(String baseUrl, int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_analytics_evento.php?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is Map<String, dynamic>) {
        return data;
      } else if (data['data'] is Map<String, dynamic>) {
        return data['data'];
      }
      return {};
    } catch (e) {
      throw ApiException('Error al obtener analytics: $e');
    }
  }

  /// Obtiene notificaciones desde una URL base específica
  static Future<List<Map<String, dynamic>>> getNotificacionesFromUrl(String baseUrl, int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_notificaciones.php?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener notificaciones: $e');
    }
  }

  /// Obtiene planes de suscripción desde una URL base específica
  static Future<List<Map<String, dynamic>>> getPlanesSuscripcionFromUrl(String baseUrl) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_planes_suscripcion.php'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener planes de suscripción: $e');
    }
  }

  /// Obtiene suscripciones de organizador desde una URL base específica
  static Future<List<Map<String, dynamic>>> getSuscripcionesOrganizadorFromUrl(String baseUrl, int organizadorId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_suscripciones_organizador.php?organizador_id=$organizadorId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener suscripciones de organizador: $e');
    }
  }

  /// Obtiene configuraciones de usuario desde una URL base específica
  static Future<Map<String, dynamic>> getConfiguracionesUsuarioFromUrl(String baseUrl, int userId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_configuraciones_usuario.php?user_id=$userId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is Map<String, dynamic>) {
        return data;
      } else if (data['data'] is Map<String, dynamic>) {
        return data['data'];
      }
      return {};
    } catch (e) {
      throw ApiException('Error al obtener configuraciones de usuario: $e');
    }
  }

  /// Obtiene imágenes de evento desde una URL base específica
  static Future<List<Map<String, dynamic>>> getImagenesEventoFromUrl(String baseUrl, int eventId) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/api/get_imagenes_evento.php?event_id=$eventId'),
            headers: headers,
          )
          .timeout(timeout);

      final data = _handleResponse(response);
      
      if (data is List) {
        return data.cast<Map<String, dynamic>>();
      } else if (data['data'] is List) {
        return data['data'].cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      throw ApiException('Error al obtener imágenes de evento: $e');
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
