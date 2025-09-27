import 'package:festispot/utils/variables.dart';
import 'package:festispot/services/api_service.dart';
import 'package:festispot/utils/image_helper.dart';

// Esta lista ahora se carga dinámicamente desde la base de datos
// Los eventos se obtienen a través de la API usando ApiService.getEventos()
List<Evento> carrusel = [];

/// Carga los eventos desde la API y los convierte al formato del carrusel
Future<List<Evento>> loadEventosFromAPI() async {
  try {
    print('Iniciando carga de eventos desde API...');
    final eventosData = await ApiService.getEventos();
    
    if (eventosData.isEmpty) {
      print('No se encontraron eventos en la respuesta de la API');
      return _createPlaceholderEvents(); // Mostrar eventos placeholder
    }
    
    carrusel = eventosData.map((data) {
      return Evento(
        id: data['id'] ?? 0,
        nombre: data['titulo'] ?? 'Sin título',
        imagen: _mapImagePath(data['banner_image']),
        descripcion: data['descripcion'] ?? 'Sin descripción',
        categoria: data['category'] ?? 'Sin categoría',
        ubicacion: data['venue_name'] ?? 'Sin ubicación',
        fecha: _formatDate(data['fecha_inicio']),
        hora: _formatTime(data['start_time']),
        precio: _formatPrecio(data['precio_entrada']),
        capacidad: data['capacidad_total']?.toString() ?? '500',
        edad: data['edad_minima']?.toString() ?? '0',
        organizador: _formatOrganizadorNombre(data['organizador_nombre'], data['organizador_apellido']),
        organizadorRating: '4.9', // Por defecto - se puede mejorar con datos reales
        organizadorEventos: '120', // Por defecto - se puede mejorar con datos reales
        
        // Nuevos campos de la BD
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
        accesible: data['accessible'] == 1,
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
      );
    }).toList();
    
    print('Eventos cargados exitosamente: ${carrusel.length}');
    return carrusel;
  } catch (e) {
    print('Error al cargar eventos desde la API: $e');
    // En caso de error, devolver eventos placeholder en lugar de lista vacía
    return _createPlaceholderEvents();
  }
}

/// Crea eventos placeholder para mostrar cuando no hay datos
List<Evento> _createPlaceholderEvents() {
  return [
    Evento(
      id: -1,
      nombre: '🎵 Festival de Música',
      imagen: 'assets/images/placeholder.png',
      descripcion: 'Un increíble festival musical está por venir. ¡Mantente atento para más detalles!',
      categoria: 'Festival',
      ubicacion: 'Próximamente',
      fecha: 'Por confirmar',
      hora: 'Por confirmar',
      precio: 'Por confirmar',
      capacidad: '1000',
      edad: '18',
      organizador: 'FestiSpot Team',
      organizadorRating: '5.0',
      organizadorEventos: '50+',
    ),
    Evento(
      id: -2,
      nombre: '🎨 Exposición de Arte',
      imagen: 'assets/images/placeholder.png',
      descripcion: 'Una extraordinaria exposición de arte contemporáneo. ¡No te la pierdas!',
      categoria: 'Arte',
      ubicacion: 'Por confirmar',
      fecha: 'Próximamente',
      hora: 'Por confirmar',
      precio: 'Gratuito',
      capacidad: '500',
      edad: '0',
      organizador: 'FestiSpot Gallery',
      organizadorRating: '4.8',
      organizadorEventos: '30+',
    ),
    Evento(
      id: -3,
      nombre: '🏃‍♂️ Carrera Benéfica',
      imagen: 'assets/images/placeholder.png',
      descripcion: 'Únete a nuestra carrera benéfica por una buena causa. ¡Tu participación cuenta!',
      categoria: 'Deportivo',
      ubicacion: 'Ciudad Central',
      fecha: 'En preparación',
      hora: '07:00',
      precio: '\$25',
      capacidad: '2000',
      edad: '16',
      organizador: 'FestiSpot Sports',
      organizadorRating: '4.9',
      organizadorEventos: '100+',
    ),
  ];
}

/// Mapea la imagen del evento desde BD usando el ImageHelper
String _mapImagePath(String? bannerImage) {
  // Si no hay imagen, usar una imagen placeholder local
  if (bannerImage == null || bannerImage.isEmpty) {
    return 'assets/images/placeholder.png';
  }
  
  // Usar el nuevo helper para obtener la URL desde BD
  final imageUrl = ImageHelper.getImageUrl(bannerImage);
  
  // Si ImageHelper no puede procesar la imagen, usar placeholder
  if (imageUrl.isEmpty) {
    return 'assets/images/placeholder.png';
  }
  
  return imageUrl;
}

/// Formatea el nombre completo del organizador
String _formatOrganizadorNombre(String? nombre, String? apellido) {
  if (nombre == null && apellido == null) return 'FestiSpot Productions';
  if (nombre != null && apellido != null) return '$nombre $apellido';
  return nombre ?? apellido ?? 'FestiSpot Productions';
}

/// Formatea el precio desde la BD
String _formatPrecio(dynamic precio) {
  if (precio == null || precio == 0) return 'Gratuito';
  
  try {
    final precioNum = double.parse(precio.toString());
    if (precioNum == 0) return 'Gratuito';
    return '\$${precioNum.toStringAsFixed(0)}';
  } catch (e) {
    return precio.toString();
  }
}

/// Formatea la fecha desde datetime a string
String _formatDate(String? fechaInicio) {
  if (fechaInicio == null) return 'Por confirmar';
  
  try {
    final date = DateTime.parse(fechaInicio);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  } catch (e) {
    return fechaInicio.split(' ')[0]; // Solo la parte de fecha
  }
}

/// Formatea la hora desde time a string
String _formatTime(String? startTime) {
  if (startTime == null) return 'Por confirmar';
  
  // Si ya es una hora en formato HH:MM, devolverla como está
  if (startTime.contains(':')) {
    return startTime.substring(0, 5); // Solo HH:MM
  }
  
  return startTime;
}
