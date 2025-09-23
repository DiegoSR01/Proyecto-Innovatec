class Evento {
  final int? id;
  final String nombre;
  final String? descripcion;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String? ubicacion;
  final String? imagen;
  final String? bannerImageData; // Para datos BLOB base64 de banner_image
  final String? bannerImageType; // Para tipo MIME de banner_image
  final String? galleryImagesData; // Para datos BLOB base64 de gallery_images
  final String? galleryImagesMetadata; // Para metadatos JSON de galería
  final int? organizadorId;
  final int? categoriaId;
  final double? precio;
  final int? capacidad;
  final String? estado;
  final DateTime? fechaCreacion;

  const Evento({
    this.id,
    required this.nombre,
    this.descripcion,
    this.fechaInicio,
    this.fechaFin,
    this.ubicacion,
    this.imagen,
    this.bannerImageData,
    this.bannerImageType,
    this.galleryImagesData,
    this.galleryImagesMetadata,
    this.organizadorId,
    this.categoriaId,
    this.precio,
    this.capacidad,
    this.estado,
    this.fechaCreacion,
  });

  /// Crea un Evento desde un JSON
  factory Evento.fromJson(Map<String, dynamic> json) {
    return Evento(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      nombre: json['nombre']?.toString() ?? json['titulo']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      fechaInicio: json['fecha_inicio'] != null 
          ? DateTime.tryParse(json['fecha_inicio'].toString())
          : null,
      fechaFin: json['fecha_fin'] != null 
          ? DateTime.tryParse(json['fecha_fin'].toString())
          : null,
      ubicacion: json['ubicacion']?.toString() ?? json['venue_name']?.toString(),
      imagen: json['imagen']?.toString(),
      bannerImageData: json['banner_image']?.toString(),
      bannerImageType: json['banner_image_type']?.toString(),
      galleryImagesData: json['gallery_images']?.toString(),
      galleryImagesMetadata: json['gallery_images_metadata']?.toString(),
      organizadorId: json['organizador_id'] != null 
          ? int.tryParse(json['organizador_id'].toString())
          : null,
      categoriaId: json['categoria_id'] != null 
          ? int.tryParse(json['categoria_id'].toString())
          : null,
      precio: json['precio'] != null 
          ? double.tryParse(json['precio'].toString())
          : null,
      capacidad: json['capacidad'] != null 
          ? int.tryParse(json['capacidad'].toString())
          : json['capacidad_total'] != null 
              ? int.tryParse(json['capacidad_total'].toString())
              : null,
      estado: json['estado']?.toString(),
      fechaCreacion: json['fecha_creacion'] != null 
          ? DateTime.tryParse(json['fecha_creacion'].toString())
          : json['created_at'] != null 
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
    );
  }

  /// Convierte el Evento a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'fecha_fin': fechaFin?.toIso8601String(),
      'ubicacion': ubicacion,
      'imagen': imagen,
      'banner_image': bannerImageData,
      'banner_image_type': bannerImageType,
      'gallery_images': galleryImagesData,
      'gallery_images_metadata': galleryImagesMetadata,
      'organizador_id': organizadorId,
      'categoria_id': categoriaId,
      'precio': precio,
      'capacidad': capacidad,
      'estado': estado,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Evento{id: $id, nombre: $nombre, ubicacion: $ubicacion, precio: $precio}';
  }
}
