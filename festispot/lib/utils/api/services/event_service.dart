import '../constants.dart';
import '../models/api_response.dart';
import '../models/event.dart';
import 'api_service.dart';

class EventService {
  static final EventService _instance = EventService._internal();
  factory EventService() => _instance;
  EventService._internal();

  final ApiService _apiService = ApiService();

  // Obtener todos los eventos
  Future<ApiResponse<List<Event>>> getAllEvents({
    String? category,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (offset != null) queryParams['offset'] = offset.toString();

      final response = await _apiService.get<List<Event>>(
        ApiConstants.allEventsEndpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => Event.fromJson(item)).toList();
          }
          return <Event>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<Event>>.error(
        message: 'Error obteniendo eventos: $e',
      );
    }
  }

  // Obtener evento por ID
  Future<ApiResponse<Event>> getEventById(String eventId) async {
    try {
      final response = await _apiService.get<Event>(
        '${ApiConstants.eventsEndpoint}/$eventId',
        fromJson: (data) => Event.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<Event>.error(
        message: 'Error obteniendo evento: $e',
      );
    }
  }

  // Crear nuevo evento
  Future<ApiResponse<Event>> createEvent({
    required String title,
    required String description,
    String? category,
    String? location,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    String? imageUrl,
    int? capacity,
  }) async {
    try {
      final body = {
        'title': title,
        'description': description,
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (date != null) 'date': date.toIso8601String(),
        if (startTime != null) 'startTime': startTime.toIso8601String(),
        if (endTime != null) 'endTime': endTime.toIso8601String(),
        if (price != null) 'price': price,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (capacity != null) 'capacity': capacity,
      };

      final response = await _apiService.post<Event>(
        ApiConstants.createEventEndpoint,
        body: body,
        fromJson: (data) => Event.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<Event>.error(
        message: 'Error creando evento: $e',
      );
    }
  }

  // Actualizar evento
  Future<ApiResponse<Event>> updateEvent({
    required String eventId,
    String? title,
    String? description,
    String? category,
    String? location,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    double? price,
    String? imageUrl,
    int? capacity,
    bool? isActive,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (category != null) body['category'] = category;
      if (location != null) body['location'] = location;
      if (date != null) body['date'] = date.toIso8601String();
      if (startTime != null) body['startTime'] = startTime.toIso8601String();
      if (endTime != null) body['endTime'] = endTime.toIso8601String();
      if (price != null) body['price'] = price;
      if (imageUrl != null) body['imageUrl'] = imageUrl;
      if (capacity != null) body['capacity'] = capacity;
      if (isActive != null) body['isActive'] = isActive;

      final response = await _apiService.put<Event>(
        '${ApiConstants.updateEventEndpoint}/$eventId',
        body: body,
        fromJson: (data) => Event.fromJson(data),
      );

      return response;
    } catch (e) {
      return ApiResponse<Event>.error(
        message: 'Error actualizando evento: $e',
      );
    }
  }

  // Eliminar evento
  Future<ApiResponse<void>> deleteEvent(String eventId) async {
    try {
      final response = await _apiService.delete<void>(
        '${ApiConstants.deleteEventEndpoint}/$eventId',
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error eliminando evento: $e',
      );
    }
  }

  // Obtener eventos del usuario actual (para productores)
  Future<ApiResponse<List<Event>>> getMyEvents() async {
    try {
      final response = await _apiService.get<List<Event>>(
        '${ApiConstants.eventsEndpoint}/my-events',
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => Event.fromJson(item)).toList();
          }
          return <Event>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<Event>>.error(
        message: 'Error obteniendo mis eventos: $e',
      );
    }
  }

  // Registrarse a un evento (para asistentes)
  Future<ApiResponse<void>> attendEvent(String eventId) async {
    try {
      final response = await _apiService.post<void>(
        '${ApiConstants.eventsEndpoint}/$eventId/attend',
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error registrándose al evento: $e',
      );
    }
  }

  // Cancelar asistencia a un evento
  Future<ApiResponse<void>> unattendEvent(String eventId) async {
    try {
      final response = await _apiService.delete<void>(
        '${ApiConstants.eventsEndpoint}/$eventId/attend',
        fromJson: null,
      );

      return response;
    } catch (e) {
      return ApiResponse<void>.error(
        message: 'Error cancelando asistencia: $e',
      );
    }
  }

  // Obtener eventos a los que el usuario está registrado
  Future<ApiResponse<List<Event>>> getAttendingEvents() async {
    try {
      final response = await _apiService.get<List<Event>>(
        '${ApiConstants.eventsEndpoint}/attending',
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => Event.fromJson(item)).toList();
          }
          return <Event>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<Event>>.error(
        message: 'Error obteniendo eventos asistiendo: $e',
      );
    }
  }

  // Buscar eventos
  Future<ApiResponse<List<Event>>> searchEvents({
    required String query,
    String? category,
    String? location,
  }) async {
    try {
      final queryParams = <String, String>{'q': query};
      
      if (category != null) queryParams['category'] = category;
      if (location != null) queryParams['location'] = location;

      final response = await _apiService.get<List<Event>>(
        '${ApiConstants.eventsEndpoint}/search',
        queryParams: queryParams,
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => Event.fromJson(item)).toList();
          }
          return <Event>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<Event>>.error(
        message: 'Error buscando eventos: $e',
      );
    }
  }

  // Obtener categorías disponibles
  Future<ApiResponse<List<String>>> getCategories() async {
    try {
      final response = await _apiService.get<List<String>>(
        '${ApiConstants.eventsEndpoint}/categories',
        fromJson: (data) {
          if (data is List) {
            return data.map((item) => item.toString()).toList();
          }
          return <String>[];
        },
      );

      return response;
    } catch (e) {
      return ApiResponse<List<String>>.error(
        message: 'Error obteniendo categorías: $e',
      );
    }
  }
}
