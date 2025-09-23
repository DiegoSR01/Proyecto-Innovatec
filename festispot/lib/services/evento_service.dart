import 'dart:convert';
import '../utils/variables.dart';
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
          imagen: _getImagePath(data),
          descripcion: data['descripcion'] ?? 'Sin descripción',
          categoria: data['category'] ?? 'General',
          ubicacion: data['venue_name'] ?? 'Sin ubicación',
          fecha: _formatDate(data['fecha_inicio']),
          hora: _formatTime(data['start_time']),
          precio: _formatPrice(data['precio']),
          capacidad: data['capacidad_total']?.toString(),
          edad: data['edad_minima']?.toString() ?? '0',
          organizador: data['organizador_nombre'] ?? 'Sin organizador',
          // Campos adicionales
          descripcionCorta: data['descripcion_corta'],
          fechaFin: _formatDate(data['fecha_fin']),
          horaFin: _formatTime(data['end_time']),
          horaAperturaPuertas: _formatTime(data['hora_apertura_puertas']),
          tipoEvento: data['event_type'],
          direccionCompleta: data['full_address'],
          ciudad: data['city'],
          estado: data['state'],
          pais: data['country'],
          codigoPostal: data['postal_code'],
          detallesUbicacion: data['location_details'],
          edadMinima: data['edad_minima'],
          politicasCancelacion: data['politicas_cancelacion'],
          instruccionesEspeciales: data['instrucciones_especiales'],
          tags: data['tags'],
          accesible: data['accessible'] == 1 || data['accessible'] == true,
          plataformaVirtual: data['virtual_platform'],
          enlaceEvento: data['event_link'],
          codigoAcceso: data['access_code'],
          passwordVirtual: data['virtual_password'],
          instruccionesVirtuales: data['virtual_instructions'],
          imagenesGaleria: data['gallery_images'],
          videos: data['videos'],
          estadoEvento: data['estado'],
          organizadorNombre: data['organizador_nombre'],
          organizadorApellido: data['organizador_apellido'],
          organizadorEmail: data['organizador_email'],
          organizadorTelefono: data['organizador_telefono'],
          // Campos de imágenes BLOB de BD
          bannerImageData: _processBlobData(data['banner_image']),
          bannerImageType: data['banner_image_type'],
          galleryImagesData: _processBlobData(data['gallery_images']),
          galleryImagesMetadata: data['gallery_images_metadata'],
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

  /// Procesa datos BLOB de la BD (puede ser base64 o binario)
  static String? _processBlobData(dynamic blobData) {
    if (blobData == null) return null;
    
    if (blobData is String) {
      // Si ya es string, verificar si es base64 válido
      if (blobData.isNotEmpty) {
        // Si no tiene prefijo data:, agregarlo basándose en el contenido
        if (!blobData.startsWith('data:image/') && _isBase64String(blobData)) {
          // Asumir que es JPEG por defecto si no se especifica
          return 'data:image/jpeg;base64,$blobData';
        }
        return blobData;
      }
    } else if (blobData is List) {
      // Si es array de bytes, convertir a base64
      try {
        final bytes = List<int>.from(blobData);
        final base64String = base64Encode(bytes);
        return 'data:image/jpeg;base64,$base64String';
      } catch (e) {
        print('Error al convertir bytes a base64: $e');
      }
    }
    
    return null;
  }

  /// Verifica si una string es base64 válida
  static bool _isBase64String(String str) {
    if (str.length % 4 != 0) return false;
    
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]*=*$');
    if (!base64Pattern.hasMatch(str)) return false;
    
    // Debe ser lo suficientemente largo para ser una imagen
    return str.length > 100;
  }

  /// Obtiene la ruta de imagen con prioridad BLOB -> URL -> placeholder
  static String _getImagePath(Map<String, dynamic> data) {
    // 1. Intentar usar BLOB de BD primero
    final blobData = _processBlobData(data['banner_image']);
    if (blobData != null && blobData.isNotEmpty) {
      return blobData;
    }
    
    // 2. Usar URL si está disponible
    final imageUrl = data['imagen'];
    if (imageUrl != null && imageUrl.toString().isNotEmpty) {
      return _mapImagePath(imageUrl.toString());
    }
    
    // 3. Fallback a placeholder
    return 'assets/images/placeholder.png';
  }

  /// Mapea la imagen del evento a la ruta de assets
  static String _mapImagePath(String? bannerImage) {
    if (bannerImage == null || bannerImage.isEmpty) {
      return 'assets/images/placeholder.png';
    }
    
    // Si es una URL completa, usarla directamente
    if (bannerImage.startsWith('http')) {
      return bannerImage;
    }
    
    // Si es base64, retornar tal como está
    if (bannerImage.startsWith('data:image/')) {
      return bannerImage;
    }
    
    // Si no, mapear a assets locales
    return 'assets/images/$bannerImage';
  }

  /// Formatea fecha desde string
  static String _formatDate(dynamic dateValue) {
    if (dateValue == null) return 'Fecha por definir';
    
    try {
      if (dateValue is String) {
        final date = DateTime.parse(dateValue);
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      // Si no puede parsear, retornar el valor original
    }
    
    return dateValue.toString();
  }

  /// Formatea hora desde string
  static String _formatTime(dynamic timeValue) {
    if (timeValue == null) return 'Hora por definir';
    
    try {
      if (timeValue is String) {
        // Si es formato HH:mm:ss, tomar solo HH:mm
        if (timeValue.contains(':')) {
          final parts = timeValue.split(':');
          if (parts.length >= 2) {
            return '${parts[0]}:${parts[1]}';
          }
        }
      }
    } catch (e) {
      // Si no puede parsear, retornar el valor original
    }
    
    return timeValue.toString();
  }

  /// Formatea precio
  static String _formatPrice(dynamic price) {
    if (price == null || price == 0) return 'Gratuito';
    
    try {
      final numPrice = double.parse(price.toString());
      if (numPrice == 0) return 'Gratuito';
      return '\$${numPrice.toStringAsFixed(2)}';
    } catch (e) {
      return price.toString();
    }
  }
}