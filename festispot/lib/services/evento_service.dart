import '../models/evento.dart';
import 'api_service.dart';

/// Servicio para gestionar eventos desde la API
class EventoService {
  static List<Evento> _eventosCache = [];
  static bool _isLoaded = false;

  /// Obtiene los eventos desde la API y los convierte al modelo Evento
  static Future<List<Evento>> getEventos() async {
    if (_isLoaded && _eventosCache.isNotEmpty) {
      return _eventosCache;
    }

    try {
      final eventosData = await ApiService.getEventos();
      _eventosCache = eventosData.map((data) {
        return Evento(
          id: data['id'] ?? 0,
          nombre: data['titulo'] ?? 'Sin título',
          imagen: _mapImagePath(data['banner_image']),
          descripcion: data['descripcion'] ?? 'Sin descripción',
          ubicacion: data['venue_name'] ?? 'Sin ubicación',
          fechaInicio: _parseDateTime(data['fecha_inicio']),
          fechaFin: _parseDateTime(data['fecha_fin']),
          organizadorId: data['organizador_id'],
          categoriaId: data['categoria_id'],
          precio: 0.0, // Por defecto gratuito
          capacidad: data['capacidad_total'],
          estado: data['estado'] ?? 'publicado',
        );
      }).toList();
      
      _isLoaded = true;
      return _eventosCache;
    } catch (e) {
      print('Error al cargar eventos desde la API: $e');
      return [];
    }
  }

  /// Refresca el cache de eventos
  static Future<List<Evento>> refreshEventos() async {
    _isLoaded = false;
    _eventosCache.clear();
    return await getEventos();
  }

  /// Mapea la imagen del evento a la ruta de assets
  static String _mapImagePath(String? bannerImage) {
    if (bannerImage == null || bannerImage.isEmpty) {
      return 'assets/images/loading.gif';
    }
    
    // Si es una URL completa, usarla directamente
    if (bannerImage.startsWith('http')) {
      return bannerImage;
    }
    
    // Si no, mapear a assets locales
    return 'assets/images/$bannerImage';
  }

  /// Parsea fecha desde string a DateTime
  static DateTime? _parseDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    
    try {
      return DateTime.parse(dateTimeStr);
    } catch (e) {
      return null;
    }
  }
}